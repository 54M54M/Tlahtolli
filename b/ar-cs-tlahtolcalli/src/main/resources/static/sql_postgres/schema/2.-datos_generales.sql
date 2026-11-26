-- ============================================================
--  2. datos generales — tlahtolcalli  [postgresql]
--
--  usuario demo (contraseña demo1234), su energía y los logros globales.
--  ejecutar después de 1.-esquema.sql y antes de los cursos (los cursos le abren la primera
--  unidad al usuario demo). reemplaza a los scripts 2 y 3.
--
--  re-ejecutable: no duplica ni pisa lo que ya existe.
-- ============================================================

begin;

-- usuario demo · hash bcrypt (strength 10) de 'demo1234'
insert into ta_users (username, full_name, email, password_hash, email_verified, email_verified_at)
values ('tetecuhtli', 'UserDemo', 'demo@tlahtolli.mx',
        '$2a$10$LS0y45bwfjhU/YXkI6Txou8q6G2KQbljINC0u.W4CGU9jRjod9ksa', true, now())
on conflict (username) do nothing;

insert into ta_user_energy (user_id, max_energy, current_enrg, streak_count, last_update, daily_usage)
select id, 15, 15, 0, now(), 0 from ta_users where username = 'tetecuhtli'
on conflict (user_id) do nothing;

-- logros globales (language_tag null = todos los idiomas)
insert into ct_achievements (title, description, icon, xp_reward, requirement, category, rarity, language_tag)
select x.title, x.description, x.icon, x.xp_reward, x.requirement, x.category, x.rarity, null
  from (values
        ('Primer Día',              'Completaste tu primera lección',          '🎉',  50, 'completar 1 lección',       'general',     'common'),
        ('Racha de 7 días',         'Estudiaste durante 7 días consecutivos',  '🔥', 100, 'mantener racha de 7 días',  'dedication',  'rare'),
        ('Vocabulario Básico',      'Aprendiste 50 palabras nuevas',           '📚', 150, 'aprender 50 palabras',      'vocabulary',  'common'),
        ('Racha de 30 días',        'Estudiaste durante 30 días consecutivos', '⚡', 300, 'mantener racha de 30 días', 'dedication',  'epic'),
        ('Perfeccionista',          'Completaste 10 lecciones perfectas',      '⭐', 200, '10 lecciones perfectas',    'performance', 'rare'),
        ('Estudiante Comprometido', 'Estudiaste 1000 minutos',                 '⏰', 150, '1000 minutos de estudio',   'dedication',  'common')
       ) as x(title, description, icon, xp_reward, requirement, category, rarity)
 where not exists (select 1 from ct_achievements a where a.title = x.title);

commit;

-- verificación
select 'ta_users' as tabla, count(1) as registros from ta_users
union all select 'ta_user_energy', count(1) from ta_user_energy
union all select 'ct_achievements', count(1) from ct_achievements;
