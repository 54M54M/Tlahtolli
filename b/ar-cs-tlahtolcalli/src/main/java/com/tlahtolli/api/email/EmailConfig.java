package com.tlahtolli.api.email;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

/**
 * Variables de entorno:
 *   EMAIL_PROVIDER   console | brevo           (por defecto console)
 *   BREVO_API_KEY    llave de API de Brevo     (solo con brevo)
 *   EMAIL_FROM       remitente verificado en Brevo, p. ej. contacto.tlahtolcalli@gmail.com
 *   EMAIL_FROM_NAME  nombre del remitente      (por defecto "Tlahtolcalli")
 *   APP_URL          URL del frontend para los enlaces (por defecto https://tlahtolcalli.netlify.app)
 */
@Configuration
public class EmailConfig {

    @Bean
    public EmailSender emailSender(Environment env) {
        String provider = env.getProperty("EMAIL_PROVIDER", "console").trim().toLowerCase();
        if (provider.equals("brevo")) {
            String key = env.getProperty("BREVO_API_KEY");
            String from = env.getProperty("EMAIL_FROM");
            if (key == null || key.isBlank() || from == null || from.isBlank())
                throw new IllegalStateException("EMAIL_PROVIDER=brevo requiere BREVO_API_KEY y EMAIL_FROM");
            return new BrevoEmailSender(key, from, env.getProperty("EMAIL_FROM_NAME", "Tlahtolcalli"));
        }
        return new ConsoleEmailSender();
    }
}
