package com.tlahtolli.api.controller;

import com.tlahtolli.api.dto.request.LoginRequest;
import com.tlahtolli.api.dto.response.LoginResponse;
import com.tlahtolli.api.dto.response.UserResponse;
import com.tlahtolli.api.security.TokenService;
import com.tlahtolli.api.service.UserService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserService userService;
    private final TokenService tokenService;

    public AuthController(UserService userService, TokenService tokenService) {
        this.userService = userService;
        this.tokenService = tokenService;
    }

    /** Devuelve los datos del usuario (misma forma que UserResponse) más token y expiración. */
    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest dto) {
        return userService.login(dto.username(), dto.password())
                .<ResponseEntity<?>>map(u -> {
                    TokenService.Issued t = tokenService.issue(u);
                    return ResponseEntity.ok(new LoginResponse(UserResponse.from(u), t.token(), t.expiresAt()));
                })
                .orElse(ResponseEntity.status(401).body(Map.of("error", "Usuario o contraseña incorrectos")));
    }
}
