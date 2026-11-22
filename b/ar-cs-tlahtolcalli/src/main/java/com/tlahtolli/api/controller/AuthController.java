package com.tlahtolli.api.controller;

import com.tlahtolli.api.dto.request.LoginRequest;
import com.tlahtolli.api.dto.response.UserResponse;
import com.tlahtolli.api.entity.User;
import com.tlahtolli.api.security.TokenService;
import com.tlahtolli.api.service.GoogleAuthService;
import com.tlahtolli.api.service.PasswordResetService;
import com.tlahtolli.api.service.UserService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    public record GoogleLoginRequest(String credential) {}
    public record ForgotPasswordRequest(String identifier) {}
    public record ResetPasswordRequest(String token, String password) {}

    private final UserService userService;
    private final TokenService tokenService;
    private final GoogleAuthService googleAuth;
    private final PasswordResetService passwordReset;

    public AuthController(UserService userService, TokenService tokenService, GoogleAuthService googleAuth,
                          PasswordResetService passwordReset) {
        this.userService = userService;
        this.tokenService = tokenService;
        this.googleAuth = googleAuth;
        this.passwordReset = passwordReset;
    }

    /** "Olvidé mi contraseña": siempre responde lo mismo, exista o no la cuenta. */
    @PostMapping("/password/forgot")
    public Map<String, Object> forgotPassword(@RequestBody ForgotPasswordRequest body) {
        passwordReset.request(body == null ? null : body.identifier());
        return Map.of("sent", true);
    }

    /** Enlace del correo: crea la contraseña nueva. */
    @PostMapping("/password/reset")
    public Map<String, Object> resetPassword(@RequestBody ResetPasswordRequest body) {
        User u = passwordReset.reset(body == null ? null : body.token(), body == null ? null : body.password());
        return Map.of("reset", true, "username", u.getUsername());
    }

    /**
     * Devuelve los mismos campos de UserResponse (id, username, …, role) más
     * "token" y "expiresAt". El frontend sigue leyendo el usuario igual que antes.
     */
    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest dto) {
        return userService.login(dto.username(), dto.password())
                .<ResponseEntity<?>>map(u -> ResponseEntity.ok(session(u, false)))
                .orElse(ResponseEntity.status(401).body(Map.of("error", "Usuario o contraseña incorrectos")));
    }

    /** "Continuar con Google": recibe el ID token del botón de Google y responde igual que /login (+ isNewUser). */
    @PostMapping("/google")
    public ResponseEntity<?> google(@RequestBody GoogleLoginRequest body) {
        if (!googleAuth.isEnabled())
            return ResponseEntity.status(503).body(Map.of("error", "El inicio con Google no está disponible"));
        GoogleAuthService.Result r = googleAuth.login(body.credential());
        return ResponseEntity.ok(session(r.user(), r.created()));
    }

    private Map<String, Object> session(User u, boolean created) {
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
        body.put("mustPickUsername", r.mustPickUsername());
        body.put("hasPassword", r.hasPassword());
        body.put("googleLinked", r.googleLinked());
        body.put("isNewUser", created);
        body.put("token", t.token());
        body.put("expiresAt", t.expiresAt());
        return body;
    }
}
