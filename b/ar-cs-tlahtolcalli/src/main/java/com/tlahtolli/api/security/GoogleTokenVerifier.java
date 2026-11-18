package com.tlahtolli.api.security;

import java.math.BigInteger;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.Signature;
import java.security.spec.RSAPublicKeySpec;
import java.time.Duration;
import java.time.Instant;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Valida el ID token (JWT RS256) que entrega el botón "Continuar con Google", sin dependencias externas:
 *  - firma RS256 con las llaves públicas de Google (JWKS, se cachean y se recargan si aparece un "kid" nuevo)
 *  - iss = accounts.google.com, aud = GOOGLE_CLIENT_ID, exp vigente (60 s de tolerancia)
 *
 *   GOOGLE_CLIENT_ID  obligatorio para usar Google (si falta, el endpoint responde "no disponible")
 */
@Service
public class GoogleTokenVerifier {

    private static final Logger log = LoggerFactory.getLogger(GoogleTokenVerifier.class);
    private static final String JWKS_URL = "https://www.googleapis.com/oauth2/v3/certs";
    private static final Set<String> ISSUERS = Set.of("accounts.google.com", "https://accounts.google.com");
    private static final long SKEW_SECONDS = 60;
    private static final Base64.Decoder B64 = Base64.getUrlDecoder();

    public record GoogleUser(String sub, String email, boolean emailVerified, String name, String givenName, String familyName) {}

    private final String clientId;
    private final ObjectMapper mapper = new ObjectMapper();
    private final HttpClient http = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(5)).build();

    private volatile Map<String, PublicKey> keys = Map.of();
    private volatile Instant keysExpireAt = Instant.EPOCH;
    private volatile Instant lastFetch = Instant.EPOCH;

    public GoogleTokenVerifier(Environment env) {
        String id = env.getProperty("GOOGLE_CLIENT_ID");
        this.clientId = id == null || id.isBlank() ? null : id.trim();
        if (clientId == null) log.warn("[google] GOOGLE_CLIENT_ID no está configurado: el inicio con Google está desactivado");
    }

    public boolean isEnabled() { return clientId != null; }

    public GoogleUser verify(String idToken) {
        if (!isEnabled()) throw new IllegalArgumentException("El inicio con Google no está disponible");
        if (idToken == null || idToken.isBlank()) throw new IllegalArgumentException("Falta el token de Google");
        String[] parts = idToken.trim().split("\\.");
        if (parts.length != 3) throw invalid();
        try {
            JsonNode header = mapper.readTree(B64.decode(parts[0]));
            if (!"RS256".equals(header.path("alg").asText())) throw invalid();
            PublicKey key = key(header.path("kid").asText(null));

            Signature sig = Signature.getInstance("SHA256withRSA");
            sig.initVerify(key);
            sig.update((parts[0] + "." + parts[1]).getBytes(StandardCharsets.US_ASCII));
            if (!sig.verify(B64.decode(parts[2]))) throw invalid();

            JsonNode p = mapper.readTree(B64.decode(parts[1]));
            long now = Instant.now().getEpochSecond();
            if (!ISSUERS.contains(p.path("iss").asText())) throw invalid();
            if (!audienceMatches(p.path("aud"))) throw invalid();
            if (p.path("exp").asLong(0) + SKEW_SECONDS < now) throw new IllegalArgumentException("La sesión de Google venció, intenta de nuevo");
            if (p.has("iat") && p.path("iat").asLong(0) - SKEW_SECONDS > now) throw invalid();

            String sub = p.path("sub").asText("");
            String email = p.path("email").asText("").trim().toLowerCase();
            if (sub.isEmpty() || email.isEmpty()) throw invalid();
            JsonNode ev = p.path("email_verified");
            boolean verified = ev.isBoolean() ? ev.asBoolean() : "true".equalsIgnoreCase(ev.asText());
            return new GoogleUser(sub, email, verified,
                    p.path("name").asText(null), p.path("given_name").asText(null), p.path("family_name").asText(null));
        } catch (IllegalArgumentException e) {
            throw e;
        } catch (Exception e) {
            log.warn("[google] token inválido: {}", e.toString());
            throw invalid();
        }
    }

    private boolean audienceMatches(JsonNode aud) {
        if (aud.isArray()) {
            for (JsonNode a : aud) if (clientId.equals(a.asText())) return true;
            return false;
        }
        return clientId.equals(aud.asText());
    }

    private PublicKey key(String kid) throws Exception {
        if (kid == null) throw invalid();
        PublicKey k = Instant.now().isBefore(keysExpireAt) ? keys.get(kid) : null;
        if (k != null) return k;
        // llaves vencidas o "kid" desconocido (Google rota llaves): recargar, máximo una vez cada 30 s
        synchronized (this) {
            k = Instant.now().isBefore(keysExpireAt) ? keys.get(kid) : null;
            if (k == null && Instant.now().isAfter(lastFetch.plusSeconds(30))) {
                fetchKeys();
                k = keys.get(kid);
            }
        }
        if (k == null) throw invalid();
        return k;
    }

    private void fetchKeys() throws Exception {
        lastFetch = Instant.now();
        HttpResponse<String> res = http.send(
                HttpRequest.newBuilder(URI.create(JWKS_URL)).timeout(Duration.ofSeconds(8)).GET().build(),
                HttpResponse.BodyHandlers.ofString());
        if (res.statusCode() != 200) throw new IllegalStateException("JWKS de Google respondió " + res.statusCode());

        Map<String, PublicKey> fresh = new HashMap<>();
        KeyFactory kf = KeyFactory.getInstance("RSA");
        for (JsonNode jwk : mapper.readTree(res.body()).path("keys")) {
            if (!"RSA".equals(jwk.path("kty").asText())) continue;
            BigInteger n = new BigInteger(1, B64.decode(jwk.path("n").asText()));
            BigInteger e = new BigInteger(1, B64.decode(jwk.path("e").asText()));
            fresh.put(jwk.path("kid").asText(), kf.generatePublic(new RSAPublicKeySpec(n, e)));
        }
        long maxAge = res.headers().firstValue("cache-control")
                .map(cc -> cc.replaceAll(".*max-age=(\\d+).*", "$1"))
                .filter(v -> v.matches("\\d+")).map(Long::parseLong).orElse(3600L);
        keys = Map.copyOf(fresh);
        keysExpireAt = Instant.now().plusSeconds(maxAge);
        log.info("[google] llaves públicas cargadas: {} (vigencia {} s)", fresh.size(), maxAge);
    }

    /** Solo para pruebas: carga llaves sin ir a Google. */
    void setKeysForTest(Map<String, PublicKey> k) {
        keys = Map.copyOf(k);
        keysExpireAt = Instant.now().plusSeconds(3600);
        lastFetch = Instant.now();
    }

    private static IllegalArgumentException invalid() {
        return new IllegalArgumentException("No se pudo validar tu cuenta de Google");
    }
}
