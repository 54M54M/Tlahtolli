package com.tlahtolli.api.service;

import com.tlahtolli.api.entity.User;
import com.tlahtolli.api.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {

	private static final Logger log = LoggerFactory.getLogger(UserService.class);

	private final UserRepository userRepo;
	private final EnergyService energyService;

	public UserService(UserRepository userRepo, EnergyService energyService) {
		this.userRepo = userRepo;
		this.energyService = energyService;
	}

	public List<User> getAll() {
		log.debug("Fetching all users");
		return userRepo.findAll();
	}

	public Optional<User> getById(Integer id) {
		log.debug("Fetching user by id={}", id);
		return userRepo.findById(id);
	}

	public Optional<User> getByUsername(String username) {
		log.debug("Fetching user by username={}", username);
		return userRepo.findByUsername(username);
	}

	/** Crea un usuario e inicializa su energía. */
	@Transactional
	public User create(User user) {
		log.info("Creating user username={}", user.getUsername());
		if (userRepo.existsByUsername(user.getUsername())) {
			log.warn("Username already exists: {}", user.getUsername());
			throw new IllegalArgumentException("Username ya existe: " + user.getUsername());
		}
		if (userRepo.existsByEmail(user.getEmail())) {
			log.warn("Email already exists: {}", user.getEmail());
			throw new IllegalArgumentException("Email ya existe: " + user.getEmail());
		}

		user.setJoinDate(LocalDate.now());
		user.setUserLevel((short) 1);
		user.setXp(0);
		user.setTotalXp(0);
		user.setStreak((short) 0);
		User saved = userRepo.save(user);
		log.info("User created id={}", saved.getId());

		energyService.getOrCreate(saved.getId());
		return saved;
	}

	@Transactional
	public Optional<User> update(Integer id, User body) {
		log.info("Updating user id={}", id);
		return userRepo.findById(id).map(existing -> {
			body.setId(existing.getId());
			User updated = userRepo.save(body);
			log.debug("User updated id={}", id);
			return updated;
		});
	}

	@Transactional
	public boolean delete(Integer id) {
		log.info("Deleting user id={}", id);
		if (!userRepo.existsById(id)) {
			log.warn("User not found for deletion id={}", id);
			return false;
		}
		userRepo.deleteById(id);
		log.info("User deleted id={}", id);
		return true;
	}

	/** Cambia el idioma activo del usuario. */
	@Transactional
	public Optional<User> switchLanguage(Integer userId, Integer languageId) {
		log.info("Switching language for userId={} to languageId={}", userId, languageId);
		return userRepo.findById(userId).map(u -> {
			u.setCurrentLang(languageId);
			return userRepo.save(u);
		});
	}
}