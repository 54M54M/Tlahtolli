package com.tlahtolli.api.service;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.env.Environment;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.tlahtolli.api.entity.User;
import com.tlahtolli.api.repository.UserRepository;

/** Cuenta del usuario que inició sesión: perfil, usuario (con espera), contraseña, correo y baja. */
@Service
public class AccountService {

    private static final Logger log = LoggerFactory.getLogger(AccountService.class);
    public static final Pattern USERNAME = Pattern.compile("^[A-Za-z0-9_.]{3,30}$");
    private static final Pattern EMAIL = Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");

    private final UserRepository userRepo;
    private final PasswordEncoder encoder;
    private final EmailVerificationService verification;
    private final int cooldownDays;

    public AccountService(UserRepository userRepo, PasswordEncoder encoder,
                          EmailVerificationService verification, Environment env) {
        this.userRepo = userRepo;
        this.encoder = encoder;
        this.verification = verification;
        this.cooldownDays = Integer.parseInt(env.getProperty("USERNAME_COOLDOWN_DAYS", "30"));
    }

    public User get(Integer userId) {
        return userRepo.findById(userId).orElseThrow(() -> new IllegalArgumentException("La cuenta no existe"));
    }

    /** Fecha a partir de la cual puede volver a cambiar su usuario (null = ya puede). */
    public LocalDateTime usernameChangeAvailableAt(User u) {
        if (u.getUsernameChangedAt() == null) return null;
        LocalDateTime next = u.getUsernameChangedAt().plusDays(cooldownDays);
        return next.isAfter(LocalDateTime.now()) ? next : null;
    }

    public Map<String, Object> info(User u) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", u.getId());
        m.put("username", u.getUsername());
        m.put("fullName", u.getFullName());
        m.put("email", u.getEmail());
        m.put("emailVerified", u.isEmailVerified());
        m.put("pendingEmail", u.getPendingEmail());
        m.put("usernameChangeAvailableAt", usernameChangeAvailableAt(u));
        m.put("usernameCooldownDays", cooldownDays);
        return m;
    }

    /** null si está disponible; si no, el motivo. */
    public String usernameProblem(String username, Integer selfId) {
        if (username == null || !USERNAME.matcher(username).matches())
            return "Usa de 3 a 30 caracteres: letras, números, punto o guion bajo";
        return userRepo.findByUsername(username).filter(o -> !o.getId().equals(selfId)).isPresent()
                ? "Ese usuario ya está ocupado" : null;
    }

    @Transactional
    public User updateProfile(Integer userId, String fullName, String username) {
        User u = get(userId);
        if (fullName != null) {
            String n = fullName.trim().replaceAll("\\s+", " ");
            if (n.isEmpty() || n.length() > 100) throw new IllegalArgumentException("Escribe tu nombre (máximo 100 caracteres)");
            u.setFullName(n);
        }
        if (username != null && !username.trim().equals(u.getUsername())) {
            String nu = username.trim();
            LocalDateTime next = usernameChangeAvailableAt(u);
            if (next != null) throw new IllegalArgumentException("Podrás cambiar tu usuario de nuevo el " + next.toLocalDate());
            String problem = usernameProblem(nu, u.getId());
            if (problem != null) throw new IllegalArgumentException(problem);
            log.info("[cuenta] userId={} cambia usuario", u.getId());
            u.setUsername(nu);
            u.setUsernameChangedAt(LocalDateTime.now());
        }
        return userRepo.save(u);
    }

    @Transactional
    public void changePassword(Integer userId, String current, String next) {
        User u = get(userId);
        if (current == null || !encoder.matches(current, u.getPasswordHash()))
            throw new IllegalArgumentException("La contraseña actual no es correcta");
        if (next == null || next.length() < 8 || next.length() > 100)
            throw new IllegalArgumentException("La nueva contraseña debe tener al menos 8 caracteres");
        if (encoder.matches(next, u.getPasswordHash()))
            throw new IllegalArgumentException("La nueva contraseña debe ser distinta a la actual");
        u.setPasswordHash(encoder.encode(next));
        userRepo.save(u);
        log.info("[cuenta] userId={} cambió su contraseña", u.getId());
    }

    /** Guarda el correo nuevo como pendiente y envía la verificación; el cambio ocurre al confirmar. */
    @Transactional
    public User requestEmailChange(Integer userId, String newEmail, String password) {
        User u = get(userId);
        if (password == null || !encoder.matches(password, u.getPasswordHash()))
            throw new IllegalArgumentException("La contraseña no es correcta");
        String e = newEmail == null ? "" : newEmail.trim().toLowerCase();
        if (!EMAIL.matcher(e).matches() || e.length() > 150) throw new IllegalArgumentException("Escribe un correo válido");
        if (e.equalsIgnoreCase(u.getEmail())) throw new IllegalArgumentException("Ese ya es tu correo");
        if (userRepo.findByEmail(e).isPresent()) throw new IllegalArgumentException("Ese correo ya lo usa otra cuenta");
        u.setPendingEmail(e);
        User saved = userRepo.save(u);
        verification.send(saved);
        return saved;
    }

    @Transactional
    public User cancelEmailChange(Integer userId) {
        User u = get(userId);
        u.setPendingEmail(null);
        return userRepo.save(u);
    }

    @Transactional
    public void delete(Integer userId, String password) {
        User u = get(userId);
        if (password == null || !encoder.matches(password, u.getPasswordHash()))
            throw new IllegalArgumentException("La contraseña no es correcta");
        if (u.isAdmin()) throw new IllegalArgumentException("Una cuenta de administrador no se puede borrar desde la app");
        userRepo.delete(u);   // las tablas hijas tienen on delete cascade
        log.info("[cuenta] userId={} borró su cuenta", userId);
    }
}
