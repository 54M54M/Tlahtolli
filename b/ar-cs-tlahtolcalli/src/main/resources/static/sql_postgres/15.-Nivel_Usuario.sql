-- ============================================================
--  15. nivel del usuario según su experiencia
--
--  xp por nivel = lo que vale completar un nivel del curso: suma de los puntos de los ejercicios de cada nivel,
--  promedio de los niveles de los cursos publicados (hoy 36 ejercicios × ~15 puntos ≈ 540).
--  el back usa la misma cuenta (UserLevelService) y actualiza user_level cada vez que se gana xp.
--  antes user_level se quedaba siempre en 1. re-ejecutable; nunca baja un nivel.
-- ============================================================

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

-- verificación
select (select coalesce(nullif(round(avg(level_points)), 0), 540)
          from (select lv.id, sum(coalesce(e.points, 0)) as level_points
                  from ct_levels lv
                  join ct_languages lang on lang.id = lv.language_id and lang.status = 'published'
                  join ct_units u on u.level_id = lv.id
                  join ct_exercises e on e.unit_id = u.id
                 group by lv.id) x) as xp_por_nivel;
select id, username, total_xp, user_level from ta_users order by id;
