package com.tlahtolli.api.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.tlahtolli.api.security.CurrentUser;
import com.tlahtolli.api.security.TokenService;
import com.tlahtolli.api.service.ReportService;

/** "Reportar un problema" en un ejercicio: se envía por correo al contacto de la app. */
@RestController
@RequestMapping("/api/reports")
public class ReportController {

    public record ReportRequest(
            List<String> reasons, String comment,
            String screen, Integer unitId, Integer levelId,
            Integer exerciseId, String exerciseType, String question, String prompt,
            List<String> options, String userAnswer, String correctAnswer,
            Boolean wasCorrect, String language, String appVersion) {}

    private final ReportService reports;

    public ReportController(ReportService reports) {
        this.reports = reports;
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> send(@RequestBody ReportRequest req) {
        TokenService.Claims me = CurrentUser.get();
        reports.send(me.userId(), me.username(), req);
        return ResponseEntity.status(HttpStatus.ACCEPTED).body(Map.<String, Object>of("ok", true));
    }
}
