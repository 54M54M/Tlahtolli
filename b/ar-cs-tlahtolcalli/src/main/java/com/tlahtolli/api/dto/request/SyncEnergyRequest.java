package com.tlahtolli.api.dto.request;

import java.util.List;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/** Respuestas contestadas sin conexión, en orden (true = correcta). */
public record SyncEnergyRequest(
        String clientId,
        @NotNull @Size(max = 300) List<Boolean> answers
) {}
