package com.tlahtolli.api.service;

import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
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
 * Un curso en pruebas solo existe para:
 *   - el front de desarrollo (encabezado X-Tlahtolcalli-Env: dev) con rol 'tester' o 'admin', o
 *   - el monitor (X-Tlahtolcalli-Env: monitor) con rol 'admin'.
 * Un tester con cursos asignados (ta_user_course_access) solo ve esos cursos en pruebas; sin asignación, todos.
 * Los cursos publicados los ve siempre. Pensado para dar acceso a un hablante solo a su curso.
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
    private final JdbcTemplate jdbc;

    /** Cursos asignados por tester, en memoria 5 minutos (una asignación nueva tarda eso en notarse). */
    private static final long ASSIGNED_TTL_MS = 5 * 60 * 1000L;
    private record Assigned(Set<Integer> languageIds, long loadedAt) {}
    private final Map<Integer, Assigned> assigned = new ConcurrentHashMap<>();

    // Proxy de Spring para que las llamadas internas usen la caché
    @Autowired
    @Lazy
    private CourseAccess self;

    public CourseAccess(LanguageRepository languageRepo, LevelRepository levelRepo, UnitRepository unitRepo,
                        JdbcTemplate jdbc) {
        this.languageRepo = languageRepo;
        this.levelRepo = levelRepo;
        this.unitRepo = unitRepo;
        this.jdbc = jdbc;
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

    /**
     * Qué cursos en pruebas puede ver quien hace la petición.
     * X-Tlahtolcalli-Env: dev     → front de desarrollo: admin todos; tester los asignados (o todos si no tiene).
     * X-Tlahtolcalli-Env: monitor → monitor del backend: solo admin.
     * @return null = todos · conjunto vacío = ninguno · ids = solo esos
     */
    private Set<Integer> visibleDrafts() {
        if (!(RequestContextHolder.getRequestAttributes() instanceof ServletRequestAttributes attrs)) return Set.of();
        String env = attrs.getRequest().getHeader(ENV_HEADER);
        if (!"dev".equalsIgnoreCase(env) && !"monitor".equalsIgnoreCase(env)) return Set.of();
        try {
            TokenService.Claims c = CurrentUser.get();
            if (c.isAdmin()) return null;
            if (!"dev".equalsIgnoreCase(env) || !"tester".equalsIgnoreCase(c.role())) return Set.of();
            Set<Integer> mine = assignedTo(c.userId());
            return mine.isEmpty() ? null : mine;
        } catch (ResponseStatusException sinSesion) {
            return Set.of();
        }
    }

    private boolean canSeeDraft(Integer languageId) {
        Set<Integer> drafts = visibleDrafts();
        return drafts == null || drafts.contains(languageId);
    }

    /** Cursos asignados al tester (ta_user_course_access). */
    private Set<Integer> assignedTo(Integer userId) {
        if (userId == null) return Set.of();
        Assigned hit = assigned.get(userId);
        long now = System.currentTimeMillis();
        if (hit != null && now - hit.loadedAt() < ASSIGNED_TTL_MS) return hit.languageIds();
        Set<Integer> ids;
        try {
            // Si la tabla aún no existe (falta correr 1.-esquema.sql) se comporta como antes, sin restricción.
            // to_regclass no falla, así no se aborta la transacción de la petición.
            Boolean exists = jdbc.queryForObject(
                    "select to_regclass('public.ta_user_course_access') is not null", Boolean.class);
            ids = Boolean.TRUE.equals(exists)
                    ? Set.copyOf(new HashSet<>(jdbc.queryForList(
                            "select language_id from ta_user_course_access where user_id = ?", Integer.class, userId)))
                    : Set.of();
        } catch (Exception e) {
            ids = Set.of();
        }
        assigned.put(userId, new Assigned(ids, now));
        return ids;
    }

    // ── Visibilidad ──────────────────────────────────────────────────────────

    public List<Language> visibleLanguages() {
        Set<Integer> drafts = visibleDrafts();
        return self.allLanguages().stream()
                .filter(l -> !l.isDraft() || drafts == null || drafts.contains(l.getId()))
                .toList();
    }

    public boolean isLanguageVisible(Integer languageId) {
        if (languageId == null) return false;
        return self.allLanguages().stream()
                .filter(l -> languageId.equals(l.getId()))
                .findFirst()
                .map(l -> !l.isDraft() || canSeeDraft(l.getId()))
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
