-- ============================================================
-- ORDEN DE EJECUCION
-- 1. Tlahtolli_Database_Script.sql
-- 2. General_Seed_Data.sql  ← usuarios demo + logros
-- 3. Nahuatl_Seed_Data.sql
-- 4. Teenek_Seed_Data.sql
-- ============================================================

-- ─────────────────────────────────────────────
--  DROP (orden inverso a las FK)
-- ─────────────────────────────────────────────
DROP TABLE IF EXISTS LESSON_HISTORY     CASCADE;
DROP TABLE IF EXISTS USER_ACHIEVEMENTS  CASCADE;
DROP TABLE IF EXISTS USER_ENERGY        CASCADE;
DROP TABLE IF EXISTS USER_PROGRESS      CASCADE;
DROP TABLE IF EXISTS UNIT_VOCAB         CASCADE;
DROP TABLE IF EXISTS EXERCISES          CASCADE;
DROP TABLE IF EXISTS WRITING_SYSTEMS    CASCADE;
DROP TABLE IF EXISTS VOCABULARY         CASCADE;
DROP TABLE IF EXISTS UNITS              CASCADE;
DROP TABLE IF EXISTS LEVELS             CASCADE;
DROP TABLE IF EXISTS USER_STATS         CASCADE;
DROP TABLE IF EXISTS USERS              CASCADE;
DROP TABLE IF EXISTS LANGUAGES          CASCADE;
DROP TABLE IF EXISTS ACHIEVEMENTS       CASCADE;
DROP TABLE IF EXISTS LESSONS            CASCADE;

-- ============================================================
--  1. LANGUAGES
-- ============================================================
CREATE TABLE LANGUAGES (
    ID              SERIAL          NOT NULL,
    CODE            VARCHAR(10)     NOT NULL,
    LANG_NAME       VARCHAR(100)    NOT NULL,
    NATIVE_NAME     VARCHAR(100),
    COLOR           VARCHAR(20),
    FLAG            VARCHAR(10),
    FAMILY          VARCHAR(100),
    WRITING_SYSTEM  VARCHAR(20),
    CONSTRAINT PK_LANGUAGES         PRIMARY KEY (ID),
    CONSTRAINT UQ_LANGUAGES_CODE    UNIQUE (CODE),
    CONSTRAINT CHK_LANGUAGES_WS     CHECK (WRITING_SYSTEM IN ('syllabary','alphabet','logogram','abugida'))
);

-- ============================================================
--  2. USERS
-- ============================================================
CREATE TABLE USERS (
    ID              SERIAL          NOT NULL,
    USERNAME        VARCHAR(50)     NOT NULL,
    FULL_NAME       VARCHAR(100)    NOT NULL,
    EMAIL           VARCHAR(150)    NOT NULL,
    USER_LEVEL      SMALLINT        DEFAULT 1,
    XP              INTEGER         DEFAULT 0,
    TOTAL_XP        INTEGER         DEFAULT 0,
    STREAK          SMALLINT        DEFAULT 0,
    JOIN_DATE       DATE            DEFAULT CURRENT_DATE,
    CURRENT_LANG    INTEGER,
    CONSTRAINT PK_USERS             PRIMARY KEY (ID),
    CONSTRAINT UQ_USERS_USERNAME    UNIQUE (USERNAME),
    CONSTRAINT UQ_USERS_EMAIL       UNIQUE (EMAIL),
    CONSTRAINT FK_USERS_LANG        FOREIGN KEY (CURRENT_LANG) REFERENCES LANGUAGES(ID)
);

-- ============================================================
--  3. USER_STATS
-- ============================================================
CREATE TABLE USER_STATS (
    ID              SERIAL      NOT NULL,
    USER_ID         INTEGER     NOT NULL,
    LANGUAGE_ID     INTEGER     NOT NULL,
    WORDS_LEARNED   INTEGER     DEFAULT 0,
    LESSONS_DONE    INTEGER     DEFAULT 0,
    PERFECT_LESS    INTEGER     DEFAULT 0,
    DAYS_STUDIED    INTEGER     DEFAULT 0,
    BEST_STREAK     SMALLINT    DEFAULT 0,
    TOTAL_MINS      INTEGER     DEFAULT 0,
    CONSTRAINT PK_USER_STATS        PRIMARY KEY (ID),
    CONSTRAINT UQ_USER_STATS        UNIQUE (USER_ID, LANGUAGE_ID),
    CONSTRAINT FK_USER_STATS_USER   FOREIGN KEY (USER_ID)      REFERENCES USERS(ID)     ON DELETE CASCADE,
    CONSTRAINT FK_USER_STATS_LANG   FOREIGN KEY (LANGUAGE_ID)  REFERENCES LANGUAGES(ID)
);

