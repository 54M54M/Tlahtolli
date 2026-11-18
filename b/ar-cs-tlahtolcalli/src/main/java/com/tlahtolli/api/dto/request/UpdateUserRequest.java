package com.tlahtolli.api.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/** Nombre e idioma. username y email se ignoran: se cambian en /api/account. */
public record UpdateUserRequest(
        @Size(max = 50) String username,
        @NotBlank @Size(max = 100) String fullName,
        @Email @Size(max = 150) String email,
        Long currentLang
) {}
