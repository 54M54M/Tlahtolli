-- ============================================================
--  11. restablecer contraseña ("olvidé mi contraseña")
--
--  ta_email_tokens ahora guarda también enlaces con purpose = 'reset'.
--  si la tabla tiene un check sobre purpose, se reemplaza por uno que lo acepte.
--  re-ejecutable.
-- ============================================================

do $$
declare
    c record;
begin
    for c in
        select conname
          from pg_constraint
         where conrelid = 'ta_email_tokens'::regclass
           and contype = 'c'
           and pg_get_constraintdef(oid) ilike '%purpose%'
    loop
        execute format('alter table ta_email_tokens drop constraint %I', c.conname);
    end loop;
end $$;

alter table ta_email_tokens
    add constraint chk_email_tokens_purpose check (purpose in ('verify', 'change', 'reset'));

-- índice para el límite de envíos por cuenta y propósito
create index if not exists idx_email_tokens_user_purpose
    on ta_email_tokens (user_id, purpose, created_at);

-- verificación
select purpose, count(1) as tokens from ta_email_tokens group by purpose;
