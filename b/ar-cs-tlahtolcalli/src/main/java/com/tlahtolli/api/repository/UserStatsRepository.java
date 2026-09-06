package com.tlahtolli.api.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.UserStats;

public interface UserStatsRepository extends JpaRepository<UserStats, Integer> {

    Optional<UserStats> findByUserIdAndLanguageId(Integer userId, Integer languageId);
 
    List<UserStats> findByUserId(Integer userId);
 
    boolean existsByUserIdAndLanguageId(Integer userId, Integer languageId);
}
