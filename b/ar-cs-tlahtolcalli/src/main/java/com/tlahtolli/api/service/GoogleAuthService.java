package com.tlahtolli.api.service;

import java.text.Normalizer;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.tlahtolli.api.entity.User;
import com.tlahtolli.api.repository.UserRepository;
import com.tlahtolli.api.security.GoogleTokenVerifier;
import com.tlahtolli.api.security.GoogleTokenVerifier.GoogleUser;

/**
 * Inicio de sesión / registro con Google.
 *  1. Cuenta ya vinculada (google_sub)            → entra.
 *  2. Existe una cuenta con el mismo correo:
 *       - se vincula solo si Google lo da por verificado Y en Tlahtolcalli también está verificado;
 *       - si no, se pide entrar con contraseña y verificar el correo (evita apropiarse de cuentas).
 *  3. Correo nuevo → se crea la cuenta (correo verificado, sin contraseña, usuario generado
 *     que el usuario confirma o cambia en su primer inicio, sin tiempo de espera).
 */
@Service
public class GoogleAuthService {

    private static final Logger log = LoggerFactory.getLogger(GoogleAuthService.class);

    public record Result(User user, boolean created) {}

    private final GoogleTokenVerifier verifier;
    private final UserRepository userRepo;
    private final EnergyService energyService;

    public GoogleAuthService(GoogleTokenVerifier verifier, UserRepository userRepo, EnergyService energyService) {
        this.verifier = verifier;
        this.userRepo = userRepo;
        this.energyService = energyService;
    }

    public boolean isEnabled() { return verifier.isEnabled(); }

    @Transactional
    public Result login(String credential) {
        GoogleUser g = verifier.verify(credential);

        var linked = userRepo.findByGoogleSub(g.sub());
        if (linked.isPresent()) return new Result(linked.get(), false);

        if (!g.emailVerified())
            throw new IllegalArgumentException("Tu cuenta de Google no tiene el correo verificado");

        var byEmail = userRepo.findByEmailIgnoreCase(g.email());
        if (byEmail.isPresent()) {
            User u = byEmail.get();
            if (!u.isEmailVerified())
                throw new IllegalArgumentException("Ya hay una cuenta con este correo. Inicia sesión con tu usuario y contraseña "
                        + "y verifica tu correo; después podrás entrar con Google");
            u.setGoogleSub(g.sub());
            log.info("[google] cuenta vinculada userId={}", u.getId());
            return new Result(userRepo.save(u), false);
        }

        User u = new User();
        u.setUsername(uniqueUsername(g));
        u.setFullName(fullName(g));
        u.setEmail(g.email());
        u.setPasswordHash(null);
        u.setGoogleSub(g.sub());
        u.setEmailVerified(true);
        u.setEmailVerifiedAt(LocalDateTime.now());
        u.setMustPickUsername(true);
        u.setRole("user");
        u.setJoinDate(LocalDate.now());
        u.setUserLevel((short) 1);
        u.setXp(0);
        u.setTotalXp(0);
        u.setStreak((short) 0);
        User saved = userRepo.save(u);
        energyService.getOrCreate(saved.getId());
        log.info("[google] cuenta creada userId={}", saved.getId());
        return new Result(saved, true);
    }

    private static String fullName(GoogleUser g) {
        String n = g.name() != null && !g.name().isBlank() ? g.name() : g.email().substring(0, g.email().indexOf('@'));
        n = n.trim().replaceAll("\\s+", " ");
        return n.length() > 100 ? n.substring(0, 100) : n;
    }

    /** nombre_apellido → nombre_apellido2, 3… (3 a 30 caracteres: letras, números, punto, guion bajo). */
    private String uniqueUsername(GoogleUser g) {
        String base = slug(g.givenName() != null && g.familyName() != null
                ? g.givenName() + "_" + g.familyName()
                : g.name() != null ? g.name() : g.email().substring(0, g.email().indexOf('@')));
        if (base.length() < 3) base = slug(g.email().substring(0, g.email().indexOf('@')));
        if (base.length() < 3) base = "usuario";
        if (base.length() > 26) base = base.substring(0, 26);
        String candidate = base;
        for (int i = 2; userRepo.existsByUsernameIgnoreCase(candidate); i++) candidate = base + i;
        return candidate;
    }

    static String slug(String s) {
        String n = Normalizer.normalize(s, Normalizer.Form.NFD).replaceAll("\\p{M}", "").toLowerCase(Locale.ROOT);
        n = n.replaceAll("[\\s-]+", "_").replaceAll("[^a-z0-9_.]", "").replaceAll("_+", "_").replaceAll("^[_.]+|[_.]+$", "");
        return n;
    }
}
