package com.tlahtolli.api.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.UserStats;

public interface UserStatsRepository extends JpaRepository<UserStats, Long> {

    // El registro es único por (userId, languageId) — ver UQ_USER_STATS
    Optional<UserStats> findByUserIdAndLanguageId(Long userId, Long languageId);
 
    // Todas las stats de un usuario (un registro por idioma)
    List<UserStats> findByUserId(Long userId);
 
    boolean existsByUserIdAndLanguageId(Long userId, Long languageId);
}
