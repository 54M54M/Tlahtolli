package com.tlahtolli.api.dto.request;

import jakarta.validation.constraints.Min;

public record SetEnergyRequest(
        @Min(0) int value
) {}
