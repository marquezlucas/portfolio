"""Extracción: PokeAPI -> lista de registros planos listos para cargar."""
from __future__ import annotations

import requests

BASE_URL = "https://pokeapi.co/api/v2/pokemon"
STAT_MAP = {
    "hp": "hp",
    "attack": "ataque",
    "defense": "defensa",
    "special-attack": "ataque_especial",
    "special-defense": "defensa_especial",
    "speed": "velocidad",
}


def parse_pokemon(payload: dict) -> dict:
    """Transforma la respuesta cruda de la API en una fila de la tabla `pokemon`."""
    stats = {s["stat"]["name"]: s["base_stat"] for s in payload["stats"]}
    row = {
        "pokemon_id": payload["id"],
        "nombre": payload["name"],
        "altura_dm": payload["height"],
        "peso_hg": payload["weight"],
        "tipos": ",".join(t["type"]["name"] for t in payload["types"]),
        "experiencia_base": payload.get("base_experience"),
    }
    row.update({col: stats.get(api_name) for api_name, col in STAT_MAP.items()})
    return row


def fetch_pokemon(first_id: int = 1, last_id: int = 151, timeout: int = 15) -> list[dict]:
    """Descarga los Pokémon en el rango [first_id, last_id].

    Si un id falla se corta la ejecución (raise_for_status): preferimos que la tarea falle
    y Airflow la reintente antes que cargar una tabla incompleta sin enterarnos.
    """
    rows = []
    with requests.Session() as session:
        for pokemon_id in range(first_id, last_id + 1):
            response = session.get(f"{BASE_URL}/{pokemon_id}", timeout=timeout)
            response.raise_for_status()
            rows.append(parse_pokemon(response.json()))
    return rows
