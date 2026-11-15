package com.tlahtolli.api.controller;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tlahtolli.api.metrics.MetricsService;

/** Métricas para el monitor. Solo administradores (regla /api/admin/** en SecurityConfig). */
@RestController
@RequestMapping("/api/admin")
public class AdminMetricsController {

    private final MetricsService metrics;

    public AdminMetricsController(MetricsService metrics) {
        this.metrics = metrics;
    }

    @GetMapping("/metrics")
    public Map<String, Object> metrics() {
        return metrics.all();
    }
}
