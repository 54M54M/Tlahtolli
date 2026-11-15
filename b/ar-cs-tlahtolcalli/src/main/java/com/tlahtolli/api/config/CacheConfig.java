package com.tlahtolli.api.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.concurrent.ConcurrentMapCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

/**
 * Caché en memoria del contenido de los cursos (idiomas, niveles, unidades, ejercicios,
 * vocabulario y sistemas de escritura). Ese contenido casi no cambia, así que se lee de
 * Neon una vez y después se sirve desde memoria.
 *
 * - Los datos del usuario (progreso, energía, estadísticas, historial) NO se guardan aquí.
 * - Cualquier POST/PUT/DELETE de contenido desde la API vacía la caché (@CacheEvict).
 * - Si cargas un seed directo en Neon, la API no se entera: la caché se vacía sola cada
 *   30 minutos, o reinicia el servicio en Render para verlo al instante.
 *
 * No requiere dependencias nuevas: usa ConcurrentMapCacheManager de spring-context.
 */
@Configuration
@EnableCaching
@EnableScheduling
public class CacheConfig {

    private static final Logger log = LoggerFactory.getLogger(CacheConfig.class);

    /** Nombre único de la caché de contenido. */
    public static final String CATALOGO = "catalogo";

    @Bean
    public CacheManager cacheManager() {
        return new ConcurrentMapCacheManager(CATALOGO);
    }

    /** Vacía el catálogo cada 30 minutos (por si se cargó un seed directo en Neon). */
    @Scheduled(fixedRate = 30 * 60 * 1000, initialDelay = 30 * 60 * 1000)
    public void vaciarCatalogo() {
        var cache = cacheManager().getCache(CATALOGO);   // @Configuration: devuelve el mismo bean
        if (cache != null) cache.clear();
        log.info("[cache] catálogo vaciado (programado)");
    }
}
