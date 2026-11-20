package com.tlahtolli.api.controller;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.tlahtolli.api.config.CacheConfig;
import com.tlahtolli.api.entity.Language;
import com.tlahtolli.api.repository.ExerciseRepository;
import com.tlahtolli.api.repository.LanguageRepository;
import com.tlahtolli.api.service.CourseAccess;

/**
 * Gestión de cursos desde el monitor: ver todos (en pruebas y publicados) y cambiar su estado.
 * Solo administradores (regla /api/admin/** en SecurityConfig).
 */
@RestController
@RequestMapping("/api/admin/courses")
public class AdminCourseController {

    private final LanguageRepository languageRepo;
    private final ExerciseRepository exerciseRepo;
    private final CourseAccess courses;

    public AdminCourseController(LanguageRepository languageRepo, ExerciseRepository exerciseRepo, CourseAccess courses) {
        this.languageRepo = languageRepo;
        this.exerciseRepo = exerciseRepo;
        this.courses = courses;
    }

    /** Todos los cursos con su estado y cuánto contenido tienen. */
    @GetMapping
    public List<Map<String, Object>> list() {
        Map<Integer, Integer> levelLang = courses.levelLanguage();
        Map<Integer, Integer> unitLevel = courses.unitLevel();

        Map<Integer, Integer> levels = new HashMap<>();
        levelLang.values().forEach(lang -> levels.merge(lang, 1, Integer::sum));

        Map<Integer, Integer> units = new HashMap<>();
        unitLevel.values().forEach(level -> {
            Integer lang = levelLang.get(level);
            if (lang != null) units.merge(lang, 1, Integer::sum);
        });

        Map<Integer, Long> exercises = new HashMap<>();
        for (Object[] row : exerciseRepo.countGroupedByUnit()) {
            Integer level = unitLevel.get(((Number) row[0]).intValue());
            Integer lang = level == null ? null : levelLang.get(level);
            if (lang != null) exercises.merge(lang, ((Number) row[1]).longValue(), Long::sum);
        }

        return courses.allLanguages().stream().map(l -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", l.getId());
            m.put("code", l.getCode());
            m.put("langName", l.getLangName());
            m.put("nativeName", l.getNativeName());
            m.put("family", l.getFamily());
            m.put("flag", l.getFlag());
            m.put("status", l.getStatus());
            m.put("levels", levels.getOrDefault(l.getId(), 0));
            m.put("units", units.getOrDefault(l.getId(), 0));
            m.put("exercises", exercises.getOrDefault(l.getId(), 0L));
            return m;
        }).toList();
    }

    public record StatusRequest(String status) {}

    /** draft ⇄ published. Vacía la caché: el cambio se ve al instante en los fronts. */
    @CacheEvict(cacheNames = CacheConfig.CATALOGO, allEntries = true)
    @PutMapping("/{id}/status")
    public Map<String, Object> changeStatus(@PathVariable Long id, @RequestBody StatusRequest body) {
        String status = body == null || body.status() == null ? "" : body.status().trim().toLowerCase();
        if (!Language.STATUS_DRAFT.equals(status) && !Language.STATUS_PUBLISHED.equals(status)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Estado inválido: usa 'draft' o 'published'");
        }
        Language lang = languageRepo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Curso no encontrado"));
        lang.setStatus(status);
        languageRepo.save(lang);
        return Map.of("id", lang.getId(), "code", lang.getCode(), "status", status);
    }
}
