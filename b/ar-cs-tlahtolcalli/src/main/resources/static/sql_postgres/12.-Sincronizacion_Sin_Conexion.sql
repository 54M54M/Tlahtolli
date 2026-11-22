-- ============================================================
--  12. sincronización sin conexión
--
--  lo que el usuario hace sin internet (lecciones terminadas, energía gastada)
--  se guarda en el teléfono y se envía al reconectar. cada envío lleva un id
--  generado en el teléfono (client_id); si llega dos veces, el segundo se ignora.
--  re-ejecutable.
-- ============================================================

create table if not exists ta_sync_ops (
    client_id   uuid         primary key,
    user_id     integer      not null references ta_users (id) on delete cascade,
    kind        varchar(20)  not null,
    created_at  timestamp    not null default now(),
    constraint chk_sync_ops_kind check (kind in ('lesson', 'quick', 'energy'))
);

create index if not exists idx_sync_ops_created on ta_sync_ops (created_at);

-- verificación
select kind, count(1) as envios from ta_sync_ops group by kind;
