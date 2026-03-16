package com.tlahtolli.api.service;

import com.tlahtolli.api.entity.User;
import com.tlahtolli.api.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {

	private final UserRepository userRepo;
	private final EnergyService energyService;

	public UserService(UserRepository userRepo, EnergyService energyService) {
		this.userRepo = userRepo;
		this.energyService = energyService;
	}

	public List<User> getAll() {
		return userRepo.findAll();
	}

	public Optional<User> getById(Long id) {
		return userRepo.findById(id);
	}

	public Optional<User> getByUsername(String username) {
		return userRepo.findByUsername(username);
	}

	/** Crea un usuario e inicializa su energía. */
	@Transactional
	public User create(User user) {
		if (userRepo.existsByUsername(user.getUsername()))
			throw new IllegalArgumentException("Username ya existe: " + user.getUsername());
		if (userRepo.existsByEmail(user.getEmail()))
			throw new IllegalArgumentException("Email ya existe: " + user.getEmail());

		user.setJoinDate(LocalDate.now());
		user.setUserLevel(1);
		user.setXp(0L);
		user.setTotalXp(0L);
		user.setStreak(0);
		User saved = userRepo.save(user);

		energyService.getOrCreate(saved.getId());
		return saved;
	}

	@Transactional
	public Optional<User> update(Long id, User body) {
		return userRepo.findById(id).map(existing -> {
			body.setId(existing.getId());
			return userRepo.save(body);
		});
	}

	@Transactional
	public boolean delete(Long id) {
		if (!userRepo.existsById(id))
			return false;
		userRepo.deleteById(id);
		return true;
	}

	/** Cambia el idioma activo del usuario. */
	@Transactional
	public Optional<User> switchLanguage(Long userId, Long languageId) {
		return userRepo.findById(userId).map(u -> {
			u.setCurrentLang(languageId);
			return userRepo.save(u);
		});
	}
}