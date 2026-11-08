package com.tlahtolli.api.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                    // Público siempre: monitor externo (UptimeRobot) y warm-up del frontend.
                    // Debe quedar antes de cualquier regla que exija autenticación.
                    .requestMatchers("/api/health").permitAll()
                    .anyRequest().permitAll());
        return http.build();
    }
}
