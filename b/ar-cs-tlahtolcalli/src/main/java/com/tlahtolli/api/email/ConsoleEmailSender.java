package com.tlahtolli.api.email;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/** Desarrollo local: no envía nada, escribe el correo (y su enlace) en la consola. */
public class ConsoleEmailSender implements EmailSender {

    private static final Logger log = LoggerFactory.getLogger(ConsoleEmailSender.class);

    @Override
    public void send(String toEmail, String toName, String subject, String html, String text) {
        log.info("\n──── CORREO (EMAIL_PROVIDER=console) ────\nPara: {} <{}>\nAsunto: {}\n\n{}\n─────────────────────────────────────────", toName, toEmail, subject, text);
    }
}
