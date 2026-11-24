package com.tlahtolli.api.service;

import java.time.Duration;
import java.time.Instant;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.tlahtolli.api.entity.User;

/**
 * Nivel del usuario (ta_users.user_level) a partir de su experiencia total.
 *
 * XP por nivel = lo que vale completar un nivel del curso, tomado de la base:
 *   suma de los puntos de los ejercicios de cada nivel (ct_exercises.points), promedio de los niveles de los
 *   cursos publicados. Hoy: 6 unidades × 6 ejercicios = 36 ejercicios × ~15 puntos ≈ 540 XP.
 * Se guarda 1 hora en memoria (no consulta la base en cada lección). Si cambia el contenido y el valor sube,
 * el nivel guardado nunca baja.
 */
@Service
public class UserLevelService {

    private static final Logger log = LoggerFactory.getLogger(UserLevelService.class);
    private static final Duration TTL = Duration.ofHours(1);
    /** Respaldo si la base no tiene ejercicios o no responde: 15 puntos × 36 ejercicios. */
    public static final int FALLBACK_XP_PER_LEVEL = 540;

    private static final String XP_PER_LEVEL_SQL = """
            select coalesce(round(avg(level_points)), 0)
              from (select lv.id, sum(coalesce(e.points, 0)) as level_points
                      from ct_levels lv
                      join ct_languages lang on lang.id = lv.language_id and lang.status = 'published'
                      join ct_units u        on u.level_id = lv.id
                      join ct_exercises e    on e.unit_id = u.id
                     group by lv.id) x
            """;

    /** Último valor calculado; lo usa UserResponse para armar la barra (respaldo si aún no se calcula). */
    private static volatile int currentXpPerLevel = FALLBACK_XP_PER_LEVEL;

    private final JdbcTemplate jdbc;
    private volatile Instant loadedAt = Instant.EPOCH;

    public UserLevelService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public static int currentXpPerLevel() {
        return currentXpPerLevel;
    }

    /** XP que cuesta cada nivel (de la base, con caché de 1 hora). */
    public int xpPerLevel() {
        if (loadedAt.plus(TTL).isBefore(Instant.now())) {
            try {
                Integer v = jdbc.queryForObject(XP_PER_LEVEL_SQL, Integer.class);
                currentXpPerLevel = v != null && v > 0 ? v : FALLBACK_XP_PER_LEVEL;
            } catch (Exception e) {
                log.warn("[nivel] no se pudo calcular la XP por nivel: {}", e.getMessage());
            }
            loadedAt = Instant.now();
        }
        return currentXpPerLevel;
    }

    /** Actualiza user_level según la XP total (no lo baja). Llamar después de sumar XP. */
    public void apply(User user) {
        int perLevel = xpPerLevel();
        int total = user.getTotalXp() == null ? 0 : user.getTotalXp();
        int level = Math.min(Short.MAX_VALUE, total / perLevel + 1);
        int stored = user.getUserLevel() == null ? 1 : user.getUserLevel();
        user.setUserLevel((short) Math.max(stored, level));
    }

    /** XP dentro del nivel actual (para la barra del perfil). */
    public static int xpInLevel(Integer totalXp, Short userLevel, int perLevel) {
        int total = totalXp == null ? 0 : totalXp;
        int level = userLevel == null ? 1 : userLevel;
        return Math.max(0, Math.min(perLevel, total - (level - 1) * perLevel));
    }
}
