package com.tlahtolli.api.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.boot.jdbc.DataSourceBuilder;

import javax.sql.DataSource;

@Configuration
public class SQLConfig {

    @Bean
    @Primary
    public DataSource dataSource() {
        return DataSourceBuilder.create()
                .url(Constants.DB_URL)
                .username(Constants.DB_USERNAME)
                .password(Constants.DB_PASSWORD)
                .driverClassName(Constants.DB_DRIVER)
                .build();
    }
}
