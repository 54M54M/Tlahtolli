package com.tlahtolli.api.email;

/**
 * Envío de correos. La implementación se elige con la variable EMAIL_PROVIDER:
 *   console (por defecto) → imprime el correo en el log, para desarrollo local
 *   brevo                 → API HTTP de Brevo (Render gratis bloquea SMTP)
 */
public interface EmailSender {
    void send(String toEmail, String toName, String subject, String html, String text);
}
