-- ============================================================
--  publicar curso / dar acceso a pruebas — tlahtolcalli  [postgresql]
--
--  draft     → solo se ve en el front de desarrollo, con rol tester o admin
--  published → visible para todos (producción)
--  la caché de la api tarda hasta 30 min en notarlo (o reiniciar render).
--  descomenta la línea que necesites y cambia el código o el usuario.
-- ============================================================

-- publicar un curso
-- update ct_languages set status = 'published' where code = 'xxx';

-- regresarlo a pruebas
-- update ct_languages set status = 'draft' where code = 'xxx';

-- dar acceso a los cursos en pruebas a una cuenta (o quitárselo con 'user')
-- update ta_users set role = 'tester' where username = 'mi_usuario';

-- dar acceso solo a un curso en pruebas (p. ej. a un hablante): rol tester + asignación.
-- sin asignaciones el tester ve todos los cursos en pruebas. la api tarda hasta 5 min en notarlo.
-- update ta_users set role = 'tester' where username = 'hablante';
-- insert into ta_user_course_access (user_id, language_id)
-- select u.id, l.id from ta_users u, ct_languages l where u.username = 'hablante' and l.code = 'xxx'
-- on conflict do nothing;

-- quitarle un curso asignado (si se queda sin ninguno, vuelve a ver todos los cursos en pruebas)
-- delete from ta_user_course_access
--  where user_id = (select id from ta_users where username = 'hablante')
--    and language_id = (select id from ct_languages where code = 'xxx');

-- estado actual
select code, lang_name, status from ct_languages order by id;
select username, role from ta_users where role <> 'user' order by id;
select u.username, l.code
  from ta_user_course_access a
  join ta_users u     on u.id = a.user_id
  join ct_languages l on l.id = a.language_id
 order by u.username, l.code;

-- acceso a un hablante
update ta_users set role = 'tester' where username = 'hablante';
insert into ta_user_course_access (user_id, language_id)
select u.id, l.id from ta_users u, ct_languages l where u.username = 'hablante' and l.code = 'yua'
    on conflict do nothing;