-- ============================================================
--  4. LEVELS
-- ============================================================
CREATE TABLE LEVELS (
    ID              SERIAL          NOT NULL,
    LANGUAGE_ID     INTEGER         NOT NULL,
    LEVEL_NUM       SMALLINT        NOT NULL,
    TITLE           VARCHAR(200)    NOT NULL,
    TITLE_NATIVE    VARCHAR(200),
    COLOR           VARCHAR(20),
    TOTAL_UNITS     SMALLINT        DEFAULT 0,
    UNLOCK_REQ      VARCHAR(500),
    IS_FREE         SMALLINT        DEFAULT 0,
    CONSTRAINT PK_LEVELS            PRIMARY KEY (ID),
    CONSTRAINT UQ_LEVELS_NUM        UNIQUE (LANGUAGE_ID, LEVEL_NUM),
    CONSTRAINT FK_LEVELS_LANG       FOREIGN KEY (LANGUAGE_ID)  REFERENCES LANGUAGES(ID) ON DELETE CASCADE,
    CONSTRAINT CHK_LEVELS_IS_FREE   CHECK (IS_FREE IN (0, 1))
);

-- ============================================================
--  5. UNITS
-- ============================================================
CREATE TABLE UNITS (
    ID          SERIAL          NOT NULL,
    LEVEL_ID    INTEGER         NOT NULL,
    UNIT_NUM    SMALLINT        NOT NULL,
    TITLE       VARCHAR(200)    NOT NULL,
    COLOR       VARCHAR(20),
    OBJECTIVE   VARCHAR(500),
    GRAMMAR     VARCHAR(500),
    IS_FREE     SMALLINT        DEFAULT 0,
    UNLOCK_REQ  VARCHAR(500),
    CONSTRAINT PK_UNITS             PRIMARY KEY (ID),
    CONSTRAINT UQ_UNITS_NUM         UNIQUE (LEVEL_ID, UNIT_NUM),
    CONSTRAINT FK_UNITS_LEVEL       FOREIGN KEY (LEVEL_ID)  REFERENCES LEVELS(ID) ON DELETE CASCADE,
    CONSTRAINT CHK_UNITS_IS_FREE    CHECK (IS_FREE IN (0, 1))
);

-- ============================================================
--  6. LESSONS
-- ============================================================
CREATE TABLE LESSONS (
    ID          SERIAL          NOT NULL,
    UNIT_ID     INTEGER         NOT NULL,
    LESSON_NUM  SMALLINT        NOT NULL,
    TITLE       VARCHAR(200)    NOT NULL,
    DESCRIPTION VARCHAR(1000),
    IS_FREE     SMALLINT        DEFAULT 0,
    XP_REWARD   INTEGER         DEFAULT 10,
    CONSTRAINT PK_LESSONS           PRIMARY KEY (ID),
    CONSTRAINT UQ_LESSONS_NUM       UNIQUE (UNIT_ID, LESSON_NUM),
    CONSTRAINT FK_LESSONS_UNIT      FOREIGN KEY (UNIT_ID) REFERENCES UNITS(ID) ON DELETE CASCADE,
    CONSTRAINT CHK_LESSONS_IS_FREE  CHECK (IS_FREE IN (0, 1))
);

