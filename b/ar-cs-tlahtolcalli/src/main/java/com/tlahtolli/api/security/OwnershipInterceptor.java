package com.tlahtolli.api.security;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.HandlerMapping;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Evita que un usuario lea o modifique datos de otro cambiando el id en la URL.
 * Revisa el userId de la ruta (/energy/user/{userId}, /users/{id}) y el parámetro ?userId=.
 * En las rutas de datos de usuario, pedir la lista completa (sin userId) es solo para admin.
 * Los userId que llegan en el cuerpo (POST /user-progress/complete, /init) se revisan en el controlador.
 */
@Component
public class OwnershipInterceptor implements HandlerInterceptor {

    /** Rutas cuyos datos pertenecen a un usuario. */
    private static final List<String> USER_DATA = List.of(
            "/api/users/", "/api/energy/", "/api/user-progress", "/api/user-stats",
            "/api/lesson-history", "/api/user-achievements", "/api/learning/");

    @Override
    public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler) {
        String path = req.getRequestURI();
        if ("OPTIONS".equalsIgnoreCase(req.getMethod())) return true;
        if (USER_DATA.stream().noneMatch(path::startsWith)) return true;
        if (CurrentUser.isAdmin()) return true;

        @SuppressWarnings("unchecked")
        Map<String, String> vars = (Map<String, String>) req.getAttribute(HandlerMapping.URI_TEMPLATE_VARIABLES_ATTRIBUTE);
        String fromPath = vars == null ? null : vars.get("userId");
        if (fromPath == null && vars != null && path.startsWith("/api/users/") && !path.startsWith("/api/users/by-username/"))
            fromPath = vars.get("id");
        String fromQuery = req.getParameter("userId");

        // /api/learning: solo las rutas que reciben userId son de usuario (ejercicios y vocabulario son contenido)
        if (path.startsWith("/api/learning/") && fromQuery == null && fromPath == null) return true;
        // /api/users/by-username/{username} se valida en el controlador
        if (path.startsWith("/api/users/by-username/")) return true;
        // POST /complete y /init traen el userId en el cuerpo: se valida en el controlador
        if (path.startsWith("/api/user-progress/complete") || path.startsWith("/api/user-progress/init")) return true;

        if (fromPath != null) CurrentUser.requireSelfOrAdmin(parse(fromPath));
        if (fromQuery != null) CurrentUser.requireSelfOrAdmin(parse(fromQuery));
        if (fromPath == null && fromQuery == null) CurrentUser.requireAdmin();   // listas completas
        return true;
    }

    private static Integer parse(String s) {
        try { return Integer.valueOf(s); } catch (NumberFormatException e) { return -1; }
    }
}
