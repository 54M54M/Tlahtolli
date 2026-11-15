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

/** Lee "Authorization: Bearer <token>" y deja al usuario autenticado con ROLE_USER o ROLE_ADMIN. */
@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    private final TokenService tokens;

    public JwtAuthFilter(TokenService tokens) {
        this.tokens = tokens;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest req, HttpServletResponse res, FilterChain chain)
            throws ServletException, IOException {
        String h = req.getHeader("Authorization");
        if (h != null && h.startsWith("Bearer ")) {
            tokens.parse(h.substring(7).trim()).ifPresent(c -> {
                var authorities = List.of(new SimpleGrantedAuthority(c.isAdmin() ? "ROLE_ADMIN" : "ROLE_USER"));
                var auth = new UsernamePasswordAuthenticationToken(c, null, authorities);
                SecurityContextHolder.getContext().setAuthentication(auth);
            });
        }
        chain.doFilter(req, res);
    }
}
