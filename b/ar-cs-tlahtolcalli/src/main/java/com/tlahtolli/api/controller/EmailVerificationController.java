package com.tlahtolli.api.controller;

import java.util.Map;

import org.springframework.web.bind.annotation.*;

import com.tlahtolli.api.entity.User;
import com.tlahtolli.api.service.EmailVerificationService;

/** Confirmación pública del enlace del correo (POST: los escáneres de correo solo hacen GET). */
@RestController
@RequestMapping("/api/auth/email")
public class EmailVerificationController {

    public record ConfirmRequest(String token) {}

    private final EmailVerificationService verification;

    public EmailVerificationController(EmailVerificationService verification) {
        this.verification = verification;
    }

    @PostMapping("/confirm")
    public Map<String, Object> confirm(@RequestBody ConfirmRequest body) {
        User u = verification.confirm(body.token());
        return Map.of("verified", true, "email", u.getEmail(), "userId", u.getId());
    }
}
