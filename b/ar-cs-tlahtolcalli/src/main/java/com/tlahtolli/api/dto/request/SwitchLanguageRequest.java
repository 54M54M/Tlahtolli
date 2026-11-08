package com.tlahtolli.api.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record SwitchLanguageRequest(
        @NotNull @Positive Integer languageId
) {}
