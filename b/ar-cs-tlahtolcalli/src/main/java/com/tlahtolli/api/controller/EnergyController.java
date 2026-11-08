package com.tlahtolli.api.controller;

import com.tlahtolli.api.dto.request.ConsumeEnergyRequest;
import com.tlahtolli.api.dto.request.SetEnergyRequest;
import com.tlahtolli.api.dto.response.EnergyResponse;
import com.tlahtolli.api.service.EnergyService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/energy")
public class EnergyController {

	private final EnergyService energyService;

	public EnergyController(EnergyService energyService) {
		this.energyService = energyService;
	}

	@GetMapping("/user/{userId}")
	public ResponseEntity<EnergyResponse> getEnergy(@PathVariable Integer userId) {
		return ResponseEntity.ok(EnergyResponse.from(energyService.getOrCreate(userId)));
	}

	@PostMapping("/user/{userId}/consume")
	public ResponseEntity<Map<String, Object>> consume(@PathVariable Integer userId,
                                                       @Valid @RequestBody ConsumeEnergyRequest body) {
		return ResponseEntity.ok(energyService.consume(userId, body.isCorrect()));
	}

	@PutMapping("/user/{userId}/set")
	public ResponseEntity<EnergyResponse> setEnergy(@PathVariable Integer userId,
			@Valid @RequestBody SetEnergyRequest body) {
		return ResponseEntity.ok(EnergyResponse.from(energyService.setEnergy(userId, body.value())));
	}
}