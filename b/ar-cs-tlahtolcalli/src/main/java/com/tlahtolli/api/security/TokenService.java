package com.tlahtolli.api.security;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.Instant;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.tlahtolli.api.entity.User;

/**
 * Tokens JWT firmados con HMAC-SHA256 (HS256), sin dependencias externas.
 *
 *   JWT_SECRET  obligatorio, mínimo 32 caracteres (en Render: Environment)
 *   JWT_HOURS   opcional, vigencia en horas (por defecto 168 = 7 días)
 */
@Service
public class TokenService {

    private static final Base64.Encoder B64 = Base64.getUrlEncoder().withoutPadding();
    private static final Base64.Decoder B64D = Base64.getUrlDecoder();
    private static final String HEADER = B64.encodeToString("{\"alg\":\"HS256\",\"typ\":\"JWT\"}".getBytes(StandardCharsets.UTF_8));

    private final byte[] secret;
    private final long ttlSeconds;
    private final ObjectMapper mapper = new ObjectMapper();

    public TokenService(Environment env) {
        String s = env.getProperty("JWT_SECRET");
        if (s == null || s.length() < 32)
            throw new IllegalStateException("Falta JWT_SECRET o tiene menos de 32 caracteres (ver TokenService)");
        this.secret = s.getBytes(StandardCharsets.UTF_8);
        this.ttlSeconds = env.getProperty("JWT_HOURS", Long.class, 168L) * 3600;
    }

    public record Claims(Integer userId, String username, String role, long exp) {
        public boolean isAdmin() { return "admin".equalsIgnoreCase(role); }
    }

    /** Emite un token para el usuario. Devuelve [token, expiración en epoch segundos]. */
    public Issued issue(User u) {
        return issue(u, ttlSeconds);
    }

    /** Igual que issue(u), con vigencia propia (el monitor usa tokens cortos ligados a su sesión). */
    public Issued issue(User u, long seconds) {
        long exp = Instant.now().getEpochSecond() + seconds;
        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("sub", String.valueOf(u.getId()));
        payload.put("usr", u.getUsername());
        payload.put("role", u.getRole() == null ? "user" : u.getRole());
        payload.put("iat", Instant.now().getEpochSecond());
        payload.put("exp", exp);
        try {
            String body = B64.encodeToString(mapper.writeValueAsBytes(payload));
            String unsigned = HEADER + "." + body;
            return new Issued(unsigned + "." + sign(unsigned), exp);
        } catch (Exception e) {
            throw new IllegalStateException("No se pudo generar el token", e);
        }
    }

    public record Issued(String token, long expiresAt) {}

    /** Valida firma y vigencia. Vacío si el token no es válido. */
    public Optional<Claims> parse(String token) {
        try {
            String[] parts = token.split("\\.");
            if (parts.length != 3 || !HEADER.equals(parts[0])) return Optional.empty();
            String expected = sign(parts[0] + "." + parts[1]);
            if (!MessageDigest.isEqual(expected.getBytes(StandardCharsets.US_ASCII), parts[2].getBytes(StandardCharsets.US_ASCII)))
                return Optional.empty();
            Map<?, ?> p = mapper.readValue(B64D.decode(parts[1]), Map.class);
            long exp = ((Number) p.get("exp")).longValue();
            if (Instant.now().getEpochSecond() >= exp) return Optional.empty();
            return Optional.of(new Claims(Integer.valueOf((String) p.get("sub")), (String) p.get("usr"), (String) p.get("role"), exp));
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    private String sign(String data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(secret, "HmacSHA256"));
        return B64.encodeToString(mac.doFinal(data.getBytes(StandardCharsets.US_ASCII)));
    }
}
