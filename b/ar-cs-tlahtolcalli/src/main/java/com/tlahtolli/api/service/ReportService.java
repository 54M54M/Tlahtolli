package com.tlahtolli.api.service;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentHashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.tlahtolli.api.controller.ReportController.ReportRequest;
import com.tlahtolli.api.email.EmailSender;

/**
 * Reportes de ejercicios. No toca la BD: arma el correo y lo envía en segundo plano.
 *   REPORT_EMAIL  destino de los reportes (por defecto contacto.tlahtolcalli@gmail.com)
 * Límite: 10 reportes por hora por usuario (en memoria).
 * Asunto con [Revisar] para el filtro de Gmail (doc/gmail/filtros_gmail.xml).
 */
@Service
public class ReportService {

    private static final Logger log = LoggerFactory.getLogger(ReportService.class);
    private static final int MAX_PER_HOUR = 10;
    private static final long HOUR_MS = 3_600_000L;
    private static final int MAX_TEXT = 500;
    private static final int MAX_COMMENT = 1000;
    private static final DateTimeFormatter WHEN = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    private final EmailSender sender;
    private final String to;
    private final Map<Integer, Deque<Long>> recent = new ConcurrentHashMap<>();

    public ReportService(EmailSender sender, Environment env) {
        this.sender = sender;
        this.to = env.getProperty("REPORT_EMAIL", "contacto.tlahtolcalli@gmail.com").trim();
    }

    public void send(Integer userId, String username, ReportRequest r) {
        List<String> reasons = r.reasons() == null ? List.of()
                : r.reasons().stream().filter(s -> s != null && !s.isBlank()).limit(6).map(s -> cut(s, 200)).toList();
        String comment = cut(r.comment(), MAX_COMMENT);
        if (reasons.isEmpty() && comment.isEmpty())
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Marca un motivo o escribe un comentario");
        limit(userId);

        Map<String, String> rows = new LinkedHashMap<>();
        rows.put("Usuario", cut(username, 100) + " (id " + userId + ")");
        rows.put("Idioma", cut(r.language(), 20));
        rows.put("Pantalla", cut(r.screen(), 60));
        rows.put("Nivel", r.levelId() == null ? "" : r.levelId().toString());
        rows.put("Unidad", r.unitId() == null ? "" : r.unitId().toString());
        rows.put("Ejercicio", (r.exerciseId() == null ? "generado" : "id " + r.exerciseId())
                + " · " + cut(r.exerciseType(), 30));
        rows.put("Instrucción", cut(r.question(), MAX_TEXT));
        rows.put("Frase", cut(r.prompt(), MAX_TEXT));
        rows.put("Opciones", r.options() == null ? ""
                : String.join(" | ", r.options().stream().limit(8).map(s -> cut(s, 120)).toList()));
        rows.put("Respuesta del usuario", cut(r.userAnswer(), MAX_TEXT));
        rows.put("Respuesta correcta", cut(r.correctAnswer(), MAX_TEXT));
        rows.put("Se tomó como", r.wasCorrect() == null ? "" : r.wasCorrect() ? "correcta" : "incorrecta");
        rows.put("Versión", cut(r.appVersion(), 30));
        rows.put("Fecha", ZonedDateTime.now(ZoneId.of("America/Mexico_City")).format(WHEN));

        String subject = "[Revisar] Ejercicio · " + (r.language() == null || r.language().isBlank() ? "app" : cut(r.language(), 20))
                + " · " + (reasons.isEmpty() ? "comentario" : reasons.get(0));
        String html = html(reasons, comment, rows);
        String text = text(reasons, comment, rows);

        CompletableFuture.runAsync(() -> {
            try {
                sender.send(to, "Tlahtolcalli", subject, html, text);
            } catch (Exception e) {
                log.warn("[reportes] no se pudo enviar el reporte de {}: {}", userId, e.getMessage());
            }
        });
    }

    private void limit(Integer userId) {
        long now = System.currentTimeMillis();
        Deque<Long> times = recent.computeIfAbsent(userId, k -> new ArrayDeque<>());
        synchronized (times) {
            while (!times.isEmpty() && now - times.peekFirst() > HOUR_MS) times.pollFirst();
            if (times.size() >= MAX_PER_HOUR)
                throw new ResponseStatusException(HttpStatus.TOO_MANY_REQUESTS, "Demasiados reportes, inténtalo más tarde");
            times.addLast(now);
        }
    }

    private static String html(List<String> reasons, String comment, Map<String, String> rows) {
        StringBuilder b = new StringBuilder("<h2 style=\"margin:0 0 12px\">Reporte de un ejercicio</h2>");
        b.append("<p><b>Motivos</b></p><ul>");
        if (reasons.isEmpty()) b.append("<li>(ninguno)</li>");
        reasons.forEach(s -> b.append("<li>").append(esc(s)).append("</li>"));
        b.append("</ul><p><b>Comentario</b></p><p style=\"white-space:pre-wrap\">")
                .append(comment.isEmpty() ? "(sin comentario)" : esc(comment)).append("</p>");
        b.append("<table cellpadding=\"6\" style=\"border-collapse:collapse;font-size:14px\">");
        rows.forEach((k, v) -> {
            if (v == null || v.isBlank()) return;
            b.append("<tr><td style=\"border:1px solid #ddd;color:#555\"><b>").append(esc(k))
                    .append("</b></td><td style=\"border:1px solid #ddd\">").append(esc(v)).append("</td></tr>");
        });
        return b.append("</table>").toString();
    }

    private static String text(List<String> reasons, String comment, Map<String, String> rows) {
        StringBuilder b = new StringBuilder("Reporte de un ejercicio\n\nMotivos:\n");
        if (reasons.isEmpty()) b.append("- (ninguno)\n");
        reasons.forEach(s -> b.append("- ").append(s).append('\n'));
        b.append("\nComentario:\n").append(comment.isEmpty() ? "(sin comentario)" : comment).append("\n\n");
        rows.forEach((k, v) -> { if (v != null && !v.isBlank()) b.append(k).append(": ").append(v).append('\n'); });
        return b.toString();
    }

    private static String cut(String s, int max) {
        if (s == null) return "";
        String t = s.strip();
        return t.length() > max ? t.substring(0, max) + "…" : t;
    }

    private static String esc(String s) {
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }
}
