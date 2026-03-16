package com.tlahtolli.api.controller;

import com.tlahtolli.api.entity.UserEnergy;
import com.tlahtolli.api.service.EnergyService;
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

	/** Obtiene (o crea) la energía de un usuario, aplicando recuperación pasiva. */
	@GetMapping("/user/{userId}")
	public ResponseEntity<UserEnergy> getEnergy(@PathVariable Long userId) {
		return ResponseEntity.ok(energyService.getOrCreate(userId));
	}

	/**
	 * Consume energía al responder un ejercicio. Body: { "isCorrect": true }
	 */
	@PostMapping("/user/{userId}/consume")
	public ResponseEntity<Map<String, Object>> consume(@PathVariable Long userId,
			@RequestBody Map<String, Object> body) {
		boolean isCorrect = Boolean.TRUE.equals(body.get("isCorrect"));
		return ResponseEntity.ok(energyService.consume(userId, isCorrect));
	}

	/**
	 * Sobrescribe la energía directamente (admin / debug). Body: { "value": 10 }
	 */
	@PutMapping("/user/{userId}/set")
	public ResponseEntity<UserEnergy> setEnergy(@PathVariable Long userId, @RequestBody Map<String, Object> body) {
		int value = Integer.parseInt(body.get("value").toString());
		return ResponseEntity.ok(energyService.setEnergy(userId, value));
	}
}