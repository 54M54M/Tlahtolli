-- ============================================================
--  recalcular progreso — tlahtolcalli  [postgresql]
--
--  vuelve a calcular lo que el back actualiza solo, por si los datos quedaron mal
--  (cambios a mano, borrado de un curso, una versión vieja del back):
--    1. ta_study_days       días estudiados, rellenados con el historial de lecciones
--    2. ta_user_stats       days_studied y best_streak por idioma
--    3. ta_users            streak y last_study_date (racha actual, cualquier idioma)
--    4. ta_users.user_level según la xp total (nunca baja)
--    5. ta_user_progress    una unidad completada no puede ser la "actual"
--  reemplaza a los scripts 13, 15 y la limpieza del 16. re-ejecutable, en cualquier momento.
-- ============================================================

begin;

-- 1-3. racha y días de estudio
-- historial existente (el idioma sale de unidad → nivel)
insert into ta_study_days (user_id, language_id, study_date)
select distinct h.user_id, l.language_id, h.completed_at
  from ta_lesson_history h
  join ct_units  u on u.id = h.unit_id
  join ct_levels l on l.id = u.level_id
 where h.completed_at is not null
on conflict do nothing;

-- días estudiados por idioma
update ta_user_stats s
   set days_studied = coalesce((select count(1)
                                  from ta_study_days d
                                 where d.user_id = s.user_id
                                   and d.language_id = s.language_id), 0);

-- mejor racha por idioma (días seguidos: fecha - número de fila es igual dentro de cada racha)
with runs as (
    select user_id, language_id,
           study_date - (row_number() over (partition by user_id, language_id order by study_date))::int as grp
      from ta_study_days
), best as (
    select user_id, language_id, max(len) as best
      from (select user_id, language_id, grp, count(1) as len from runs group by user_id, language_id, grp) x
     group by user_id, language_id
)
update ta_user_stats s
   set best_streak = least(b.best, 32767)
  from best b
 where b.user_id = s.user_id
   and b.language_id = s.language_id;

-- racha actual: la que termina en el último día estudiado (en cualquier idioma)
with days as (
    select distinct user_id, study_date from ta_study_days
), runs as (
    select user_id, study_date,
           study_date - (row_number() over (partition by user_id order by study_date))::int as grp
      from days
), grouped as (
    select user_id, grp, count(1) as len, max(study_date) as last_day
      from runs
     group by user_id, grp
), latest as (
    select distinct on (user_id) user_id, len, last_day
      from grouped
     order by user_id, last_day desc
)
update ta_users u
   set streak = least(l.len, 32767),
       last_study_date = l.last_day
  from latest l
 where l.user_id = u.id;

-- 4. nivel del usuario: xp por nivel = promedio de puntos por nivel de los cursos publicados (≈ 540)
with por_nivel as (
    select coalesce(nullif(round(avg(level_points)), 0), 540)::int as xp
      from (select lv.id, sum(coalesce(e.points, 0)) as level_points
              from ct_levels lv
              join ct_languages lang on lang.id = lv.language_id and lang.status = 'published'
              join ct_units u        on u.level_id = lv.id
              join ct_exercises e    on e.unit_id = u.id
             group by lv.id) x
)
update ta_users u
   set user_level = greatest(coalesce(u.user_level, 1), least(coalesce(u.total_xp, 0) / p.xp + 1, 32767))
  from por_nivel p;

-- 5. unidad actual
update ta_user_progress
   set is_current = 0
 where completed = 1
   and is_current = 1;

commit;

-- verificación
select u.id, u.username, u.total_xp, u.user_level, u.streak, u.last_study_date,
       (select sum(s.days_studied) from ta_user_stats s where s.user_id = u.id) as dias_estudiados
  from ta_users u
 order by u.id;
