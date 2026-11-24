package com.tlahtolli.api.security;

import java.io.IOException;
import java.util.List;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Lee "Authorization: Bearer <token>" y deja al usuario autenticado con ROLE_USER o ROLE_ADMIN.
 * Un token de una sesión cerrada (se restableció la contraseña, ver SessionVersions) se ignora: la petición
 * sigue como anónima y las rutas protegidas responden 401, con lo que el front cierra la sesión.
 * /api/health no lo revisa: no necesita usuario y así el health check no despierta la base.
 */
@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    private final TokenService tokens;
    private final SessionVersions sessions;

    public JwtAuthFilter(TokenService tokens, SessionVersions sessions) {
        this.tokens = tokens;
        this.sessions = sessions;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest req, HttpServletResponse res, FilterChain chain)
            throws ServletException, IOException {
        String h = req.getHeader("Authorization");
        if (h != null && h.startsWith("Bearer ") && !req.getRequestURI().startsWith("/api/health")) {
            tokens.parse(h.substring(7).trim())
                    .filter(c -> sessions.isCurrent(c.userId(), c.tokenVersion()))
                    .ifPresent(c -> {
                var authorities = List.of(new SimpleGrantedAuthority(c.isAdmin() ? "ROLE_ADMIN" : "ROLE_USER"));
                var auth = new UsernamePasswordAuthenticationToken(c, null, authorities);
                SecurityContextHolder.getContext().setAuthentication(auth);
            });
        }
        chain.doFilter(req, res);
    }
}
