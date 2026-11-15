-- ============================================================
--  limpieza de idiomas — borra todo lo de los códigos indicados
--  tlahtolcalli  [postgresql]
--
--  uso: cambia el arreglo v_codes y ejecuta. ejemplo: array['nhn'] o array['nhn','hus'].
--
--  borra:
--    ct_languages del código y, en cascada:
--      ct_levels → ct_units → ct_lessons, ct_exercises, rl_unit_vocab,
--      ta_user_progress, ta_lesson_history
--      ct_vocabulary, ct_writing_systems
--    ta_user_stats del idioma (sin cascada en el esquema)
--    ta_user_achievements ganados en ese idioma
--    logros de catálogo exclusivos de esos idiomas
--  ajusta:
--    ta_users.current_lang → null (el usuario vuelve al selector de idioma)
--    ct_achievements.language_tag → quita los códigos de los logros compartidos
--  no toca: usuarios, energía, xp, otros idiomas ni logros globales.
--
--  re-ejecutable. el resumen sale en los mensajes (raise notice).
-- ============================================================

do $$
declare
    v_codes  text[] := array['nhn'];      -- ← códigos a borrar
    v_ids    integer[];
    v_count  integer;
begin
    select array_agg(id) into v_ids from ct_languages where code = any(v_codes);
    if v_ids is null then
        raise notice 'no existe ningún idioma con códigos %', v_codes;
        return;
    end if;

    -- 0. resumen previo
    raise notice 'idiomas: %  ·  niveles: %  ·  unidades: %  ·  vocabulario: %  ·  ejercicios: %',
        v_codes,
        (select count(1) from ct_levels where language_id = any(v_ids)),
        (select count(1) from ct_units u join ct_levels l on l.id = u.level_id where l.language_id = any(v_ids)),
        (select count(1) from ct_vocabulary where language_id = any(v_ids)),
        (select count(1) from ct_exercises e join ct_units u on u.id = e.unit_id
           join ct_levels l on l.id = u.level_id where l.language_id = any(v_ids));

    -- 1. usuarios: quitar idioma actual
    update ta_users set current_lang = null where current_lang = any(v_ids);
    get diagnostics v_count = row_count;
    raise notice 'usuarios sin idioma: %', v_count;

    -- 2. estadísticas por idioma (fk sin cascada)
    delete from ta_user_stats where language_id = any(v_ids);

    -- 3. logros ganados en esos idiomas
    delete from ta_user_achievements where language_tag = any(v_codes);

    -- 4a. logros exclusivos de esos idiomas → se borran
    delete from ct_achievements a
     where a.language_tag ~ '^\s*\['
       and jsonb_array_length(a.language_tag::jsonb) > 0
       and not exists (select 1 from jsonb_array_elements_text(a.language_tag::jsonb) t(tag)
                        where t.tag <> all(v_codes));

    -- 4b. logros compartidos → solo se quita la etiqueta
    update ct_achievements a
       set language_tag = (select jsonb_agg(t.tag)::text
                             from jsonb_array_elements_text(a.language_tag::jsonb) t(tag)
                            where t.tag <> all(v_codes))
     where a.language_tag ~ '^\s*\['
       and a.language_tag::jsonb ?| v_codes;

    -- 5. idiomas (cascada: niveles, unidades, lecciones, ejercicios, vocabulario,
    --    rl_unit_vocab, sistemas de escritura, progreso, historial)
    delete from ct_languages where id = any(v_ids);
    get diagnostics v_count = row_count;
    raise notice 'idiomas borrados: %', v_count;
end $$;

-- idiomas que quedan
select id, code, lang_name from ct_languages order by id;
