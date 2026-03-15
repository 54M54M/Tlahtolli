package com.tlahtolli.api.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.User;

public interface UserRepository extends JpaRepository<User, Long> {

}
