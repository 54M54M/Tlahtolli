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
        cfg.setMinimumIdle(1);
        cfg.setConnectionTimeout(30_000);   // Neon puede tardar en despertar
        cfg.setIdleTimeout(300_000);
        cfg.setMaxLifetime(1_500_000);
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
