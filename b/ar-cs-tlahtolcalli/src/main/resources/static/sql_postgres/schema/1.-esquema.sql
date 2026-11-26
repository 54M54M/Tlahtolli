-- ============================================================
--  1. esquema — tlahtolcalli  [postgresql]
--
--  estructura completa de la base (tablas, llaves, índices), tal como está hoy en neon.
--  reemplaza a los scripts de migración 1, 3, 8, 11, 12, 13, 14 y 16 (todos ya están aquí).
--
--  orden para una base nueva:
--    1.-esquema.sql            ← este archivo
--    2.-datos_generales.sql    usuario demo, energía, logros
--    3.-curso_nhn.sql          náhuatl central
--    4.-curso_hus.sql          tének
--    (opcional) pruebas/*.sql  cursos en pruebas (status = 'draft')
--
--  re-ejecutable: solo crea lo que no existe; no borra ni cambia datos.
-- ============================================================

-- ─────────────────────────────────────────────
--  catálogo (ct_*) y relaciones (rl_*)
-- ─────────────────────────────────────────────

create table if not exists ct_languages (
    id              serial,
    code            varchar(10)   not null,
    lang_name       varchar(100)  not null,
    native_name     varchar(100),
    color           varchar(20),
    flag            varchar(10),
    family          varchar(100),
    writing_system  varchar(20),
    status          varchar(20)   not null default 'published',   -- draft: solo front de desarrollo (tester/admin)
    constraint pk_languages        primary key (id),
    constraint uq_languages_code   unique (code),
    constraint chk_languages_ws    check (writing_system in ('syllabary', 'alphabet', 'logogram', 'abugida')),
    constraint chk_languages_status check (status in ('draft', 'published'))
);

create table if not exists ct_levels (
    id            serial,
    language_id   integer       not null,
    level_num     smallint      not null,
    title         varchar(200)  not null,
    title_native  varchar(200),
    color         varchar(20),
    total_units   smallint      default 0,
    unlock_req    varchar(500),
    is_free       smallint      default 0,
    constraint pk_levels          primary key (id),
    constraint uq_levels_num      unique (language_id, level_num),
    constraint chk_levels_is_free check (is_free in (0, 1)),
    constraint fk_levels_lang     foreign key (language_id) references ct_languages (id) on delete cascade
);

create table if not exists ct_units (
    id          serial,
    level_id    integer       not null,
    unit_num    smallint      not null,
    title       varchar(200)  not null,
    color       varchar(20),
    objective   varchar(500),
    grammar     varchar(500),
    is_free     smallint      default 0,
    unlock_req  varchar(500),
    constraint pk_units          primary key (id),
    constraint uq_units_num      unique (level_id, unit_num),
    constraint chk_units_is_free check (is_free in (0, 1)),
    constraint fk_units_level    foreign key (level_id) references ct_levels (id) on delete cascade
);

create table if not exists ct_lessons (
    id          serial,
    unit_id     integer       not null,
    lesson_num  smallint      not null,
    title       varchar(200)  not null,
    description varchar(1000),
    is_free     smallint      default 0,
    xp_reward   integer       default 10,
    constraint pk_lessons          primary key (id),
    constraint uq_lessons_num      unique (unit_id, lesson_num),
    constraint chk_lessons_is_free check (is_free in (0, 1)),
    constraint fk_lessons_unit     foreign key (unit_id) references ct_units (id) on delete cascade
);

create table if not exists ct_vocabulary (
    id             serial,
    language_id    integer       not null,
    word           varchar(500)  not null,
    translation    varchar(500),
    pronunciation  varchar(500),
    example        varchar(1000),
    breakdown      varchar(1000),   -- desglose para la pista: 'no- = mi; tōka = nombre'
    constraint pk_vocabulary      primary key (id),
    constraint fk_vocabulary_lang foreign key (language_id) references ct_languages (id) on delete cascade
);

create table if not exists rl_unit_vocab (
    id        serial,
    unit_id   integer  not null,
    vocab_id  integer  not null,
    constraint pk_unit_vocab        primary key (id),
    constraint uq_unit_vocab        unique (unit_id, vocab_id),
    constraint fk_unit_vocab_unit   foreign key (unit_id)  references ct_units (id)      on delete cascade,
    constraint fk_unit_vocab_vocab  foreign key (vocab_id) references ct_vocabulary (id) on delete cascade
);

create table if not exists ct_exercises (
    id             serial,
    unit_id        integer,
    lesson_id      integer,
    exercise_type  varchar(50)   not null,
    question       varchar(2000),
    answer         varchar(2000),
    correct_ans    text,
    options        text,
    character_ref  varchar(100),
    explanation    varchar(2000),
    points         smallint      default 10,
    difficulty     varchar(20),
    placeholder    varchar(255),
    constraint pk_exercises        primary key (id),
    constraint fk_exercises_unit   foreign key (unit_id)   references ct_units (id)   on delete cascade,
    constraint fk_exercises_lesson foreign key (lesson_id) references ct_lessons (id) on delete cascade
);

create table if not exists ct_writing_systems (
    id           serial,
    language_id  integer       not null,
    system_type  varchar(30)   not null,
    system_name  varchar(200),
    description  varchar(1000),
    characters   text,          -- json: type, letter, pronunciation, syllables, example
    rules        text,
    notes        text,
    constraint pk_writing_systems   primary key (id),
    constraint chk_writing_sys_type check (system_type in ('syllabary', 'alphabet', 'logogram', 'abugida')),
    constraint fk_writing_sys_lang  foreign key (language_id) references ct_languages (id) on delete cascade
);

create table if not exists ct_achievements (
    id            serial,
    title         varchar(200)  not null,
    description   varchar(1000),
    icon          varchar(200),
    xp_reward     integer       default 0,
    requirement   varchar(500),
    category      varchar(100),
    rarity        varchar(50),
    language_tag  text,          -- null = global; '["nhn","hus"]' = solo esos idiomas
    constraint pk_achievements primary key (id)
);

-- ─────────────────────────────────────────────
--  usuarios y su actividad (ta_*)
-- ─────────────────────────────────────────────

create table if not exists ta_users (
    id                   serial,
    username             varchar(50)   not null,
    full_name            varchar(100)  not null,
    email                varchar(150)  not null,
    user_level           smallint      default 1,
    xp                   integer       default 0,
    total_xp             integer       default 0,
    streak               smallint      default 0,            -- racha actual (días seguidos, cualquier idioma)
    join_date            date          default current_date,
    current_lang         integer,
    password_hash        varchar(255),                       -- null en cuentas solo con google
    role                 varchar(20)   not null default 'user',
    email_verified       boolean       not null default false,
    email_verified_at    timestamp,
    pending_email        varchar(150),
    username_changed_at  timestamp,
    google_sub           varchar(255),
    must_pick_username   boolean       not null default false,
    last_study_date      date,
    token_version        integer       not null default 0,   -- sube al restablecer contraseña: cierra sesiones
    constraint pk_users             primary key (id),
    constraint uq_users_username    unique (username),
    constraint uq_users_email       unique (email),
    constraint uq_users_google_sub  unique (google_sub),
    constraint chk_users_role       check (role in ('user', 'tester', 'admin')),
    constraint fk_users_lang        foreign key (current_lang) references ct_languages (id)
);

create table if not exists ta_user_stats (
    id             serial,
    user_id        integer   not null,
    language_id    integer   not null,
    words_learned  integer   default 0,
    lessons_done   integer   default 0,   -- unidades distintas terminadas
    perfect_less   integer   default 0,   -- terminadas la primera vez con 90 % o más
    days_studied   integer   default 0,   -- días distintos (ta_study_days)
    best_streak    smallint  default 0,
    total_mins     integer   default 0,
    constraint pk_user_stats      primary key (id),
    constraint uq_user_stats      unique (user_id, language_id),
    constraint fk_user_stats_user foreign key (user_id)     references ta_users (id) on delete cascade,
    constraint fk_user_stats_lang foreign key (language_id) references ct_languages (id)
);

create table if not exists ta_user_energy (
    id            serial,
    user_id       integer      not null,
    max_energy    smallint     default 15,
    current_enrg  smallint     default 15,
    streak_count  smallint     default 0,
    last_update   timestamptz  default now(),
    daily_usage   smallint     default 0,
    constraint pk_user_energy        primary key (id),
    constraint uq_user_energy_user   unique (user_id),
    constraint chk_user_energy_range check (current_enrg >= 0 and current_enrg <= max_energy),
    constraint fk_user_energy_user   foreign key (user_id) references ta_users (id) on delete cascade
);

create table if not exists ta_user_progress (
    id            serial,
    user_id       integer   not null,
    unit_id       integer   not null,
    completed     smallint  default 0,
    is_current    smallint  default 0,
    is_locked     smallint  default 1,
    completed_at  date,
    constraint pk_user_progress      primary key (id),
    constraint uq_user_progress      unique (user_id, unit_id),
    constraint chk_up_completed      check (completed in (0, 1)),
    constraint chk_up_is_current     check (is_current in (0, 1)),
    constraint chk_up_is_locked      check (is_locked in (0, 1)),
    constraint fk_user_progress_user foreign key (user_id) references ta_users (id) on delete cascade,
    constraint fk_user_progress_unit foreign key (unit_id) references ct_units (id) on delete cascade
);

create table if not exists ta_lesson_history (
    id            serial,
    user_id       integer       not null,
    unit_id       integer       not null,
    lesson_id     integer,
    completed_at  date          default current_date,
    performance   numeric(4,2),
    time_seconds  integer,
    earned_exp    integer       default 0,
    correct_ans   smallint      default 0,
    total_exerc   smallint      default 0,
    was_perfect   smallint      default 0,
    constraint pk_lesson_history      primary key (id),
    constraint chk_lh_performance     check (performance >= 0 and performance <= 1),
    constraint chk_lh_was_perfect     check (was_perfect in (0, 1)),
    constraint fk_lesson_hist_user    foreign key (user_id)   references ta_users (id)   on delete cascade,
    constraint fk_lesson_hist_unit    foreign key (unit_id)   references ct_units (id)   on delete cascade,
    constraint fk_lesson_hist_lesson  foreign key (lesson_id) references ct_lessons (id) on delete cascade
);

create table if not exists ta_user_achievements (
    id            serial,
    user_id       integer      not null,
    achieve_id    integer      not null,
    earned_at     date         default current_date,
    progress      text,
    language_tag  varchar(10),
    constraint pk_user_achievements    primary key (id),
    constraint uq_user_achievements    unique (user_id, achieve_id, language_tag),
    constraint fk_user_achiev_user     foreign key (user_id)    references ta_users (id)        on delete cascade,
    constraint fk_user_achiev_achieve  foreign key (achieve_id) references ct_achievements (id) on delete cascade
);

-- enlaces por correo: verificar, cambiar correo, restablecer contraseña (se guarda el hash, no el token)
create table if not exists ta_email_tokens (
    id          integer       generated always as identity,
    user_id     integer       not null,
    email       varchar(150)  not null,
    token_hash  char(64)      not null,
    purpose     varchar(20)   not null,
    expires_at  timestamp     not null,
    used_at     timestamp,
    created_at  timestamp     not null default now(),
    constraint pk_email_tokens          primary key (id),
    constraint uq_email_tokens_hash     unique (token_hash),
    constraint chk_email_tokens_purpose check (purpose in ('verify', 'change', 'reset')),
    constraint fk_email_tokens_user     foreign key (user_id) references ta_users (id) on delete cascade
);

-- envíos hechos sin conexión: el id lo genera el teléfono; si llega dos veces, el segundo se ignora
create table if not exists ta_sync_ops (
    client_id   uuid         not null,
    user_id     integer      not null,
    kind        varchar(20)  not null,
    created_at  timestamp    not null default now(),
    constraint pk_sync_ops        primary key (client_id),
    constraint chk_sync_ops_kind  check (kind in ('lesson', 'quick', 'energy')),
    constraint fk_sync_ops_user   foreign key (user_id) references ta_users (id) on delete cascade
);

-- un renglón por usuario, idioma y día con al menos una lección: racha, días estudiados y mejor racha
create table if not exists ta_study_days (
    user_id      integer  not null,
    language_id  integer  not null,
    study_date   date     not null,
    constraint pk_study_days       primary key (user_id, language_id, study_date),
    constraint fk_study_days_user  foreign key (user_id)     references ta_users (id)     on delete cascade,
    constraint fk_study_days_lang  foreign key (language_id) references ct_languages (id) on delete cascade
);

-- ─────────────────────────────────────────────
--  índices
-- ─────────────────────────────────────────────
create index if not exists idx_levels_lang               on ct_levels (language_id);
create index if not exists idx_units_level               on ct_units (level_id);
create index if not exists idx_lessons_unit              on ct_lessons (unit_id);
create index if not exists idx_vocabulary_lang           on ct_vocabulary (language_id);
create index if not exists idx_unit_vocab_unit           on rl_unit_vocab (unit_id);
create index if not exists idx_unit_vocab_vocab          on rl_unit_vocab (vocab_id);
create index if not exists idx_exercises_unit            on ct_exercises (unit_id);
create index if not exists idx_writing_sys_lang          on ct_writing_systems (language_id);
create index if not exists idx_users_current_lang        on ta_users (current_lang);
create index if not exists idx_user_stats_user           on ta_user_stats (user_id);
create index if not exists idx_user_stats_lang           on ta_user_stats (language_id);
create index if not exists idx_user_progress_user        on ta_user_progress (user_id);
create index if not exists idx_user_progress_unit        on ta_user_progress (unit_id);
create index if not exists idx_lesson_hist_user          on ta_lesson_history (user_id);
create index if not exists idx_lesson_hist_unit          on ta_lesson_history (unit_id);
create index if not exists idx_lesson_hist_date          on ta_lesson_history (completed_at);
create index if not exists idx_user_achiev_user          on ta_user_achievements (user_id);
create index if not exists idx_user_achiev_achieve       on ta_user_achievements (achieve_id);
create index if not exists idx_email_tokens_user         on ta_email_tokens (user_id, created_at);
create index if not exists idx_email_tokens_user_purpose on ta_email_tokens (user_id, purpose, created_at);
create index if not exists idx_sync_ops_created          on ta_sync_ops (created_at);

-- ─────────────────────────────────────────────
--  ajustes para bases que ya existían (re-ejecutables)
--  un cambio de estructura nuevo va aquí además de en su create table
-- ─────────────────────────────────────────────

-- rol tester (cursos en pruebas): la base de neon solo aceptaba 'user' y 'admin'
alter table ta_users drop constraint if exists chk_users_role;
alter table ta_users add constraint chk_users_role check (role in ('user', 'tester', 'admin'));

-- restos que ya no usa el back (opcional; revisa que estén vacíos antes de quitarlos)
-- select count(1) from ct_writing_systems where syllabary_data is not null or characters_json is not null or rules_json is not null;
-- alter table ct_writing_systems drop column if exists syllabary_data, drop column if exists characters_json, drop column if exists rules_json;
-- drop view if exists v_unit_access;

-- verificación: deben salir 18 tablas
select count(1) as tablas from information_schema.tables where table_schema = 'public' and table_type = 'BASE TABLE';
