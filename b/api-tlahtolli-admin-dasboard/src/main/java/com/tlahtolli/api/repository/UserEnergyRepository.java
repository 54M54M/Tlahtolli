package com.tlahtolli.api.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.UserEnergy;

public interface UserEnergyRepository extends JpaRepository<UserEnergy, Integer> {
	 
    Optional<UserEnergy> findByUserId(Integer userId);
 
    boolean existsByUserId(Integer userId);
}
 
