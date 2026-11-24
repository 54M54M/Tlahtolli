package com.tlahtolli.api.security;

import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * Versión de sesión de cada usuario (ta_users.token_version). Cada token lleva la versión con la que se emitió
 * (claim "tv"); si ya no coincide —porque se restableció la contraseña— el token deja de valer.
 *
 * Se guarda en memoria 10 minutos para no consultar la base en cada petición (Render corre una sola instancia,
 * así que al restablecer se actualiza aquí mismo y el cierre es inmediato). Si la base no responde, deja pasar:
 * la app no funcionaría de todos modos y así no se cierra la sesión a nadie por un error temporal.
 */
@Component
public class SessionVersions {

    private static final Logger log = LoggerFactory.getLogger(SessionVersions.class);
    private static final Duration TTL = Duration.ofMinutes(10);

    private record Entry(Integer version, Instant at) {}

    private final JdbcTemplate jdbc;
    private final Map<Integer, Entry> cache = new ConcurrentHashMap<>();

    public SessionVersions(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    /** ¿El token (emitido con la versión tv) sigue vigente? Falso si la versión cambió o el usuario ya no existe. */
    public boolean isCurrent(Integer userId, int tv) {
        Entry e = cache.get(userId);
        if (e == null || e.at().plus(TTL).isBefore(Instant.now())) {
            try {
                List<Integer> rows = jdbc.queryForList("select token_version from ta_users where id = ?", Integer.class, userId);
                e = new Entry(rows.isEmpty() ? null : (rows.get(0) == null ? 0 : rows.get(0)), Instant.now());
                cache.put(userId, e);
            } catch (Exception ex) {
                log.warn("[sesiones] no se pudo leer la versión de userId={}: {}", userId, ex.getMessage());
                return true;
            }
        }
        return e.version() != null && e.version() == tv;
    }

    /** Al restablecer la contraseña: la nueva versión vale desde ya. */
    public void update(Integer userId, int version) {
        cache.put(userId, new Entry(version, Instant.now()));
    }
}
