package com.tlahtolli.api.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.UserStats;

public interface UserStatsRepository extends JpaRepository<UserStats, Long> {

}
