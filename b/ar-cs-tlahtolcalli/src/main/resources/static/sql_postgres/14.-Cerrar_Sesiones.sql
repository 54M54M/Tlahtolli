-- ============================================================
--  14. cerrar sesiones al restablecer la contraseña
--
--  cada token lleva la versión del usuario (claim "tv"). al restablecer la contraseña la versión sube y
--  todos los tokens anteriores dejan de valer: se cierran las sesiones abiertas en todos los dispositivos.
--  los tokens emitidos antes de este cambio no traen versión y cuentan como 0. re-ejecutable.
-- ============================================================

alter table ta_users add column if not exists token_version integer not null default 0;

-- verificación
select id, username, token_version from ta_users order by id;
