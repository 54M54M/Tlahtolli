package com.tlahtolli.api.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record UserRequest(
        @NotBlank @Pattern(regexp = "^[A-Za-z0-9_.]{3,30}$", message = "usa de 3 a 30 caracteres: letras, números, punto o guion bajo") String username,
        @NotBlank @Size(max = 100) String fullName,
        @NotBlank @Email @Size(max = 150) String email,
        @NotBlank @Size(min = 8, max = 100, message = "mínimo 8 caracteres") String password,
        Long currentLang
) {}
