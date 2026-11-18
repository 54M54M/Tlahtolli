package com.tlahtolli.api.controller;

import com.tlahtolli.api.dto.request.LoginRequest;
import com.tlahtolli.api.dto.response.UserResponse;
import com.tlahtolli.api.security.TokenService;
import com.tlahtolli.api.service.UserService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
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

    /**
     * Devuelve los mismos campos de UserResponse (id, username, …, role) más
     * "token" y "expiresAt". El frontend sigue leyendo el usuario igual que antes.
     */
    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest dto) {
        return userService.login(dto.username(), dto.password())
                .<ResponseEntity<?>>map(u -> {
                    UserResponse r = UserResponse.from(u);
                    TokenService.Issued t = tokenService.issue(u);
                    Map<String, Object> body = new LinkedHashMap<>();
                    body.put("id", r.id());
                    body.put("username", r.username());
                    body.put("fullName", r.fullName());
                    body.put("email", r.email());
                    body.put("userLevel", r.userLevel());
                    body.put("xp", r.xp());
                    body.put("totalXp", r.totalXp());
                    body.put("streak", r.streak());
                    body.put("joinDate", r.joinDate());
                    body.put("currentLang", r.currentLang());
                    body.put("role", r.role());
                    body.put("emailVerified", r.emailVerified());
                    body.put("pendingEmail", r.pendingEmail());
                    body.put("token", t.token());
                    body.put("expiresAt", t.expiresAt());
                    return ResponseEntity.ok(body);
                })
                .orElse(ResponseEntity.status(401).body(Map.of("error", "Usuario o contraseña incorrectos")));
    }
}
