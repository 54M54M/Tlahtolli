package com.tlahtolli.api.service;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.env.Environment;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.tlahtolli.api.email.EmailSender;
import com.tlahtolli.api.email.EmailTemplates;
import com.tlahtolli.api.entity.EmailToken;
import com.tlahtolli.api.entity.User;
import com.tlahtolli.api.repository.EmailTokenRepository;
import com.tlahtolli.api.repository.UserRepository;

/**
 * "Olvidé mi contraseña".
 *  - Se pide con el usuario o el correo. La respuesta es siempre la misma, exista o no la cuenta
 *    (así nadie puede averiguar qué correos están registrados).
 *  - Token aleatorio de 32 bytes por correo; en la base solo su hash SHA-256. Un solo uso, vence en 1 hora.
 *  - Máximo 1 envío por minuto y 5 por hora por cuenta. Pedir uno nuevo invalida los anteriores.
 *  - Al restablecer: el correo queda verificado (quien abrió el enlace controla ese correo) y se avisa por correo.
 *  - Sirve también para que una cuenta creada con Google tenga contraseña.
 */
@Service
public class PasswordResetService {

    private static final Logger log = LoggerFactory.getLogger(PasswordResetService.class);
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final long TTL_MINUTES = 60;

    private final EmailTokenRepository tokenRepo;
    private final UserRepository userRepo;
    private final EmailSender sender;
    private final PasswordEncoder encoder;
    private final String appUrl;

    public PasswordResetService(EmailTokenRepository tokenRepo, UserRepository userRepo,
                                EmailSender sender, PasswordEncoder encoder, Environment env) {
        this.tokenRepo = tokenRepo;
        this.userRepo = userRepo;
        this.sender = sender;
        this.encoder = encoder;
        this.appUrl = env.getProperty("APP_URL", "https://tlahtolcalli.netlify.app").replaceAll("/+$", "");
    }

    /** Envía el enlace si la cuenta existe. Nunca dice si existe o no. */
    @Transactional
    public void request(String identifier) {
        String id = identifier == null ? "" : identifier.trim();
        if (id.isEmpty() || id.length() > 150) throw new IllegalArgumentException("Escribe tu usuario o tu correo");

        Optional<User> found = id.contains("@") ? userRepo.findByEmailIgnoreCase(id) : userRepo.findByUsername(id);
        if (found.isEmpty() || found.get().getEmail() == null || found.get().getEmail().isBlank()) {
            log.info("[contraseña] solicitud para una cuenta que no existe");
            return;
        }
        User user = found.get();

        LocalDateTime now = LocalDateTime.now();
        boolean tooSoon = tokenRepo.findFirstByUserIdAndPurposeOrderByCreatedAtDesc(user.getId(), EmailToken.RESET)
                .filter(last -> last.getCreatedAt().isAfter(now.minusSeconds(60))).isPresent();
        boolean tooMany = tokenRepo.countByUserIdAndPurposeAndCreatedAtAfter(user.getId(), EmailToken.RESET, now.minusHours(1)) >= 5;
        if (tooSoon || tooMany) {
            log.info("[contraseña] límite de envíos userId={}", user.getId());
            return;   // misma respuesta: no se revela el límite por cuenta
        }

        byte[] raw = new byte[32];
        RANDOM.nextBytes(raw);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(raw);

        tokenRepo.invalidateByPurpose(user.getId(), EmailToken.RESET, now);
        EmailToken t = new EmailToken();
        t.setUserId(user.getId());
        t.setEmail(user.getEmail());
        t.setTokenHash(EmailVerificationService.sha256(token));
        t.setPurpose(EmailToken.RESET);
        t.setExpiresAt(now.plusMinutes(TTL_MINUTES));
        tokenRepo.save(t);

        String link = appUrl + "/restablecer?token=" + token;
        try {
            var mail = EmailTemplates.passwordReset(firstName(user), user.getUsername(), link);
            sender.send(user.getEmail(), user.getFullName(), mail.subject(), mail.html(), mail.text());
            log.info("[contraseña] enlace enviado userId={}", user.getId());
        } catch (Exception e) {
            log.warn("[contraseña] no se pudo enviar el enlace a userId={}: {}", user.getId(), e.getMessage());
        }
    }

    /** Cambia la contraseña con el token del correo. Devuelve el usuario (para mostrar su nombre de usuario). */
    @Transactional
    public User reset(String token, String newPassword) {
        if (token == null || token.isBlank()) throw new IllegalArgumentException("El enlace está incompleto");
        if (newPassword == null || newPassword.length() < 8 || newPassword.length() > 100)
            throw new IllegalArgumentException("La contraseña debe tener al menos 8 caracteres");

        EmailToken t = tokenRepo.findByTokenHash(EmailVerificationService.sha256(token.trim()))
                .filter(x -> EmailToken.RESET.equals(x.getPurpose()))
                .orElseThrow(() -> new IllegalArgumentException("El enlace no es válido o ya se usó. Pide uno nuevo"));
        LocalDateTime now = LocalDateTime.now();
        if (t.getUsedAt() != null) throw new IllegalArgumentException("El enlace no es válido o ya se usó. Pide uno nuevo");
        if (t.getExpiresAt().isBefore(now)) throw new IllegalArgumentException("El enlace venció. Pide uno nuevo");

        User user = userRepo.findById(t.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("El enlace no es válido o ya se usó. Pide uno nuevo"));
        if (!t.getEmail().equalsIgnoreCase(user.getEmail()))
            throw new IllegalArgumentException("Este enlace corresponde a un correo anterior. Pide uno nuevo");

        t.setUsedAt(now);
        tokenRepo.save(t);
        tokenRepo.invalidateByPurpose(user.getId(), EmailToken.RESET, now);

        user.setPasswordHash(encoder.encode(newPassword));
        if (!user.isEmailVerified()) {
            user.setEmailVerified(true);
            user.setEmailVerifiedAt(now);
        }
        User saved = userRepo.save(user);
        log.info("[contraseña] restablecida userId={}", user.getId());

        try {
            var mail = EmailTemplates.passwordChangedNotice(firstName(user));
            sender.send(user.getEmail(), user.getFullName(), mail.subject(), mail.html(), mail.text());
        } catch (Exception e) {
            log.warn("[contraseña] no se pudo enviar el aviso a userId={}: {}", user.getId(), e.getMessage());
        }
        return saved;
    }

    private static String firstName(User u) {
        String n = u.getFullName() == null ? "" : u.getFullName().trim();
        return n.isEmpty() ? u.getUsername() : n.split("\\s+")[0];
    }
}
