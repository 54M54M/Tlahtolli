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

-- estado actual
select code, lang_name, status from ct_languages order by id;
select username, role from ta_users where role <> 'user' order by id;
