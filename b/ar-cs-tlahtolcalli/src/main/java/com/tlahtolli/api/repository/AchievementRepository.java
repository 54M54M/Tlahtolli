package com.tlahtolli.api.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.Achievement;

public interface AchievementRepository extends JpaRepository<Achievement, Integer> {

}
