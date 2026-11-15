package com.tlahtolli.api.config;

import static org.springframework.http.HttpMethod.DELETE;
import static org.springframework.http.HttpMethod.GET;
import static org.springframework.http.HttpMethod.OPTIONS;
import static org.springframework.http.HttpMethod.POST;
import static org.springframework.http.HttpMethod.PUT;

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.tlahtolli.api.security.JwtAuthFilter;
import com.tlahtolli.api.security.OwnershipInterceptor;

/**
 * Reglas de acceso.
 *
 * Público ........ health, login, registro, monitor (/view) y lectura del contenido de los cursos.
 * Usuario ........ sus propios datos: perfil, energía, progreso, estadísticas, historial, logros
 *                  (el OwnershipInterceptor revisa que el userId sea el del token).
 * Administrador .. listas completas de usuarios, crear/editar/borrar contenido, /api/admin/**.
 *
 * Sin sesiones: cada petición trae "Authorization: Bearer <token>" (ver TokenService).
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig implements WebMvcConfigurer {

    /** Contenido de los cursos: lectura pública, escritura solo admin. */
    private static final String[] CATALOGO = {
            "/api/languages/**", "/api/levels/**", "/api/units/**", "/api/exercises/**",
            "/api/vocabulary/**", "/api/writing-systems/**", "/api/lessons/**", "/api/achievements/**" };

    private final JwtAuthFilter jwtAuthFilter;
    private final OwnershipInterceptor ownershipInterceptor;

    public SecurityConfig(JwtAuthFilter jwtAuthFilter, OwnershipInterceptor ownershipInterceptor) {
        this.jwtAuthFilter = jwtAuthFilter;
        this.ownershipInterceptor = ownershipInterceptor;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())                       // API sin cookies: CSRF no aplica
            .cors(Customizer.withDefaults())                    // usa CorsConfig
            .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .httpBasic(b -> b.disable())
            .formLogin(f -> f.disable())
            .authorizeHttpRequests(auth -> auth
                    .requestMatchers(OPTIONS, "/**").permitAll()
                    // Público
                    .requestMatchers("/api/health").permitAll()
                    .requestMatchers(POST, "/api/auth/login").permitAll()
                    .requestMatchers(POST, "/api/users").permitAll()                 // registro
                    .requestMatchers("/", "/view", "/error", "/favicon/**", "/css/**", "/js/**", "/img/**").permitAll()
                    .requestMatchers(GET, CATALOGO).permitAll()
                    .requestMatchers(GET, "/api/learning/units/**").permitAll()      // ejercicios y vocabulario
                    // Solo administrador
                    .requestMatchers("/api/admin/**").hasRole("ADMIN")
                    .requestMatchers(POST, CATALOGO).hasRole("ADMIN")
                    .requestMatchers(PUT, CATALOGO).hasRole("ADMIN")
                    .requestMatchers(DELETE, CATALOGO).hasRole("ADMIN")
                    .requestMatchers(GET, "/api/users").hasRole("ADMIN")
                    .requestMatchers(DELETE, "/api/users/**").hasRole("ADMIN")
                    .requestMatchers(PUT, "/api/energy/user/*/set").hasRole("ADMIN")
                    .requestMatchers(POST, "/api/user-stats", "/api/lesson-history").hasRole("ADMIN")
                    .requestMatchers(PUT, "/api/user-stats/**").hasRole("ADMIN")
                    // Todo lo demás: usuario con sesión (y el interceptor revisa que sean sus datos)
                    .anyRequest().authenticated())
            .exceptionHandling(e -> e
                    .authenticationEntryPoint((req, res, ex) -> json(res, 401, "Inicia sesión para continuar"))
                    .accessDeniedHandler((req, res, ex) -> json(res, 403, "No tienes permiso para esta acción")))
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }

    /** El filtro solo corre dentro de la cadena de Spring Security, no como filtro suelto del servidor. */
    @Bean
    public FilterRegistrationBean<JwtAuthFilter> jwtFilterRegistration(JwtAuthFilter filter) {
        FilterRegistrationBean<JwtAuthFilter> r = new FilterRegistrationBean<>(filter);
        r.setEnabled(false);
        return r;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(ownershipInterceptor).addPathPatterns("/api/**");
    }

    private static void json(jakarta.servlet.http.HttpServletResponse res, int status, String msg) throws java.io.IOException {
        res.setStatus(status);
        res.setContentType(MediaType.APPLICATION_JSON_VALUE);
        res.setCharacterEncoding("UTF-8");
        res.getWriter().write("{\"error\":\"" + msg + "\"}");
    }
}
