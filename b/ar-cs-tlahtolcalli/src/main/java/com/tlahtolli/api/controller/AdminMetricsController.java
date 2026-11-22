package com.tlahtolli.api.controller;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.tlahtolli.api.metrics.MetricsService;
import com.tlahtolli.api.metrics.NeonUsageService;

/** Métricas para el monitor. Solo administradores (regla /api/admin/** en SecurityConfig). */
@RestController
@RequestMapping("/api/admin")
public class AdminMetricsController {

    private final MetricsService metrics;
    private final NeonUsageService neon;

    public AdminMetricsController(MetricsService metrics, NeonUsageService neon) {
        this.metrics = metrics;
        this.neon = neon;
    }

    /** Consumo del mes en Neon (CU-h) y proyección. ?refresh=true ignora la caché de 5 minutos. */
    @GetMapping("/neon-usage")
    public Map<String, Object> neonUsage(@RequestParam(defaultValue = "false") boolean refresh) {
        return neon.usage(refresh);
    }

    @GetMapping("/metrics")
    public Map<String, Object> metrics() {
        return metrics.all();
    }
}
