package com.tlahtolli.api.controller;

import com.tlahtolli.api.dto.request.ConsumeEnergyRequest;
import com.tlahtolli.api.dto.request.SetEnergyRequest;
import com.tlahtolli.api.dto.request.SyncEnergyRequest;
import com.tlahtolli.api.security.CurrentUser;
import com.tlahtolli.api.service.SyncOpService;
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
	private final SyncOpService syncOps;

	public EnergyController(EnergyService energyService, SyncOpService syncOps) {
		this.energyService = energyService;
		this.syncOps = syncOps;
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

	/**
	 * Energía gastada sin conexión: el teléfono manda las respuestas en orden al reconectar.
	 * Con clientId repetido (reintento) no se vuelve a aplicar; solo se devuelve la energía actual.
	 */
	@PostMapping("/user/{userId}/sync")
	public ResponseEntity<EnergyResponse> sync(@PathVariable Integer userId, @Valid @RequestBody SyncEnergyRequest body) {
		CurrentUser.requireSelfOrAdmin(userId);
		if (!syncOps.claim(body.clientId(), userId, SyncOpService.ENERGY)) {
			return ResponseEntity.ok(EnergyResponse.from(energyService.getOrCreate(userId)));
		}
		try {
			return ResponseEntity.ok(EnergyResponse.from(energyService.sync(userId, body.answers())));
		} catch (RuntimeException e) {
			syncOps.release(body.clientId());
			throw e;
		}
	}

	@PutMapping("/user/{userId}/set")
	public ResponseEntity<EnergyResponse> setEnergy(@PathVariable Integer userId,
			@Valid @RequestBody SetEnergyRequest body) {
		return ResponseEntity.ok(EnergyResponse.from(energyService.setEnergy(userId, body.value())));
	}
}