package com.tlahtolli.api.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.util.Map;

/**
 * Endpoint de salud para el monitor externo (UptimeRobot) y el warm-up del frontend.
 * Mantiene despierto el servicio en Render (free duerme tras 15 min sin tráfico entrante).
 * No toca la base de datos a propósito: así no mantiene despierto el cómputo de Neon.
 * Spring responde HEAD automáticamente para un @GetMapping.
 */
@RestController
@RequestMapping("/api/health")
public class HealthController {

    @GetMapping
    public Map<String, Object> health() {
        return Map.of(
                "status", "UP",
                "timestamp", Instant.now().toString()
        );
    }
}
