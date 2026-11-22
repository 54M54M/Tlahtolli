package com.tlahtolli.api.email;

/** Plantillas de correo (HTML sencillo, compatible con clientes de correo, y versión de texto). */
public final class EmailTemplates {

    private EmailTemplates() {}

    public record Mail(String subject, String html, String text) {}

    public static Mail verify(String name, String link, boolean changingEmail) {
        String subject = changingEmail ? "Confirma tu nuevo correo · Tlahtolcalli" : "Confirma tu correo · Tlahtolcalli";
        String intro = changingEmail
                ? "Pediste usar este correo en tu cuenta de Tlahtolcalli. Confírmalo para terminar el cambio."
                : "Gracias por crear tu cuenta en Tlahtolcalli. Confirma tu correo para proteger tu cuenta.";
        String html = """
            <!doctype html><html lang="es"><body style="margin:0;padding:24px;background:#0e1517;font-family:Arial,Helvetica,sans-serif;color:#ece6da">
              <table role="presentation" width="100%%" cellspacing="0" cellpadding="0"><tr><td align="center">
                <table role="presentation" width="100%%" style="max-width:480px;background:#1f2d32;border-radius:12px;padding:28px" cellspacing="0" cellpadding="0">
                  <tr><td style="font-size:13px;letter-spacing:2px;text-transform:uppercase;color:#2bb59a;font-weight:bold">Tlahtolcalli</td></tr>
                  <tr><td style="padding-top:12px;font-size:20px;font-weight:bold">Hola, %s</td></tr>
                  <tr><td style="padding-top:10px;font-size:15px;line-height:1.5;color:#a3ada9">%s</td></tr>
                  <tr><td style="padding:24px 0"><a href="%s" style="display:inline-block;background:#146b5b;color:#ffffff;text-decoration:none;font-weight:bold;padding:12px 22px;border-radius:8px">Confirmar mi correo</a></td></tr>
                  <tr><td style="font-size:12px;line-height:1.5;color:#a3ada9">El enlace vence en 24 horas. Si tú no lo pediste, ignora este correo.<br><br>Si el botón no funciona, copia este enlace:<br><span style="color:#2bb59a;word-break:break-all">%s</span></td></tr>
                </table>
              </td></tr></table>
            </body></html>
            """.formatted(escape(name), intro, link, link);
        String text = "Hola, " + name + "\n\n" + intro + "\n\nConfirma aquí (vence en 24 horas):\n" + link
                + "\n\nSi tú no lo pediste, ignora este correo.\n\nTlahtolcalli";
        return new Mail(subject, html, text);
    }

    public static Mail emailChangedNotice(String name, String newEmail) {
        String subject = "Se cambió el correo de tu cuenta · Tlahtolcalli";
        String text = "Hola, " + name + "\n\nEl correo de tu cuenta de Tlahtolcalli se cambió a " + newEmail
                + ".\n\nSi no fuiste tú, escríbenos a contacto.tlahtolcalli@gmail.com.\n\nTlahtolcalli";
        String html = "<p>Hola, " + escape(name) + "</p><p>El correo de tu cuenta de Tlahtolcalli se cambió a <b>"
                + escape(newEmail) + "</b>.</p><p>Si no fuiste tú, escríbenos a contacto.tlahtolcalli@gmail.com.</p>";
        return new Mail(subject, html, text);
    }

    public static Mail passwordReset(String name, String username, String link) {
        String subject = "Crea una contraseña nueva · Tlahtolcalli";
        String intro = "Pediste restablecer la contraseña de tu cuenta de Tlahtolcalli. Tu usuario es <b>"
                + escape(username) + "</b>.";
        String html = """
            <!doctype html><html lang="es"><body style="margin:0;padding:24px;background:#0e1517;font-family:Arial,Helvetica,sans-serif;color:#ece6da">
              <table role="presentation" width="100%%" cellspacing="0" cellpadding="0"><tr><td align="center">
                <table role="presentation" width="100%%" style="max-width:480px;background:#1f2d32;border-radius:12px;padding:28px" cellspacing="0" cellpadding="0">
                  <tr><td style="font-size:13px;letter-spacing:2px;text-transform:uppercase;color:#2bb59a;font-weight:bold">Tlahtolcalli</td></tr>
                  <tr><td style="padding-top:12px;font-size:20px;font-weight:bold">Hola, %s</td></tr>
                  <tr><td style="padding-top:10px;font-size:15px;line-height:1.5;color:#a3ada9">%s</td></tr>
                  <tr><td style="padding:24px 0"><a href="%s" style="display:inline-block;background:#146b5b;color:#ffffff;text-decoration:none;font-weight:bold;padding:12px 22px;border-radius:8px">Crear contraseña nueva</a></td></tr>
                  <tr><td style="font-size:12px;line-height:1.5;color:#a3ada9">El enlace vence en 1 hora y solo se puede usar una vez. Si tú no lo pediste, ignora este correo: tu contraseña no cambia.<br><br>Si el botón no funciona, copia este enlace:<br><span style="color:#2bb59a;word-break:break-all">%s</span></td></tr>
                </table>
              </td></tr></table>
            </body></html>
            """.formatted(escape(name), intro, link, link);
        String text = "Hola, " + name + "\n\nPediste restablecer la contraseña de tu cuenta de Tlahtolcalli. Tu usuario es "
                + username + ".\n\nCrea una contraseña nueva aquí (vence en 1 hora):\n" + link
                + "\n\nSi tú no lo pediste, ignora este correo: tu contraseña no cambia.\n\nTlahtolcalli";
        return new Mail(subject, html, text);
    }

    public static Mail passwordChangedNotice(String name) {
        String subject = "Se cambió tu contraseña · Tlahtolcalli";
        String text = "Hola, " + name + "\n\nLa contraseña de tu cuenta de Tlahtolcalli se cambió."
                + "\n\nSi no fuiste tú, escríbenos a contacto.tlahtolcalli@gmail.com.\n\nTlahtolcalli";
        String html = "<p>Hola, " + escape(name) + "</p><p>La contraseña de tu cuenta de Tlahtolcalli se cambió.</p>"
                + "<p>Si no fuiste tú, escríbenos a contacto.tlahtolcalli@gmail.com.</p>";
        return new Mail(subject, html, text);
    }

    private static String escape(String s) {
        return s == null ? "" : s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}
