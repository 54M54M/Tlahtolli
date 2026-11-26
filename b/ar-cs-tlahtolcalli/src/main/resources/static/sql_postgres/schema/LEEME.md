# Scripts SQL (PostgreSQL / Neon)

## Base nueva

| Orden | Script | Qué hace |
|---|---|---|
| 1 | `1.-esquema.sql` | Todas las tablas, llaves e índices |
| 2 | `2.-datos_generales.sql` | Usuario demo (`tetecuhtli` / `demo1234`), su energía y los logros |
| 3 | `3.-curso_nhn.sql` | Curso de náhuatl central, con sistema de escritura y desglose de palabras |
| 4 | `4.-curso_hus.sql` | Curso de tének, con sistema de escritura |
| — | `pruebas/curso_yua.sql`, `pruebas/curso_zai.sql` | Cursos en pruebas (`status = 'draft'`), opcionales |

Todos se pueden volver a ejecutar: el esquema solo crea lo que falta y cada curso borra y vuelve a cargar lo suyo.

## Mantenimiento

| Script | Cuándo |
|---|---|
| `mantenimiento/recalcular_progreso.sql` | Racha, días estudiados, nivel o unidad actual se ven mal |
| `mantenimiento/publicar_curso.sql` | Publicar un curso o dar rol `tester` |
| `mantenimiento/borrar_curso.sql` | Quitar un idioma completo |
| `mantenimiento/reiniciar_bd.sql` | Borrar todo y empezar de cero |

## Cambios de estructura a partir de ahora

Un cambio nuevo se escribe **en `1.-esquema.sql`** (en el `create table`, y si la base ya existe,
también como `alter table ... add column if not exists` al final del archivo), no en un script numerado aparte.
