-- ============================================================
--  reiniciar base — tlahtolcalli  [postgresql]
--
--  ⚠ borra todas las tablas con sus datos (usuarios incluidos). no se puede deshacer.
--  después se vuelve a montar con 1.-esquema.sql, 2.-datos_generales.sql y los cursos.
--  reemplaza a tlahtolli_truncate_all.sql.
-- ============================================================

begin;

drop view  if exists v_unit_access;
drop table if exists ta_study_days        cascade;
drop table if exists ta_sync_ops          cascade;
drop table if exists ta_email_tokens      cascade;
drop table if exists ta_user_achievements cascade;
drop table if exists ta_lesson_history    cascade;
drop table if exists ta_user_progress     cascade;
drop table if exists ta_user_energy       cascade;
drop table if exists ta_user_stats        cascade;
drop table if exists ta_users             cascade;
drop table if exists ct_achievements      cascade;
drop table if exists ct_writing_systems   cascade;
drop table if exists ct_exercises         cascade;
drop table if exists rl_unit_vocab        cascade;
drop table if exists ct_vocabulary        cascade;
drop table if exists ct_lessons           cascade;
drop table if exists ct_units             cascade;
drop table if exists ct_levels            cascade;
drop table if exists ct_languages         cascade;

commit;
