package com.tlahtolli.api.service;

import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

/**
 * Evita aplicar dos veces lo que el teléfono envía al reconectar.
 *
 * Cada envío hecho sin conexión lleva un id generado en el teléfono (clientId). Antes de aplicarlo se "reclama"
 * en ta_sync_ops: si ya estaba, es un reintento y se ignora. Si al aplicarlo algo falla, se libera para que el
 * siguiente reintento sí pase. Los envíos sin clientId (versiones viejas del front) se aplican siempre.
 */
@Service
public class SyncOpService {

    private static final Logger log = LoggerFactory.getLogger(SyncOpService.class);

    public static final String LESSON = "lesson";
    public static final String QUICK = "quick";
    public static final String ENERGY = "energy";

    private final JdbcTemplate jdbc;

    public SyncOpService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    /** true si este clientId es nuevo y hay que aplicarlo; false si ya se aplicó antes. */
    public boolean claim(String clientId, Integer userId, String kind) {
        UUID id = parse(clientId);
        if (id == null) return true;
        int rows = jdbc.update(
                "insert into ta_sync_ops (client_id, user_id, kind) values (?, ?, ?) on conflict (client_id) do nothing",
                id, userId, kind);
        if (rows == 0) log.info("[sync] {} {} de userId={} ya se había aplicado; se ignora", kind, id, userId);
        return rows > 0;
    }

    /** Si aplicar el envío falló, se borra el reclamo para que el reintento pueda aplicarlo. */
    public void release(String clientId) {
        UUID id = parse(clientId);
        if (id != null) jdbc.update("delete from ta_sync_ops where client_id = ?", id);
    }

    private static UUID parse(String clientId) {
        if (clientId == null || clientId.isBlank()) return null;
        try {
            return UUID.fromString(clientId);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("clientId inválido");
        }
    }
}
