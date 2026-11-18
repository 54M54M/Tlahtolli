package com.tlahtolli.api.service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.HexFormat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.tlahtolli.api.email.EmailSender;
import com.tlahtolli.api.email.EmailTemplates;
import com.tlahtolli.api.entity.EmailToken;
import com.tlahtolli.api.entity.User;
import com.tlahtolli.api.repository.EmailTokenRepository;
import com.tlahtolli.api.repository.UserRepository;

/**
 * Verificación de correo propia:
 *  - token aleatorio de 32 bytes (SecureRandom), en base64url, enviado por correo
 *  - en la base solo se guarda su hash SHA-256
 *  - un solo uso, vence en 24 h, ligado al usuario, al correo y al propósito
 *  - pedir uno nuevo invalida los anteriores
 *  - máximo 1 envío por minuto y 5 por hora por usuario
 */
@Service
public class EmailVerificationService {

    private static final Logger log = LoggerFactory.getLogger(EmailVerificationService.class);
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final long TTL_HOURS = 24;

    private final EmailTokenRepository tokenRepo;
    private final UserRepository userRepo;
    private final EmailSender sender;
    private final String appUrl;

    public EmailVerificationService(EmailTokenRepository tokenRepo, UserRepository userRepo,
                                    EmailSender sender, Environment env) {
        this.tokenRepo = tokenRepo;
        this.userRepo = userRepo;
        this.sender = sender;
        this.appUrl = env.getProperty("APP_URL", "https://tlahtolcalli.netlify.app").replaceAll("/+$", "");
    }

    /** Envía (o reenvía) la verificación del correo pendiente si existe; si no, la del correo actual. */
    @Transactional
    public void send(User user) {
        boolean changing = user.getPendingEmail() != null && !user.getPendingEmail().isBlank();
        String email = changing ? user.getPendingEmail() : user.getEmail();
        if (!changing && user.isEmailVerified())
            throw new IllegalArgumentException("Tu correo ya está verificado");

        LocalDateTime now = LocalDateTime.now();
        tokenRepo.findFirstByUserIdOrderByCreatedAtDesc(user.getId()).ifPresent(last -> {
            if (last.getCreatedAt().isAfter(now.minusSeconds(60)))
                throw new IllegalArgumentException("Espera un minuto antes de pedir otro correo");
        });
        if (tokenRepo.countByUserIdAndCreatedAtAfter(user.getId(), now.minusHours(1)) >= 5)
            throw new IllegalArgumentException("Pediste demasiados correos. Intenta de nuevo en una hora");

        byte[] raw = new byte[32];
        RANDOM.nextBytes(raw);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(raw);

        tokenRepo.invalidateAll(user.getId(), now);
        EmailToken t = new EmailToken();
        t.setUserId(user.getId());
        t.setEmail(email);
        t.setTokenHash(sha256(token));
        t.setPurpose(changing ? EmailToken.CHANGE : EmailToken.VERIFY);
        t.setExpiresAt(now.plusHours(TTL_HOURS));
        tokenRepo.save(t);

        String link = appUrl + "/verificar?token=" + token;
        var mail = EmailTemplates.verify(firstName(user), link, changing);
        sender.send(email, user.getFullName(), mail.subject(), mail.html(), mail.text());
        log.info("[email] verificación enviada userId={} propósito={}", user.getId(), t.getPurpose());
    }

    /** Envía sin interrumpir el flujo si el proveedor falla (registro). */
    public void sendQuietly(User user) {
        try {
            send(user);
        } catch (Exception e) {
            log.warn("[email] no se pudo enviar la verificación a userId={}: {}", user.getId(), e.getMessage());
        }
    }

    /** Confirma el token. Devuelve el usuario actualizado. */
    @Transactional
    public User confirm(String token) {
        if (token == null || token.isBlank()) throw new IllegalArgumentException("Enlace inválido");
        EmailToken t = tokenRepo.findByTokenHash(sha256(token.trim()))
                .orElseThrow(() -> new IllegalArgumentException("El enlace no es válido o ya se usó"));
        LocalDateTime now = LocalDateTime.now();
        if (t.getUsedAt() != null) throw new IllegalArgumentException("El enlace no es válido o ya se usó");
        if (t.getExpiresAt().isBefore(now)) throw new IllegalArgumentException("El enlace venció. Pide uno nuevo");

        User user = userRepo.findById(t.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("El enlace no es válido o ya se usó"));
        t.setUsedAt(now);
        tokenRepo.save(t);

        if (EmailToken.CHANGE.equals(t.getPurpose())) {
            // El correo pendiente debe seguir siendo el mismo que se verificó
            if (!t.getEmail().equalsIgnoreCase(user.getPendingEmail()))
                throw new IllegalArgumentException("Este enlace corresponde a un cambio de correo anterior");
            if (userRepo.findByEmail(t.getEmail()).filter(o -> !o.getId().equals(user.getId())).isPresent())
                throw new IllegalArgumentException("Ese correo ya lo usa otra cuenta");
            String oldEmail = user.getEmail();
            user.setEmail(t.getEmail());
            user.setPendingEmail(null);
            notifyOldEmail(user, oldEmail);
        } else if (!t.getEmail().equalsIgnoreCase(user.getEmail())) {
            throw new IllegalArgumentException("Este enlace corresponde a un correo anterior");
        }
        user.setEmailVerified(true);
        user.setEmailVerifiedAt(now);
        log.info("[email] correo verificado userId={}", user.getId());
        return userRepo.save(user);
    }

    private void notifyOldEmail(User user, String oldEmail) {
        try {
            var mail = EmailTemplates.emailChangedNotice(firstName(user), user.getEmail());
            sender.send(oldEmail, user.getFullName(), mail.subject(), mail.html(), mail.text());
        } catch (Exception e) {
            log.warn("[email] no se pudo avisar al correo anterior userId={}: {}", user.getId(), e.getMessage());
        }
    }

    private static String firstName(User u) {
        String n = u.getFullName() == null ? "" : u.getFullName().trim();
        return n.isEmpty() ? u.getUsername() : n.split("\\s+")[0];
    }

    static String sha256(String s) {
        try {
            return HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256").digest(s.getBytes(StandardCharsets.UTF_8)));
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }
}
