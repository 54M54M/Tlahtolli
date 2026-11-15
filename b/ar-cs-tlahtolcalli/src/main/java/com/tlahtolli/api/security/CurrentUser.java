package com.tlahtolli.api.security;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.server.ResponseStatusException;

/** Acceso al usuario del token y verificación de "solo tus propios datos". */
public final class CurrentUser {

    private CurrentUser() {}

    public static TokenService.Claims get() {
        Authentication a = SecurityContextHolder.getContext().getAuthentication();
        if (a != null && a.getPrincipal() instanceof TokenService.Claims c) return c;
        throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Inicia sesión");
    }

    public static boolean isAdmin() {
        Authentication a = SecurityContextHolder.getContext().getAuthentication();
        return a != null && a.getPrincipal() instanceof TokenService.Claims c && c.isAdmin();
    }

    /** Permite el acceso si el userId es el del token o si es administrador; si no, 403. */
    public static void requireSelfOrAdmin(Integer userId) {
        TokenService.Claims c = get();
        if (c.isAdmin()) return;
        if (userId == null || !userId.equals(c.userId()))
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Solo puedes acceder a tus propios datos");
    }

    public static void requireAdmin() {
        if (!get().isAdmin()) throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Requiere rol de administrador");
    }
}
