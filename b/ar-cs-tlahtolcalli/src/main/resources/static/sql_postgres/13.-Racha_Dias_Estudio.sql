-- ============================================================
--  13. racha y días de estudio
--
--  ta_study_days: una fila por usuario, idioma y día con al menos una lección (o nivel rápido).
--  de ahí salen:
--    · ta_users.streak + last_study_date  → racha actual (días seguidos, en cualquier idioma)
--    · ta_user_stats.days_studied         → días distintos estudiados en ese idioma
--    · ta_user_stats.best_streak          → mejor racha en ese idioma
--  antes days_studied sumaba 1 por lección y la racha nunca se calculaba.
--  rellena con el historial (ta_lesson_history) y recalcula todo. re-ejecutable.
-- ============================================================

create table if not exists ta_study_days (
    user_id      integer  not null references ta_users (id) on delete cascade,
    language_id  integer  not null references ct_languages (id) on delete cascade,
    study_date   date     not null,
    constraint pk_study_days primary key (user_id, language_id, study_date)
);

alter table ta_users add column if not exists last_study_date date;

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

-- verificación
select u.username, u.streak, u.last_study_date,
       (select sum(s.days_studied) from ta_user_stats s where s.user_id = u.id) as dias_estudiados
  from ta_users u
 order by u.id;
