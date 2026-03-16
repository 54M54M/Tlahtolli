package com.tlahtolli.api.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.UserEnergy;

public interface UserEnergyRepository extends JpaRepository<UserEnergy, Long> {
	 
    // Un usuario tiene exactamente un registro de energía (UNIQUE en BD)
    Optional<UserEnergy> findByUserId(Long userId);
 
    boolean existsByUserId(Long userId);
}
 
