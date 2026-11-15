package com.tlahtolli.api.dto.response;

import com.fasterxml.jackson.annotation.JsonUnwrapped;

/**
 * Respuesta del login: los mismos campos de UserResponse (el frontend no cambia su forma
 * de leer el usuario) más el token para las siguientes peticiones.
 */
public record LoginResponse(
        @JsonUnwrapped UserResponse user,
        String token,
        long expiresAt
) {}
