package com.tlahtolli.api.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.UserAchievement;

public interface UserAchievementRepository extends JpaRepository<UserAchievement, Long> {
	 
    List<UserAchievement> findByUserId(Long userId);
 
    Optional<UserAchievement> findByUserIdAndAchieveId(Long userId, Long achieveId);
 
    boolean existsByUserIdAndAchieveId(Long userId, Long achieveId);
}
 