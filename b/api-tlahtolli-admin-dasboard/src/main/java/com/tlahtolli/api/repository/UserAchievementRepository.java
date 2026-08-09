package com.tlahtolli.api.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.UserAchievement;

public interface UserAchievementRepository extends JpaRepository<UserAchievement, Integer> {
	 
    List<UserAchievement> findByUserId(Integer userId);
 
    Optional<UserAchievement> findByUserIdAndAchieveId(Integer userId, Integer achieveId);
 
    boolean existsByUserIdAndAchieveId(Integer userId, Integer achieveId);
}
 