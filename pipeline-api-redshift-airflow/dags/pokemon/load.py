"""Carga y control de calidad en Redshift.

La conexión se toma de Airflow (conn_id `redshift_pokemon`), que a su vez se define con la
variable de entorno AIRFLOW_CONN_REDSHIFT_POKEMON del archivo .env. Nada de credenciales en el código.
"""
from __future__ import annotations

from airflow.providers.postgres.hooks.postgres import PostgresHook

CONN_ID = "redshift_pokemon"
COLUMNS = [
    "pokemon_id", "nombre", "altura_dm", "peso_hg", "tipos", "experiencia_base",
    "hp", "ataque", "defensa", "ataque_especial", "defensa_especial", "velocidad",
]


def load_rows(rows: list[dict]) -> int:
    """Carga idempotente: borra y reinserta en una sola transacción.

    Si el DAG corre dos veces el mismo día, la tabla no queda duplicada.
    """
    hook = PostgresHook(postgres_conn_id=CONN_ID)
    placeholders = ", ".join(["%s"] * len(COLUMNS))
    insert_sql = f"INSERT INTO pokemon ({', '.join(COLUMNS)}) VALUES ({placeholders})"
    values = [tuple(row[c] for c in COLUMNS) for row in rows]

    with hook.get_conn() as conn, conn.cursor() as cur:
        cur.execute("DELETE FROM pokemon")
        cur.executemany(insert_sql, values)
        conn.commit()
    return len(values)


def check_quality(expected_rows: int) -> None:
    """Controles mínimos de calidad post-carga. Si alguno falla, la tarea falla."""
    hook = PostgresHook(postgres_conn_id=CONN_ID)
    checks = {
        "cantidad de filas": ("SELECT COUNT(*) FROM pokemon", expected_rows),
        "ids duplicados": ("SELECT COUNT(*) - COUNT(DISTINCT pokemon_id) FROM pokemon", 0),
        "nombres nulos": ("SELECT COUNT(*) FROM pokemon WHERE nombre IS NULL", 0),
        "stats fuera de rango": ("SELECT COUNT(*) FROM pokemon WHERE hp <= 0 OR velocidad <= 0", 0),
    }
    failures = []
    for name, (sql, expected) in checks.items():
        actual = hook.get_first(sql)[0]
        if actual != expected:
            failures.append(f"{name}: esperado {expected}, obtenido {actual}")
    if failures:
        raise ValueError("Falló el control de calidad -> " + "; ".join(failures))