-- ============================================================
--  7. EXERCISES
-- ============================================================
CREATE TABLE EXERCISES (
    ID              SERIAL          NOT NULL,
    UNIT_ID         INTEGER,
    LESSON_ID       INTEGER,
    EXERCISE_TYPE   VARCHAR(50)     NOT NULL,
    QUESTION        VARCHAR(2000),
    ANSWER          VARCHAR(2000),
    CORRECT_ANS     TEXT,
    OPTIONS         TEXT,
    CHARACTER_REF   VARCHAR(100),
    EXPLANATION     VARCHAR(2000),
    POINTS          SMALLINT        DEFAULT 10,
    DIFFICULTY      VARCHAR(20),
    CONSTRAINT PK_EXERCISES         PRIMARY KEY (ID),
    CONSTRAINT FK_EXERCISES_UNIT    FOREIGN KEY (UNIT_ID)   REFERENCES UNITS(ID)   ON DELETE CASCADE,
    CONSTRAINT FK_EXERCISES_LESSON  FOREIGN KEY (LESSON_ID) REFERENCES LESSONS(ID) ON DELETE CASCADE
);

-- ============================================================
--  8. WRITING_SYSTEMS
-- ============================================================
CREATE TABLE WRITING_SYSTEMS (
    ID              SERIAL          NOT NULL,
    LANGUAGE_ID     INTEGER         NOT NULL,
    SYSTEM_TYPE     VARCHAR(30)     NOT NULL,
    SYSTEM_NAME     VARCHAR(200),
    DESCRIPTION     VARCHAR(1000),
    CHARACTERS      TEXT,
    RULES           TEXT,
    NOTES           TEXT,
    SYLLABARY_DATA  TEXT,
    CHARACTERS_JSON TEXT,
    RULES_JSON      TEXT,
    CONSTRAINT PK_WRITING_SYSTEMS       PRIMARY KEY (ID),
    CONSTRAINT FK_WRITING_SYS_LANG      FOREIGN KEY (LANGUAGE_ID) REFERENCES LANGUAGES(ID) ON DELETE CASCADE,
    CONSTRAINT CHK_WRITING_SYS_TYPE     CHECK (SYSTEM_TYPE IN ('syllabary','alphabet','logogram','abugida'))
);

-- ============================================================
--  9. USER_PROGRESS
-- ============================================================
CREATE TABLE USER_PROGRESS (
    ID              SERIAL      NOT NULL,
    USER_ID         INTEGER     NOT NULL,
    UNIT_ID         INTEGER     NOT NULL,
    COMPLETED       SMALLINT    DEFAULT 0,
    IS_CURRENT      SMALLINT    DEFAULT 0,
    IS_LOCKED       SMALLINT    DEFAULT 1,
    COMPLETED_AT    DATE,
    CONSTRAINT PK_USER_PROGRESS         PRIMARY KEY (ID),
    CONSTRAINT UQ_USER_PROGRESS         UNIQUE (USER_ID, UNIT_ID),
    CONSTRAINT FK_USER_PROGRESS_USER    FOREIGN KEY (USER_ID) REFERENCES USERS(ID) ON DELETE CASCADE,
    CONSTRAINT FK_USER_PROGRESS_UNIT    FOREIGN KEY (UNIT_ID) REFERENCES UNITS(ID) ON DELETE CASCADE,
    CONSTRAINT CHK_UP_COMPLETED         CHECK (COMPLETED  IN (0, 1)),
    CONSTRAINT CHK_UP_IS_CURRENT        CHECK (IS_CURRENT IN (0, 1)),
    CONSTRAINT CHK_UP_IS_LOCKED         CHECK (IS_LOCKED  IN (0, 1))
);

-- ============================================================
--  10. VOCABULARY
-- ============================================================
CREATE TABLE VOCABULARY (
    ID              SERIAL          NOT NULL,
    LANGUAGE_ID     INTEGER         NOT NULL,
    WORD            VARCHAR(500)    NOT NULL,
    TRANSLATION     VARCHAR(500),
    PRONUNCIATION   VARCHAR(500),
    EXAMPLE         VARCHAR(1000),
    CONSTRAINT PK_VOCABULARY        PRIMARY KEY (ID),
    CONSTRAINT FK_VOCABULARY_LANG   FOREIGN KEY (LANGUAGE_ID) REFERENCES LANGUAGES(ID) ON DELETE CASCADE
);

