package com.tlahtolli.api.config;

import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.env.Environment;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

/**
 * Conexión a PostgreSQL. Las credenciales se leen de variables de entorno, nunca del código:
 *
 *   DB_URL       jdbc:postgresql://<host>-pooler.<region>.aws.neon.tech/neondb?sslmode=require
 *   DB_USERNAME  neondb_owner
 *   DB_PASSWORD  (la contraseña de Neon)
 *
 * En Render: Dashboard → servicio → Environment. En local: variables del sistema o
 * la configuración de ejecución del IDE.
 *
 * Pool pequeño a propósito: en los planes gratuitos de Render y Neon más conexiones no
 * dan más velocidad, solo más memoria. Usa el host "-pooler" de Neon (PgBouncer).
 *
 * Pool que se vacía solo: Neon apaga la base tras 5 minutos sin conexiones, y el plan gratis cobra
 * cada minuto encendida (100 CU-h al mes). Con conexiones mínimas en 0, las que no se usan se cierran a
 * los DB_IDLE_TIMEOUT_MS y Neon puede dormirse aunque el back siga despierto (UptimeRobot).
 * La primera consulta tras dormir tarda ~1 s más mientras Neon despierta.
 *
 *   DB_POOL_SIZE        máximo de conexiones (5)
 *   DB_MIN_IDLE         conexiones que se quedan abiertas sin uso (0 = ninguna)
 *   DB_IDLE_TIMEOUT_MS  tras cuánto sin uso se cierra una conexión (60000 = 1 min; mínimo 10000)
 */
@Configuration
public class SQLConfig {

    private final Environment env;

    public SQLConfig(Environment env) {
        this.env = env;
    }

    @Bean
    @Primary
    public DataSource dataSource() {
        HikariConfig cfg = new HikariConfig();
        cfg.setJdbcUrl(required("DB_URL"));
        cfg.setUsername(required("DB_USERNAME"));
        cfg.setPassword(required("DB_PASSWORD"));
        cfg.setDriverClassName("org.postgresql.Driver");
        cfg.setMaximumPoolSize(env.getProperty("DB_POOL_SIZE", Integer.class, 5));
        cfg.setMinimumIdle(env.getProperty("DB_MIN_IDLE", Integer.class, 0));
        cfg.setConnectionTimeout(30_000);   // Neon puede tardar en despertar
        cfg.setIdleTimeout(Math.max(10_000L, env.getProperty("DB_IDLE_TIMEOUT_MS", Long.class, 60_000L)));
        cfg.setMaxLifetime(1_500_000);
        cfg.setKeepaliveTime(0);            // sin "pings" a conexiones inactivas: despertarían a Neon
        cfg.setPoolName("tlahtolcalli-pool");
        return new HikariDataSource(cfg);
    }

    private String required(String key) {
        String v = env.getProperty(key);
        if (v == null || v.isBlank())
            throw new IllegalStateException("Falta la variable de entorno " + key + " (ver SQLConfig)");
        return v;
    }
}
