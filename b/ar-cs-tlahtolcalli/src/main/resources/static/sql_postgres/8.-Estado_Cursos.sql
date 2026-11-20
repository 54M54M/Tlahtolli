-- ============================================================
--  8. estado de los cursos (en pruebas / publicado)
--
--  draft     → solo se ve en el front de desarrollo, con rol tester o admin
--  published → visible para todos (producción)
--
--  los cursos que ya existen quedan publicados.
-- ============================================================

alter table ct_languages
    add column if not exists status varchar(20) not null default 'published';

alter table ct_languages
    drop constraint if exists chk_languages_status;

alter table ct_languages
    add constraint chk_languages_status check (status in ('draft', 'published'));

-- ------------------------------------------------------------
--  operación diaria (ejemplos)
-- ------------------------------------------------------------

-- dar acceso a los cursos en pruebas a una cuenta
-- update ta_users set role = 'tester' where username = 'mi_usuario';

-- un curso nuevo nace en pruebas
-- insert into ct_languages (code, lang_name, native_name, color, flag, family, writing_system, status)
-- values ('xxx', 'Nombre', 'Nombre nativo', '#000000', '🌐', 'Familia', 'alphabet', 'draft');

-- publicarlo (aparece en producción; la caché de la api tarda hasta 30 min o reinicia render)
-- update ct_languages set status = 'published' where code = 'xxx';

-- regresarlo a pruebas
-- update ct_languages set status = 'draft' where code = 'xxx';