-- ============================================================
--  11. UNIT_VOCAB  (tabla pivot)
-- ============================================================
CREATE TABLE UNIT_VOCAB (
    ID          SERIAL  NOT NULL,
    UNIT_ID     INTEGER NOT NULL,
    VOCAB_ID    INTEGER NOT NULL,
    CONSTRAINT PK_UNIT_VOCAB        PRIMARY KEY (ID),
    CONSTRAINT UQ_UNIT_VOCAB        UNIQUE (UNIT_ID, VOCAB_ID),
    CONSTRAINT FK_UNIT_VOCAB_UNIT   FOREIGN KEY (UNIT_ID)  REFERENCES UNITS(ID)      ON DELETE CASCADE,
    CONSTRAINT FK_UNIT_VOCAB_VOCAB  FOREIGN KEY (VOCAB_ID) REFERENCES VOCABULARY(ID) ON DELETE CASCADE
);

-- ============================================================
--  12. ACHIEVEMENTS
-- ============================================================
CREATE TABLE ACHIEVEMENTS (
    ID              SERIAL          NOT NULL,
    TITLE           VARCHAR(200)    NOT NULL,
    DESCRIPTION     VARCHAR(1000),
    ICON            VARCHAR(200),
    XP_REWARD       INTEGER         DEFAULT 0,
    REQUIREMENT     VARCHAR(500),
    CATEGORY        VARCHAR(100),
    RARITY          VARCHAR(50),
    CONSTRAINT PK_ACHIEVEMENTS PRIMARY KEY (ID)
);

-- ============================================================
--  13. USER_ACHIEVEMENTS
-- ============================================================
CREATE TABLE USER_ACHIEVEMENTS (
    ID          SERIAL  NOT NULL,
    USER_ID     INTEGER NOT NULL,
    ACHIEVE_ID  INTEGER NOT NULL,
    EARNED_AT   DATE    DEFAULT CURRENT_DATE,
    PROGRESS    TEXT,
    CONSTRAINT PK_USER_ACHIEVEMENTS     PRIMARY KEY (ID),
    CONSTRAINT UQ_USER_ACHIEVEMENTS     UNIQUE (USER_ID, ACHIEVE_ID),
    CONSTRAINT FK_USER_ACHIEV_USER      FOREIGN KEY (USER_ID)    REFERENCES USERS(ID)        ON DELETE CASCADE,
    CONSTRAINT FK_USER_ACHIEV_ACHIEVE   FOREIGN KEY (ACHIEVE_ID) REFERENCES ACHIEVEMENTS(ID) ON DELETE CASCADE
);

-- ============================================================
--  14. USER_ENERGY
-- ============================================================
CREATE TABLE USER_ENERGY (
    ID              SERIAL      NOT NULL,
    USER_ID         INTEGER     NOT NULL,
    MAX_ENERGY      SMALLINT    DEFAULT 15,
    CURRENT_ENRG    SMALLINT    DEFAULT 15,
    STREAK_COUNT    SMALLINT    DEFAULT 0,
    LAST_UPDATE     TIMESTAMPTZ DEFAULT NOW(),
    DAILY_USAGE     SMALLINT    DEFAULT 0,
    CONSTRAINT PK_USER_ENERGY           PRIMARY KEY (ID),
    CONSTRAINT UQ_USER_ENERGY_USER      UNIQUE (USER_ID),
    CONSTRAINT FK_USER_ENERGY_USER      FOREIGN KEY (USER_ID) REFERENCES USERS(ID) ON DELETE CASCADE,
    CONSTRAINT CHK_USER_ENERGY_RANGE    CHECK (CURRENT_ENRG >= 0 AND CURRENT_ENRG <= MAX_ENERGY)
);

-- ============================================================
--  15. LESSON_HISTORY
-- ============================================================
CREATE TABLE LESSON_HISTORY (
    ID              SERIAL          NOT NULL,
    USER_ID         INTEGER         NOT NULL,
    UNIT_ID         INTEGER         NOT NULL,
    LESSON_ID       INTEGER,
    COMPLETED_AT    DATE            DEFAULT CURRENT_DATE,
    PERFORMANCE     NUMERIC(4,2),
    TIME_SECONDS    INTEGER,
    EARNED_EXP      INTEGER         DEFAULT 0,
    CORRECT_ANS     SMALLINT        DEFAULT 0,
    TOTAL_EXERC     SMALLINT        DEFAULT 0,
    WAS_PERFECT     SMALLINT        DEFAULT 0,
    CONSTRAINT PK_LESSON_HISTORY        PRIMARY KEY (ID),
    CONSTRAINT FK_LESSON_HIST_USER      FOREIGN KEY (USER_ID)   REFERENCES USERS(ID)    ON DELETE CASCADE,
    CONSTRAINT FK_LESSON_HIST_UNIT      FOREIGN KEY (UNIT_ID)   REFERENCES UNITS(ID)    ON DELETE CASCADE,
    CONSTRAINT FK_LESSON_HIST_LESSON    FOREIGN KEY (LESSON_ID) REFERENCES LESSONS(ID)  ON DELETE CASCADE,
    CONSTRAINT CHK_LH_PERFORMANCE       CHECK (PERFORMANCE >= 0 AND PERFORMANCE <= 1),
    CONSTRAINT CHK_LH_WAS_PERFECT       CHECK (WAS_PERFECT IN (0, 1))
);

