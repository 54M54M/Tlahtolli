package com.tlahtolli.api.service;

import com.tlahtolli.api.entity.UserEnergy;
import com.tlahtolli.api.repository.UserEnergyRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Map;

@Service
public class EnergyService {

	private static final int RECOVERY_MINUTES = 20;
	private static final SecureRandom RANDOM = new SecureRandom();

	private final UserEnergyRepository energyRepo;

	public EnergyService(UserEnergyRepository energyRepo) {
		this.energyRepo = energyRepo;
	}

	/** Obtiene o crea la energía del usuario, aplicando recuperación pasiva. */
	@Transactional
	public UserEnergy getOrCreate(Long userId) {
		return energyRepo.findByUserId(userId).map(this::applyPassiveRecovery).orElseGet(() -> createDefault(userId));
	}

	/** Consume energía al responder un ejercicio. */
	@Transactional
	public Map<String, Object> consume(Long userId, boolean isCorrect) {
		UserEnergy e = getOrCreate(userId);

		int change = -1; // consumo base siempre

		if (isCorrect) {
			change += RANDOM.nextBoolean() ? 1 : 2; // bonus +1 o +2
			e.setStreakCount(e.getStreakCount() + 1);
			if (e.getStreakCount() >= 3) {
				change += RANDOM.nextBoolean() ? 3 : 4; // bonus por racha
			}
		} else {
			e.setStreakCount(0);
		}

		int newEnergy = Math.max(0, Math.min(e.getMaxEnergy(), e.getCurrentEnergy() + change));
		e.setCurrentEnergy(newEnergy);
		e.setDailyUsage(e.getDailyUsage() + 1);
		e.setLastUpdate(LocalDateTime.now());
		energyRepo.save(e);

		return Map.of("newEnergy", newEnergy, "energyChange", change, "streak", e.getStreakCount(), "maxEnergy",
				e.getMaxEnergy());
	}

	/** Sobrescribe la energía directamente (admin / debug). */
	@Transactional
	public UserEnergy setEnergy(Long userId, int value) {
		UserEnergy e = getOrCreate(userId);
		e.setCurrentEnergy(Math.max(0, Math.min(e.getMaxEnergy(), value)));
		e.setLastUpdate(LocalDateTime.now());
		return energyRepo.save(e);
	}

	// ── privados ──────────────────────────────────────────────────────────────

	private UserEnergy applyPassiveRecovery(UserEnergy e) {
		if (e.getLastUpdate() == null || e.getCurrentEnergy() >= e.getMaxEnergy())
			return e;
		long minutesPassed = ChronoUnit.MINUTES.between(e.getLastUpdate(), LocalDateTime.now());
		int recovered = (int) (minutesPassed / RECOVERY_MINUTES);
		if (recovered > 0) {
			e.setCurrentEnergy(Math.min(e.getMaxEnergy(), e.getCurrentEnergy() + recovered));
			e.setLastUpdate(LocalDateTime.now());
			energyRepo.save(e);
		}
		return e;
	}

	private UserEnergy createDefault(Long userId) {
		UserEnergy e = new UserEnergy();
		e.setUserId(userId);
		e.setMaxEnergy(15);
		e.setCurrentEnergy(15);
		e.setStreakCount(0);
		e.setDailyUsage(0);
		e.setLastUpdate(LocalDateTime.now());
		return energyRepo.save(e);
	}
}