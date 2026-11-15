package com.tlahtolli.api.metrics;

import java.io.IOException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.LongAccumulator;
import java.util.concurrent.atomic.LongAdder;

import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.servlet.HandlerMapping;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Cuenta las peticiones a /api por endpoint (método + patrón, p. ej. "GET /api/units/{id}"):
 * total, errores 4xx/5xx, tiempo promedio y máximo. Vive en memoria y se reinicia con el servicio.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class RequestMetricsFilter extends OncePerRequestFilter {

    private final Map<String, Stat> stats = new ConcurrentHashMap<>();
    private final Instant since = Instant.now();

    static final class Stat {
        final LongAdder count = new LongAdder();
        final LongAdder errors4xx = new LongAdder();
        final LongAdder errors5xx = new LongAdder();
        final LongAdder totalMs = new LongAdder();
        final LongAccumulator maxMs = new LongAccumulator(Long::max, 0);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest req) {
        return !req.getRequestURI().startsWith("/api/") || "OPTIONS".equalsIgnoreCase(req.getMethod());
    }

    @Override
    protected void doFilterInternal(HttpServletRequest req, HttpServletResponse res, FilterChain chain)
            throws ServletException, IOException {
        long t0 = System.nanoTime();
        try {
            chain.doFilter(req, res);
        } finally {
            long ms = (System.nanoTime() - t0) / 1_000_000;
            Object pattern = req.getAttribute(HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE);
            String path = pattern != null ? pattern.toString() : req.getRequestURI().replaceAll("/\\d+", "/{id}");
            String key = req.getMethod() + " " + path;
            Stat s = stats.computeIfAbsent(key, k -> new Stat());
            s.count.increment();
            s.totalMs.add(ms);
            s.maxMs.accumulate(ms);
            int st = res.getStatus();
            if (st >= 500) s.errors5xx.increment();
            else if (st >= 400) s.errors4xx.increment();
        }
    }

    /** Resumen ordenado por número de peticiones. */
    public Map<String, Object> snapshot() {
        List<Map<String, Object>> rows = new ArrayList<>();
        long total = 0, e4 = 0, e5 = 0, ms = 0;
        for (var e : stats.entrySet()) {
            Stat s = e.getValue();
            long c = s.count.sum();
            total += c; e4 += s.errors4xx.sum(); e5 += s.errors5xx.sum(); ms += s.totalMs.sum();
            Map<String, Object> r = new LinkedHashMap<>();
            r.put("endpoint", e.getKey());
            r.put("count", c);
            r.put("avgMs", c == 0 ? 0 : s.totalMs.sum() / c);
            r.put("maxMs", s.maxMs.get());
            r.put("errors4xx", s.errors4xx.sum());
            r.put("errors5xx", s.errors5xx.sum());
            rows.add(r);
        }
        rows.sort(Comparator.comparingLong(r -> -((Long) r.get("count"))));
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("since", since.toString());
        out.put("total", total);
        out.put("errors4xx", e4);
        out.put("errors5xx", e5);
        out.put("avgMs", total == 0 ? 0 : ms / total);
        out.put("endpoints", rows.size() > 25 ? rows.subList(0, 25) : rows);
        return out;
    }
}