-- ============================================================
--  ÍNDICES
-- ============================================================
CREATE INDEX IDX_USERS_CURRENT_LANG    ON USERS(CURRENT_LANG);
CREATE INDEX IDX_USER_STATS_USER       ON USER_STATS(USER_ID);
CREATE INDEX IDX_USER_STATS_LANG       ON USER_STATS(LANGUAGE_ID);
CREATE INDEX IDX_LEVELS_LANG           ON LEVELS(LANGUAGE_ID);
CREATE INDEX IDX_UNITS_LEVEL           ON UNITS(LEVEL_ID);
CREATE INDEX IDX_EXERCISES_UNIT        ON EXERCISES(UNIT_ID);
CREATE INDEX IDX_WRITING_SYS_LANG      ON WRITING_SYSTEMS(LANGUAGE_ID);
CREATE INDEX IDX_USER_PROGRESS_USER    ON USER_PROGRESS(USER_ID);
CREATE INDEX IDX_USER_PROGRESS_UNIT    ON USER_PROGRESS(UNIT_ID);
CREATE INDEX IDX_VOCABULARY_LANG       ON VOCABULARY(LANGUAGE_ID);
CREATE INDEX IDX_UNIT_VOCAB_UNIT       ON UNIT_VOCAB(UNIT_ID);
CREATE INDEX IDX_UNIT_VOCAB_VOCAB      ON UNIT_VOCAB(VOCAB_ID);
CREATE INDEX IDX_USER_ACHIEV_USER      ON USER_ACHIEVEMENTS(USER_ID);
CREATE INDEX IDX_USER_ACHIEV_ACHIEVE   ON USER_ACHIEVEMENTS(ACHIEVE_ID);
CREATE INDEX IDX_LESSON_HIST_USER      ON LESSON_HISTORY(USER_ID);
CREATE INDEX IDX_LESSON_HIST_UNIT      ON LESSON_HISTORY(UNIT_ID);
CREATE INDEX IDX_LESSON_HIST_DATE      ON LESSON_HISTORY(COMPLETED_AT);
CREATE INDEX IDX_LESSONS_UNIT          ON LESSONS(UNIT_ID);

-- ============================================================
--  VISTA: estado de acceso por unidad
-- ============================================================
CREATE OR REPLACE VIEW V_UNIT_ACCESS AS
SELECT
    UP.USER_ID,
    U.ID            AS UNIT_ID,
    U.UNIT_NUM,
    U.LEVEL_ID,
    U.IS_FREE,
    UP.COMPLETED,
    UP.IS_LOCKED,
    CASE
        WHEN U.UNIT_NUM = 1 THEN 'UNLOCKED'
        WHEN EXISTS (
            SELECT 1
            FROM   USER_PROGRESS UP2
            JOIN   UNITS U2 ON UP2.UNIT_ID = U2.ID
            WHERE  UP2.USER_ID   = UP.USER_ID
            AND    U2.LEVEL_ID   = U.LEVEL_ID
            AND    U2.UNIT_NUM   = U.UNIT_NUM - 1
            AND    UP2.COMPLETED = 1
        ) THEN 'UNLOCKED'
        ELSE 'LOCKED'
    END AS ACCESS_STATUS
FROM UNITS U
JOIN USER_PROGRESS UP ON UP.UNIT_ID = U.ID;

-- ============================================================
--  FIN DEL SCRIPT
-- ============================================================

SELECT * FROM users;
