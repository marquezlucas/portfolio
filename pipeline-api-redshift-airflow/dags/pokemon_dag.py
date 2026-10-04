"""DAG diario: PokeAPI -> Redshift, con control de calidad al final.

extract  ->  load  ->  quality_check
"""
from __future__ import annotations

from datetime import datetime, timedelta

from airflow.decorators import dag, task

from pokemon.extract import fetch_pokemon
from pokemon.load import check_quality, load_rows

FIRST_ID, LAST_ID = 1, 151  # primera generación


@dag(
    dag_id="pokemon_dag",
    description="Extrae datos de PokeAPI, los carga en Redshift y valida la carga",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",
    catchup=False,  # no reprocesar todos los días desde start_date al activar el DAG
    default_args={"owner": "lucas", "retries": 2, "retry_delay": timedelta(minutes=5)},
    tags=["portfolio", "redshift", "api"],
)
def pokemon_pipeline():
    @task
    def extract() -> list[dict]:
        return fetch_pokemon(FIRST_ID, LAST_ID)

    @task
    def load(rows: list[dict]) -> int:
        return load_rows(rows)

    @task
    def quality_check(loaded: int) -> None:
        check_quality(expected_rows=loaded)

    quality_check(load(extract()))


pokemon_pipeline()
