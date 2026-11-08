package com.tlahtolli.api.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record InitProgressRequest(
        @NotNull @Positive Integer userId,
        @NotNull @Positive Integer firstUnitId
) {}
