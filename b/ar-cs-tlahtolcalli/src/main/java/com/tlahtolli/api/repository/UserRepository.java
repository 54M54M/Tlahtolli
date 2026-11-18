package com.tlahtolli.api.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.User;

public interface UserRepository extends JpaRepository<User, Integer> {

	Optional<User> findByUsername(String username);
	 
    Optional<User> findByEmail(String email);
 
    boolean existsByUsername(String username);
 
    boolean existsByEmail(String email);

    Optional<User> findByEmailIgnoreCase(String email);

    Optional<User> findByGoogleSub(String googleSub);

    boolean existsByUsernameIgnoreCase(String username);
}
