# Pipeline API → Redshift con Airflow y controles de calidad

> 🇬🇧 *Daily Airflow pipeline that extracts data from a public REST API, loads it idempotently into Amazon Redshift and runs post-load data quality checks. Credentials live in an Airflow connection defined through environment variables, never in code.*

## Problema
*Fuente de datos de práctica: [PokeAPI](https://pokeapi.co), una API REST pública. Lo que se evalúa es el patrón de pipeline, no el dominio.*

Automatizar una carga diaria desde una API pública hacia un data warehouse. La tabla tiene que quedar **sin duplicados aunque el proceso corra dos veces** y tiene que **avisar si la carga sale incompleta**.

## Arquitectura

```
PokeAPI ──► extract ──► load (DELETE + INSERT en una transacción) ──► quality_check
            (requests)        (PostgresHook → Redshift)              (filas, duplicados, nulos, rangos)
```

| Decisión | Por qué |
|---|---|
| **TaskFlow API** (`@dag` / `@task`) | Las dependencias y el pasaje de datos entre tareas quedan explícitos en el código. |
| **Conexión de Airflow** (`AIRFLOW_CONN_REDSHIFT_POKEMON`) | La credencial vive en `.env` y no se versiona. El código solo conoce el `conn_id`. |
| **Carga idempotente** | Re-ejecutar el DAG no duplica filas. Se usa la clave natural `pokemon_id` de la API. |
| **`quality_check` como tarea** | Si falla un control, el DAG queda en rojo en vez de dejar una tabla mala en silencio. |
| `catchup=False` y `retries=2` | Evita reprocesar meses al activar el DAG y tolera cortes momentáneos de la API. |

## Cómo correrlo
```bash
cp .env.example .env          # completar la conexión a Redshift (o a un Postgres local para probar)
docker compose up airflow-init
docker compose up -d          # UI en http://localhost:8080
# Crear la tabla una vez con dags/sql/pokemon_table.sql y activar "pokemon_dag" en la UI
```
Test de la transformación, sin red ni base de datos:
```bash
pip install pytest requests && pytest tests/
```

## Estructura
```
dags/
├── pokemon_dag.py        # definición del DAG
├── pokemon/extract.py    # API → filas
├── pokemon/load.py       # carga + controles de calidad
└── sql/pokemon_table.sql # DDL de la tabla destino
tests/test_extract.py
```

## Próximos pasos
- Extraer y cargar en paralelo con *dynamic task mapping*.
- Llevar los controles de calidad a una librería (Great Expectations o Soda).
- Agregar una capa *staging* y cargar con `COPY` desde S3, que es el patrón recomendado en Redshift para volúmenes grandes.

*Proyecto realizado en el curso de Data Engineering. Refactorizado en 2026: credenciales fuera del código, carga idempotente y controles de calidad.*
