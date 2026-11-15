package com.tlahtolli.api.metrics;

import java.lang.management.ManagementFactory;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Supplier;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.zaxxer.hikari.HikariDataSource;

/**
 * Junta las métricas que se muestran en el monitor. Cada fuente es independiente:
 * si una falla o no está configurada, las demás se muestran igual.
 *
 * Fuentes externas (opcionales, se activan con variables de entorno en Render):
 *   UPTIMEROBOT_API_KEY                 disponibilidad y tiempos de respuesta
 *   NETLIFY_TOKEN + NETLIFY_SITE_ID     últimos despliegues del frontend
 *   RENDER_API_KEY + RENDER_SERVICE_ID  últimos despliegues del backend
 *   NEON_API_KEY + NEON_PROJECT_ID      datos del proyecto en Neon
 *
 * Las respuestas externas se guardan 60 s para no gastar los límites de cada API.
 */
@Service
public class MetricsService {

    private static final Logger log = LoggerFactory.getLogger(MetricsService.class);
    private static final Duration TTL = Duration.ofSeconds(60);
    private static final Duration TIMEOUT = Duration.ofSeconds(6);

    private final Environment env;
    private final JdbcTemplate jdbc;
    private final DataSource dataSource;
    private final RequestMetricsFilter requests;
    private final ObjectMapper mapper = new ObjectMapper();
    private final HttpClient http = HttpClient.newBuilder().connectTimeout(TIMEOUT).build();
    private final Map<String, Cached> cache = new ConcurrentHashMap<>();

    private record Cached(Instant at, Object value) {}

    public MetricsService(Environment env, JdbcTemplate jdbc, DataSource dataSource, RequestMetricsFilter requests) {
        this.env = env;
        this.jdbc = jdbc;
        this.dataSource = dataSource;
        this.requests = requests;
    }

    public Map<String, Object> all() {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("generatedAt", Instant.now().toString());
        out.put("server", safe(this::server));
        out.put("requests", safe(requests::snapshot));
        out.put("database", safe(this::database));
        out.put("uptimeRobot", cached("uptime", this::uptimeRobot));
        out.put("netlify", cached("netlify", this::netlify));
        out.put("render", cached("render", this::render));
        out.put("neon", cached("neon", this::neon));
        return out;
    }

    // ── Servidor (JVM en Render) ─────────────────────────────────────────────
    private Map<String, Object> server() {
        Runtime rt = Runtime.getRuntime();
        var os = ManagementFactory.getOperatingSystemMXBean();
        var threads = ManagementFactory.getThreadMXBean();
        Map<String, Object> m = new LinkedHashMap<>();
        // Render define RENDER=true en sus contenedores; si no está, es una ejecución local
        boolean onRender = "true".equalsIgnoreCase(System.getenv("RENDER"));
        m.put("environment", onRender ? "Render" : "Local");
        m.put("host", onRender ? System.getenv("RENDER_SERVICE_NAME") : System.getenv().getOrDefault("COMPUTERNAME", "este equipo"));
        m.put("uptimeSeconds", ManagementFactory.getRuntimeMXBean().getUptime() / 1000);
        m.put("javaVersion", System.getProperty("java.version"));
        m.put("cpus", rt.availableProcessors());
        m.put("heapUsedMb", (rt.totalMemory() - rt.freeMemory()) / 1_048_576);
        m.put("heapMaxMb", rt.maxMemory() / 1_048_576);
        m.put("threads", threads.getThreadCount());
        m.put("systemLoad", os.getSystemLoadAverage());
        if (os instanceof com.sun.management.OperatingSystemMXBean sun) {
            m.put("processCpu", round(sun.getProcessCpuLoad() * 100));
            m.put("systemCpu", round(sun.getCpuLoad() * 100));
            m.put("systemMemTotalMb", sun.getTotalMemorySize() / 1_048_576);
            m.put("systemMemFreeMb", sun.getFreeMemorySize() / 1_048_576);
        }
        if (dataSource instanceof HikariDataSource h && h.getHikariPoolMXBean() != null) {
            var p = h.getHikariPoolMXBean();
            m.put("poolActive", p.getActiveConnections());
            m.put("poolIdle", p.getIdleConnections());
            m.put("poolTotal", p.getTotalConnections());
            m.put("poolWaiting", p.getThreadsAwaitingConnection());
            m.put("poolMax", h.getMaximumPoolSize());
        }
        return m;
    }

