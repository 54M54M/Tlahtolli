package com.tlahtolli.api.service;

import com.tlahtolli.api.entity.UserEnergy;
import com.tlahtolli.api.repository.UserEnergyRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Map;

@Service
public class EnergyService {

	private static final Logger log = LoggerFactory.getLogger(EnergyService.class);

	private static final int RECOVERY_MINUTES = 20;
	private static final SecureRandom RANDOM = new SecureRandom();

	private final UserEnergyRepository energyRepo;

	public EnergyService(UserEnergyRepository energyRepo) {
		this.energyRepo = energyRepo;
	}

	/** Obtiene o crea la energía del usuario, aplicando recuperación pasiva. */
	@Transactional
	public UserEnergy getOrCreate(Integer userId) {
		log.debug("Getting or creating energy for userId={}", userId);
		return energyRepo.findByUserId(userId).map(this::applyPassiveRecovery).orElseGet(() -> createDefault(userId));
	}

	@Transactional
	public Map<String, Object> consume(Integer userId, boolean isCorrect) {
		log.debug("Consuming energy for userId={}, isCorrect={}", userId, isCorrect);
		UserEnergy e = getOrCreate(userId);

		int change = -1; // consumo base siempre

		if (isCorrect) {
			change += RANDOM.nextBoolean() ? 1 : 2; // bonus +1 o +2
			e.setStreakCount((short) (e.getStreakCount() + 1));
			if (e.getStreakCount() >= 3) {
				change += RANDOM.nextBoolean() ? 3 : 4; // bonus por racha
			}
		} else {
			e.setStreakCount((short) 0);
		}

		int newEnergy = Math.max(0, Math.min(e.getMaxEnergy(), e.getCurrentEnergy() + change));
		e.setCurrentEnergy((short) newEnergy);
		e.setDailyUsage((short) (e.getDailyUsage() + 1));
		e.setLastUpdate(LocalDateTime.now());
		energyRepo.save(e);
		log.info("Energy consumed for userId={}: newEnergy={}, change={}, streak={}", userId, newEnergy, change, e.getStreakCount());

		return Map.of("newEnergy", newEnergy, "energyChange", change, "streak", e.getStreakCount(), "maxEnergy",
				e.getMaxEnergy());
	}

	/** Sobrescribe la energía directamente (admin / debug). */
	@Transactional
	public UserEnergy setEnergy(Integer userId, int value) {
		log.info("Setting energy for userId={} to value={}", userId, value);
		UserEnergy e = getOrCreate(userId);
		e.setCurrentEnergy((short) Math.max(0, Math.min(e.getMaxEnergy(), value)));
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
			log.debug("Passive recovery for userId={}: +{} energy", e.getUserId(), recovered);
			e.setCurrentEnergy((short) Math.min(e.getMaxEnergy(), e.getCurrentEnergy() + recovered));
			e.setLastUpdate(LocalDateTime.now());
			energyRepo.save(e);
		}
		return e;
	}

	private UserEnergy createDefault(Integer userId) {
		log.info("Creating default energy for userId={}", userId);
		UserEnergy e = new UserEnergy();
		e.setUserId(userId);
		e.setMaxEnergy((short) 15);
		e.setCurrentEnergy((short) 15);
		e.setStreakCount((short) 0);
		e.setDailyUsage((short) 0);
		e.setLastUpdate(LocalDateTime.now());
		return energyRepo.save(e);
	}
}