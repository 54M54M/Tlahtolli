package com.tlahtolli.api.config;

import static org.springframework.http.HttpMethod.DELETE;
import static org.springframework.http.HttpMethod.GET;
import static org.springframework.http.HttpMethod.OPTIONS;
import static org.springframework.http.HttpMethod.POST;
import static org.springframework.http.HttpMethod.PUT;

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.http.MediaType;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.tlahtolli.api.security.AdminUserDetailsService;
import com.tlahtolli.api.security.JwtAuthFilter;
import com.tlahtolli.api.security.OwnershipInterceptor;

/**
 *  MONITOR (/monitor, /monitor/**) — con sesión en el servidor.
 *    Sin sesión de administrador, /monitor redirige a /monitor/login: el HTML del monitor
 *    nunca sale del servidor. Login con usuario/contraseña de ta_users y role = 'admin'.
 *    Cookie de sesión HttpOnly + protección CSRF.
 *
 *  API (/api/** y lo demás) — sin sesión, con token (Authorization: Bearer).
 *    Público ........ health, login, registro y lectura del contenido de los cursos.
 *    Usuario ........ sus propios datos (el OwnershipInterceptor revisa el userId).
 *    Administrador .. listas completas, crear/editar/borrar contenido, /api/admin/**.
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
    private final AdminUserDetailsService adminUserDetailsService;

    public SecurityConfig(JwtAuthFilter jwtAuthFilter, OwnershipInterceptor ownershipInterceptor,
                          AdminUserDetailsService adminUserDetailsService) {
        this.jwtAuthFilter = jwtAuthFilter;
        this.ownershipInterceptor = ownershipInterceptor;
        this.adminUserDetailsService = adminUserDetailsService;
    }

    /** Mismo algoritmo con el que UserService guarda las contraseñas (BCrypt). */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // ── 1) Monitor ─────────────────────────────────────────────────────────────
    @Bean
    @Order(1)
    public SecurityFilterChain monitorChain(HttpSecurity http) throws Exception {
        http
            .securityMatcher("/monitor", "/monitor/**")
            .userDetailsService(adminUserDetailsService)    // solo ta_users con role = 'admin'
            .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
                    .sessionFixation(f -> f.migrateSession()))
            .authorizeHttpRequests(auth -> auth
                    .requestMatchers("/monitor/login", "/monitor/assets/**").permitAll()
                    .anyRequest().hasRole("ADMIN"))
            .formLogin(f -> f
                    .loginPage("/monitor/login")               // GET: formulario
                    .loginProcessingUrl("/monitor/login")      // POST: validación
                    .defaultSuccessUrl("/monitor", true)
                    .failureUrl("/monitor/login?error"))
            .logout(l -> l
                    .logoutUrl("/monitor/logout")              // POST con token CSRF
                    .logoutSuccessUrl("/monitor/login?logout")
                    .deleteCookies("JSESSIONID")
                    .invalidateHttpSession(true))
            .exceptionHandling(e -> e.accessDeniedPage("/monitor/login?denied"));
        return http.build();
    }

    // ── 2) API ─────────────────────────────────────────────────────────────────
    @Bean
    @Order(2)
    public SecurityFilterChain apiChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())                       // API sin cookies: CSRF no aplica
            .cors(Customizer.withDefaults())                    // usa CorsConfig
            .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .httpBasic(b -> b.disable())
            .formLogin(f -> f.disable())
            .authorizeHttpRequests(auth -> auth
                    .requestMatchers(OPTIONS, "/**").permitAll()
                    // Público
                    .requestMatchers("/api/health", "/error", "/favicon.ico").permitAll()
                    .requestMatchers(POST, "/api/auth/login").permitAll()
                    .requestMatchers(POST, "/api/users").permitAll()                 // registro
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
                    // Todo lo demás: usuario con token (y el interceptor revisa que sean sus datos)
                    .anyRequest().authenticated())
            .exceptionHandling(e -> e
                    .authenticationEntryPoint((req, res, ex) -> json(res, 401, "Inicia sesión para continuar"))
                    .accessDeniedHandler((req, res, ex) -> json(res, 403, "No tienes permiso para esta acción")))
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }

    /** El filtro JWT solo corre dentro de la cadena de la API, no como filtro suelto del servidor. */
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
