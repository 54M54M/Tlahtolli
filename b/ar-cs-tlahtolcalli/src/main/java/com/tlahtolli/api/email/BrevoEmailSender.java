package com.tlahtolli.api.email;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Envío por la API HTTP de Brevo (https://api.brevo.com/v3/smtp/email).
 * El remitente (EMAIL_FROM) debe estar verificado en Brevo: Senders, Domains & Dedicated IPs → Senders.
 */
public class BrevoEmailSender implements EmailSender {

    private static final Logger log = LoggerFactory.getLogger(BrevoEmailSender.class);
    private static final URI ENDPOINT = URI.create("https://api.brevo.com/v3/smtp/email");

    private final String apiKey;
    private final String fromEmail;
    private final String fromName;
    private final HttpClient http = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(8)).build();
    private final ObjectMapper mapper = new ObjectMapper();

    public BrevoEmailSender(String apiKey, String fromEmail, String fromName) {
        this.apiKey = apiKey;
        this.fromEmail = fromEmail;
        this.fromName = fromName;
    }

    @Override
    public void send(String toEmail, String toName, String subject, String html, String text) {
        try {
            String body = mapper.writeValueAsString(Map.of(
                    "sender", Map.of("email", fromEmail, "name", fromName),
                    "to", List.of(Map.of("email", toEmail, "name", toName == null ? toEmail : toName)),
                    "subject", subject,
                    "htmlContent", html,
                    "textContent", text));
            HttpRequest req = HttpRequest.newBuilder(ENDPOINT).timeout(Duration.ofSeconds(10))
                    .header("api-key", apiKey)
                    .header("accept", "application/json")
                    .header("content-type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(body)).build();
            HttpResponse<String> res = http.send(req, HttpResponse.BodyHandlers.ofString());
            if (res.statusCode() >= 300) {
                log.error("[email] Brevo respondió {}: {}", res.statusCode(), res.body());
                throw new IllegalStateException("No se pudo enviar el correo");
            }
            log.info("[email] enviado a {} ({})", toEmail, subject);
        } catch (IllegalStateException e) {
            throw e;
        } catch (Exception e) {
            log.error("[email] error al enviar a {}: {}", toEmail, e.getMessage());
            throw new IllegalStateException("No se pudo enviar el correo");
        }
    }
}
