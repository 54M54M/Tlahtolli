package com.tlahtolli.api.metrics;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Consumo del mes en Neon (plan gratis: 100 CU-h por proyecto; al llegar al límite la base se apaga hasta el
 * siguiente periodo). Lo lee de la API de Neon, que no despierta la base.
 *
 *   NEON_API_KEY          Neon → Account settings → API keys (solo lectura basta)
 *   NEON_PROJECT_ID       Neon → Settings → General (p. ej. sparkling-bonus-…)
 *   NEON_CU_HOURS_LIMIT   límite del plan (100)
 *
 * Sin NEON_API_KEY / NEON_PROJECT_ID responde { configured: false } y el monitor muestra cómo configurarlo.
 * Se guarda 5 minutos en memoria para no gastar el límite de peticiones de la API.
 */
@Service
public class NeonUsageService {

    private static final Logger log = LoggerFactory.getLogger(NeonUsageService.class);
    private static final Duration CACHE = Duration.ofMinutes(5);
    private static final String API = "https://console.neon.tech/api/v2/projects/";

    private final String apiKey;
    private final String projectId;
    private final double limitHours;
    private final ObjectMapper json = new ObjectMapper();
    private final HttpClient http = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(5)).build();

    private volatile Map<String, Object> cached;
    private volatile Instant cachedAt = Instant.EPOCH;

    public NeonUsageService(Environment env) {
        this.apiKey = env.getProperty("NEON_API_KEY", "").trim();
        this.projectId = env.getProperty("NEON_PROJECT_ID", "").trim();
        this.limitHours = env.getProperty("NEON_CU_HOURS_LIMIT", Double.class, 100.0);
    }

    public Map<String, Object> usage(boolean refresh) {
        if (apiKey.isEmpty() || projectId.isEmpty()) return Map.of("configured", false);
        if (!refresh && cached != null && cachedAt.plus(CACHE).isAfter(Instant.now())) return cached;
        try {
            HttpRequest req = HttpRequest.newBuilder(URI.create(API + projectId))
                    .timeout(Duration.ofSeconds(10))
                    .header("Authorization", "Bearer " + apiKey)
                    .header("Accept", "application/json")
                    .GET().build();
            HttpResponse<String> res = http.send(req, HttpResponse.BodyHandlers.ofString());
            if (res.statusCode() != 200) {
                log.warn("[neon] la API respondió {}", res.statusCode());
                return error("La API de Neon respondió " + res.statusCode()
                        + (res.statusCode() == 401 ? " (revisa NEON_API_KEY)" : res.statusCode() == 404 ? " (revisa NEON_PROJECT_ID)" : ""));
            }
            Map<String, Object> m = build(json.readTree(res.body()).path("project"));
            cached = m;
            cachedAt = Instant.now();
            return m;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return error("Consulta interrumpida");
        } catch (Exception e) {
            log.warn("[neon] no se pudo leer el consumo: {}", e.getMessage());
            return error("No se pudo consultar la API de Neon");
        }
    }

    private Map<String, Object> build(JsonNode p) {
        double cuHours = p.path("compute_time_seconds").asDouble(0) / 3600.0;
        double activeHours = p.path("active_time_seconds").asDouble(0) / 3600.0;
        Instant start = instant(p, "consumption_period_start");
        Instant end = instant(p, "quota_reset_at");
        if (end == null) end = instant(p, "consumption_period_end");
        Instant now = Instant.now();

        Map<String, Object> m = new LinkedHashMap<>();
        m.put("configured", true);
        m.put("cuHours", round(cuHours));
        m.put("limitHours", limitHours);
        m.put("percent", round(cuHours / limitHours * 100));
        m.put("activeHours", round(activeHours));
        m.put("transferMb", round(p.path("data_transfer_bytes").asDouble(0) / 1_048_576.0));
        m.put("periodStart", start);
        m.put("resetAt", end);
        m.put("lastActiveAt", instant(p, "compute_last_active_at"));

        // Ritmo del periodo: si sigue igual, ¿alcanza hasta el reinicio? ¿cuándo se acabaría?
        if (start != null && end != null && now.isAfter(start)) {
            double elapsedH = Duration.between(start, now).toSeconds() / 3600.0;
            double totalH = Duration.between(start, end).toSeconds() / 3600.0;
            double perDay = elapsedH > 0 ? cuHours / elapsedH * 24 : 0;
            m.put("perDay", round(perDay));
            m.put("projected", round(perDay / 24 * totalH));
            if (perDay > 0 && cuHours < limitHours) {
                Instant exhaust = now.plusSeconds((long) ((limitHours - cuHours) / perDay * 86_400));
                m.put("exhaustAt", exhaust.isBefore(end) ? exhaust : null);
            }
        }
        m.put("checkedAt", now);
        return m;
    }

    private static Map<String, Object> error(String message) {
        return Map.of("configured", true, "error", message);
    }

    private static Instant instant(JsonNode p, String field) {
        String v = p.path(field).asText(null);
        if (v == null || v.isBlank()) return null;
        try {
            return Instant.parse(v);
        } catch (Exception e) {
            return null;
        }
    }

    private static double round(double v) {
        return Math.round(v * 100.0) / 100.0;
    }
}
