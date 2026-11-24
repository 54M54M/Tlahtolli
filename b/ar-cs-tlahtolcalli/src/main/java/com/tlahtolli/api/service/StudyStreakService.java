package com.tlahtolli.api.service;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

/**
 * Días de estudio y rachas (ta_study_days: una fila por usuario, idioma y día con al menos una lección).
 *
 *   Racha actual (ta_users.streak + last_study_date): días seguidos, en cualquier idioma, que terminan en el último
 *   día estudiado. Al leerla, si ese día no es hoy ni ayer, vale 0 (User.currentStreak).
 *   Días estudiados y mejor racha (ta_user_stats): por idioma.
 *
 * Se recalcula desde ta_study_days en cada lección (pocos cientos de filas por usuario), así una lección enviada
 * tarde (hecha sin conexión) cuenta en su día real y el conteo se corrige solo.
 */
@Service
public class StudyStreakService {

    /** Racha: días seguidos y el último día de esa racha. */
    public record Run(int length, LocalDate lastDay) {}

    private final JdbcTemplate jdbc;

    public StudyStreakService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    /** Marca el día como estudiado en ese idioma (si ya estaba, no hace nada). */
    public void markDay(Integer userId, Integer languageId, LocalDate day) {
        jdbc.update("insert into ta_study_days (user_id, language_id, study_date) values (?, ?, ?) on conflict do nothing",
                userId, languageId, Date.valueOf(day));
    }

    public int daysStudied(Integer userId, Integer languageId) {
        Integer n = jdbc.queryForObject("select count(1) from ta_study_days where user_id = ? and language_id = ?",
                Integer.class, userId, languageId);
        return n == null ? 0 : n;
    }

    /** Mejor racha en ese idioma. */
    public int bestRun(Integer userId, Integer languageId) {
        List<LocalDate> days = jdbc.queryForList(
                "select study_date from ta_study_days where user_id = ? and language_id = ? order by study_date",
                Date.class, userId, languageId).stream().map(Date::toLocalDate).toList();
        int best = 0, run = 0;
        LocalDate prev = null;
        for (LocalDate d : days) {
            run = prev != null && d.equals(prev.plusDays(1)) ? run + 1 : 1;
            best = Math.max(best, run);
            prev = d;
        }
        return best;
    }

    /** Racha que termina en el último día estudiado (en cualquier idioma). */
    public Run currentRun(Integer userId) {
        List<LocalDate> days = jdbc.queryForList(
                "select distinct study_date from ta_study_days where user_id = ? order by study_date desc limit 400",
                Date.class, userId).stream().map(Date::toLocalDate).toList();
        if (days.isEmpty()) return new Run(0, null);
        int run = 1;
        for (int i = 1; i < days.size() && days.get(i).equals(days.get(i - 1).minusDays(1)); i++) run++;
        return new Run(run, days.get(0));
    }
}