    // ── Base de datos (consultas directas a Postgres) ────────────────────────
    private Map<String, Object> database() {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("version", jdbc.queryForObject("select split_part(version(), ' ', 2)", String.class));
        m.put("database", jdbc.queryForObject("select current_database()", String.class));
        m.put("sizeMb", jdbc.queryForObject("select round(pg_database_size(current_database()) / 1048576.0, 2)", Double.class));
        m.put("connections", jdbc.queryForList(
                "select coalesce(state, 'otro') as state, count(1) as total from pg_stat_activity "
              + "where datname = current_database() group by 1 order by 2 desc"));
        m.put("stats", jdbc.queryForMap(
                "select xact_commit as commits, xact_rollback as rollbacks, deadlocks, "
              + "round(100.0 * blks_hit / nullif(blks_hit + blks_read, 0), 2) as cache_hit_pct, "
              + "stats_reset from pg_stat_database where datname = current_database()"));
        m.put("tables", jdbc.queryForList(
                "select relname as table_name, n_live_tup as row_count, "
              + "round(pg_total_relation_size(relid) / 1024.0, 1) as size_kb "
              + "from pg_stat_user_tables order by pg_total_relation_size(relid) desc limit 15"));
        return m;
    }

    // ── UptimeRobot ──────────────────────────────────────────────────────────
    private Object uptimeRobot() throws Exception {
        String key = env.getProperty("UPTIMEROBOT_API_KEY");
        if (blank(key)) return notConfigured("UPTIMEROBOT_API_KEY");
        String form = "api_key=" + URLEncoder.encode(key, StandardCharsets.UTF_8)
                + "&format=json&custom_uptime_ratios=1-7-30&response_times=1&response_times_limit=24&logs=1&logs_limit=5";
        HttpRequest req = HttpRequest.newBuilder(URI.create("https://api.uptimerobot.com/v2/getMonitors"))
                .timeout(TIMEOUT).header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(form)).build();
        JsonNode root = send(req);
        List<Map<String, Object>> monitors = new ArrayList<>();
        for (JsonNode mon : root.path("monitors")) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("name", mon.path("friendly_name").asText());
            m.put("url", mon.path("url").asText());
            m.put("status", switch (mon.path("status").asInt()) {
                case 2 -> "up"; case 8 -> "seems_down"; case 9 -> "down"; case 0 -> "paused"; default -> "unknown"; });
            String[] ratios = mon.path("custom_uptime_ratio").asText("").split("-");
            m.put("uptime24h", ratios.length > 0 ? ratios[0] : null);
            m.put("uptime7d", ratios.length > 1 ? ratios[1] : null);
            m.put("uptime30d", ratios.length > 2 ? ratios[2] : null);
            m.put("avgResponseMs", mon.path("average_response_time").asText(null));
            List<Map<String, Object>> rt = new ArrayList<>();
            for (JsonNode r : mon.path("response_times"))
                rt.add(Map.of("at", r.path("datetime").asLong(), "ms", r.path("value").asLong()));
            m.put("responseTimes", rt);
            List<Map<String, Object>> logs = new ArrayList<>();
            for (JsonNode l : mon.path("logs"))
                logs.add(Map.of("type", l.path("type").asInt(), "at", l.path("datetime").asLong(), "durationS", l.path("duration").asLong()));
            m.put("logs", logs);
            monitors.add(m);
        }
        return Map.of("ok", true, "monitors", monitors);
    }

    // ── Netlify (frontend) ───────────────────────────────────────────────────
    private Object netlify() throws Exception {
        String token = env.getProperty("NETLIFY_TOKEN"), site = env.getProperty("NETLIFY_SITE_ID");
        if (blank(token) || blank(site)) return notConfigured("NETLIFY_TOKEN y NETLIFY_SITE_ID");
        JsonNode deploys = send(get("https://api.netlify.com/api/v1/sites/" + site + "/deploys?per_page=8", token));
        List<Map<String, Object>> rows = new ArrayList<>();
        for (JsonNode d : deploys) {
            Map<String, Object> r = new LinkedHashMap<>();
            r.put("state", d.path("state").asText());
            r.put("context", d.path("context").asText());
            r.put("branch", d.path("branch").asText());
            r.put("commit", shortSha(d.path("commit_ref").asText(null)));
            r.put("title", d.path("title").asText(null));
            r.put("createdAt", d.path("created_at").asText(null));
            r.put("deploySeconds", d.path("deploy_time").isNumber() ? d.path("deploy_time").asLong() : null);
            r.put("error", d.path("error_message").asText(null));
            rows.add(r);
        }
        return Map.of("ok", true, "deploys", rows);
    }

    // ── Render (backend) ─────────────────────────────────────────────────────
    private Object render() throws Exception {
        String key = env.getProperty("RENDER_API_KEY"), svc = env.getProperty("RENDER_SERVICE_ID");
        if (blank(key) || blank(svc)) return notConfigured("RENDER_API_KEY y RENDER_SERVICE_ID");
        JsonNode list = send(get("https://api.render.com/v1/services/" + svc + "/deploys?limit=8", key));
        List<Map<String, Object>> rows = new ArrayList<>();
        for (JsonNode item : list) {
            JsonNode d = item.has("deploy") ? item.path("deploy") : item;
            Map<String, Object> r = new LinkedHashMap<>();
            r.put("status", d.path("status").asText());
            r.put("trigger", d.path("trigger").asText(null));
            r.put("commit", shortSha(d.path("commit").path("id").asText(null)));
            r.put("message", firstLine(d.path("commit").path("message").asText(null)));
            r.put("createdAt", d.path("createdAt").asText(null));
            r.put("finishedAt", d.path("finishedAt").asText(null));
            rows.add(r);
        }
        return Map.of("ok", true, "deploys", rows);
    }

    // ── Neon (proyecto) ──────────────────────────────────────────────────────
    private Object neon() throws Exception {
        String key = env.getProperty("NEON_API_KEY"), project = env.getProperty("NEON_PROJECT_ID");
        if (blank(key) || blank(project)) return notConfigured("NEON_API_KEY y NEON_PROJECT_ID");
        JsonNode p = send(get("https://console.neon.tech/api/v2/projects/" + project, key)).path("project");
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("ok", true);
        m.put("name", p.path("name").asText(null));
        m.put("region", p.path("region_id").asText(null));
        m.put("pgVersion", p.path("pg_version").asText(null));
        // Campos de uso que Neon reporta en el proyecto (los que no existan en tu plan se omiten)
        for (String f : List.of("active_time_seconds", "compute_time_seconds", "cpu_used_sec",
                "written_data_bytes", "data_transfer_bytes", "synthetic_storage_size",
                "consumption_period_start", "consumption_period_end")) {
            JsonNode v = p.path(f);
            if (!v.isMissingNode() && !v.isNull()) m.put(f, v.isNumber() ? v.numberValue() : v.asText());
        }
        return m;
    }

    // ── utilidades ───────────────────────────────────────────────────────────
    private interface Source { Object get() throws Exception; }

    private Object cached(String key, Source src) {
        Cached c = cache.get(key);
        if (c != null && c.at().plus(TTL).isAfter(Instant.now())) return c.value();
        Object v;
        try {
            v = src.get();
        } catch (Exception e) {
            log.warn("[metrics] {} no respondió: {}", key, e.getMessage());
            v = Map.of("ok", false, "error", String.valueOf(e.getMessage()));
        }
        cache.put(key, new Cached(Instant.now(), v));
        return v;
    }

    private Object safe(Supplier<Object> s) {
        try {
            return s.get();
        } catch (Exception e) {
            log.warn("[metrics] fuente local falló: {}", e.getMessage());
            return Map.of("ok", false, "error", String.valueOf(e.getMessage()));
        }
    }

    private HttpRequest get(String url, String bearer) {
        return HttpRequest.newBuilder(URI.create(url)).timeout(TIMEOUT)
                .header("Authorization", "Bearer " + bearer).header("Accept", "application/json").GET().build();
    }

    private JsonNode send(HttpRequest req) throws Exception {
        HttpResponse<String> res = http.send(req, HttpResponse.BodyHandlers.ofString());
        if (res.statusCode() >= 400) throw new IllegalStateException("HTTP " + res.statusCode());
        return mapper.readTree(res.body());
    }

    private static Map<String, Object> notConfigured(String vars) {
        return Map.of("ok", false, "configured", false, "error", "Falta configurar " + vars);
    }

    private static boolean blank(String s) { return s == null || s.isBlank(); }
    private static String shortSha(String s) { return s == null ? null : s.substring(0, Math.min(7, s.length())); }
    private static String firstLine(String s) { return s == null ? null : s.split("\\R", 2)[0]; }
    private static double round(double v) { return Math.round(v * 10) / 10.0; }
}
