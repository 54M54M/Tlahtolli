package com.tlahtolli.api.service;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.server.ResponseStatusException;

import com.tlahtolli.api.config.CacheConfig;
import com.tlahtolli.api.entity.Language;
import com.tlahtolli.api.entity.Level;
import com.tlahtolli.api.entity.Unit;
import com.tlahtolli.api.repository.LanguageRepository;
import com.tlahtolli.api.repository.LevelRepository;
import com.tlahtolli.api.repository.UnitRepository;
import com.tlahtolli.api.security.CurrentUser;
import com.tlahtolli.api.security.TokenService;

/**
 * Cursos en pruebas (ct_languages.status = 'draft').
 *
 * Un curso en pruebas solo existe para quien cumple las dos condiciones:
 *   1. La petición viene del front de desarrollo (encabezado X-Tlahtolcalli-Env: dev).
 *   2. El usuario del token tiene rol 'tester' o 'admin'.
 * Para todos los demás no aparece en /api/languages y sus niveles, unidades,
 * ejercicios y vocabulario responden 404. Al publicarlo
 * (update ct_languages set status = 'published' ...) aparece en producción.
 */
@Service
public class CourseAccess {

    public static final String ENV_HEADER = "X-Tlahtolcalli-Env";
    private static final String NOT_AVAILABLE = "Este curso no está disponible";

    private final LanguageRepository languageRepo;
    private final LevelRepository levelRepo;
    private final UnitRepository unitRepo;

    // Proxy de Spring para que las llamadas internas usen la caché
    @Autowired
    @Lazy
    private CourseAccess self;

    public CourseAccess(LanguageRepository languageRepo, LevelRepository levelRepo, UnitRepository unitRepo) {
        this.languageRepo = languageRepo;
        this.levelRepo = levelRepo;
        this.unitRepo = unitRepo;
    }

    // ── Catálogo en caché (se vacía junto con el resto del contenido) ─────────

    @Cacheable(cacheNames = CacheConfig.CATALOGO, key = "'idiomas'")
    public List<Language> allLanguages() {
        return List.copyOf(languageRepo.findAll());
    }

    /** levelId → languageId */
    @Cacheable(cacheNames = CacheConfig.CATALOGO, key = "'nivel-idioma'")
    public Map<Integer, Integer> levelLanguage() {
        return Collections.unmodifiableMap(levelRepo.findAll().stream()
                .filter(l -> l.getLanguageId() != null)
                .collect(Collectors.toMap(Level::getId, Level::getLanguageId)));
    }

    /** unitId → levelId */
    @Cacheable(cacheNames = CacheConfig.CATALOGO, key = "'unidad-nivel'")
    public Map<Integer, Integer> unitLevel() {
        return Collections.unmodifiableMap(unitRepo.findAll().stream()
                .filter(u -> u.getLevelId() != null)
                .collect(Collectors.toMap(Unit::getId, Unit::getLevelId)));
    }

    // ── Quién puede ver cursos en pruebas ────────────────────────────────────

    public boolean canSeeDrafts() {
        if (!(RequestContextHolder.getRequestAttributes() instanceof ServletRequestAttributes attrs)) return false;
        if (!"dev".equalsIgnoreCase(attrs.getRequest().getHeader(ENV_HEADER))) return false;
        try {
            TokenService.Claims c = CurrentUser.get();
            return c.isAdmin() || "tester".equalsIgnoreCase(c.role());
        } catch (ResponseStatusException sinSesion) {
            return false;
        }
    }

    // ── Visibilidad ──────────────────────────────────────────────────────────

    public List<Language> visibleLanguages() {
        boolean drafts = canSeeDrafts();
        return self.allLanguages().stream().filter(l -> drafts || !l.isDraft()).toList();
    }

    public boolean isLanguageVisible(Integer languageId) {
        if (languageId == null) return false;
        return self.allLanguages().stream()
                .filter(l -> languageId.equals(l.getId()))
                .findFirst()
                .map(l -> !l.isDraft() || canSeeDrafts())
                .orElse(false);
    }

    public boolean isLevelVisible(Integer levelId) {
        return levelId != null && isLanguageVisible(self.levelLanguage().get(levelId));
    }

    public boolean isUnitVisible(Integer unitId) {
        return unitId != null && isLevelVisible(self.unitLevel().get(unitId));
    }

    // ── Validaciones para los endpoints (404: para quien no puede verlo, no existe) ──

    public void requireLanguage(Integer languageId) {
        if (!isLanguageVisible(languageId)) throw notAvailable();
    }

    public void requireLevel(Integer levelId) {
        if (!isLevelVisible(levelId)) throw notAvailable();
    }

    public void requireUnit(Integer unitId) {
        if (!isUnitVisible(unitId)) throw notAvailable();
    }

    private static ResponseStatusException notAvailable() {
        return new ResponseStatusException(HttpStatus.NOT_FOUND, NOT_AVAILABLE);
    }
}
