package com.tlahtolli.api.controller;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.tlahtolli.api.security.CurrentUser;
import com.tlahtolli.api.service.AccountService;
import com.tlahtolli.api.service.EmailVerificationService;

/** Cuenta propia. Siempre usa el usuario del token, nunca un id del cliente. */
@RestController
@RequestMapping("/api/account")
public class AccountController {

    public record ProfileRequest(String fullName, String username) {}
    public record PasswordRequest(String currentPassword, String newPassword) {}
    public record EmailRequest(String email, String password) {}
    public record DeleteRequest(String password) {}

    private final AccountService account;
    private final EmailVerificationService verification;

    public AccountController(AccountService account, EmailVerificationService verification) {
        this.account = account;
        this.verification = verification;
    }

    private Integer me() { return CurrentUser.get().userId(); }

    @GetMapping
    public Map<String, Object> info() {
        return account.info(account.get(me()));
    }

    @GetMapping("/username-available")
    public Map<String, Object> usernameAvailable(@RequestParam String username) {
        String problem = account.usernameProblem(username == null ? null : username.trim(), me());
        return problem == null ? Map.of("available", true) : Map.of("available", false, "reason", problem);
    }

    @PutMapping("/profile")
    public Map<String, Object> profile(@RequestBody ProfileRequest body) {
        return account.info(account.updateProfile(me(), body.fullName(), body.username()));
    }

    @PutMapping("/password")
    public ResponseEntity<Void> password(@RequestBody PasswordRequest body) {
        account.changePassword(me(), body.currentPassword(), body.newPassword());
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/email")
    public Map<String, Object> changeEmail(@RequestBody EmailRequest body) {
        return account.info(account.requestEmailChange(me(), body.email(), body.password()));
    }

    @DeleteMapping("/email")
    public Map<String, Object> cancelEmailChange() {
        return account.info(account.cancelEmailChange(me()));
    }

    /** Reenvía la verificación (del correo pendiente si hay uno; si no, del actual). */
    @PostMapping("/email/resend")
    public ResponseEntity<Void> resend() {
        verification.send(account.get(me()));
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/delete")
    public ResponseEntity<Void> delete(@RequestBody DeleteRequest body) {
        account.delete(me(), body.password());
        return ResponseEntity.noContent().build();
    }
}
