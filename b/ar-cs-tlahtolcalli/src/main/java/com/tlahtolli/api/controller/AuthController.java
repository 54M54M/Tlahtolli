package com.tlahtolli.api.controller;

import com.tlahtolli.api.dto.request.LoginRequest;
import com.tlahtolli.api.dto.response.UserResponse;
import com.tlahtolli.api.service.UserService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest dto) {
        return userService.login(dto.username(), dto.password())
                .map(UserResponse::from)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(401).body(null));
    }
}
