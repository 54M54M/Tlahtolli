package com.tlahtolli.api.util;

import java.time.LocalDate;
import java.time.ZoneId;

/**
 * Zona horaria de la app (APP_TIMEZONE, por defecto America/Mexico_City). El servidor de Render corre en UTC:
 * sin esto, de 6 pm en adelante "hoy" sería el día siguiente. La usan el día de las lecciones y la racha.
 */
public final class AppTime {

    private static final ZoneId ZONE = ZoneId.of(envOr("APP_TIMEZONE", "America/Mexico_City"));

    private AppTime() {}

    public static ZoneId zone() {
        return ZONE;
    }

    public static LocalDate today() {
        return LocalDate.now(ZONE);
    }

    private static String envOr(String key, String fallback) {
        String v = System.getenv(key);
        if (v == null || v.isBlank()) v = System.getProperty(key);
        return v == null || v.isBlank() ? fallback : v.trim();
    }
}
