"""Test de la transformación sin llamar a la API (corre en segundos, sin red)."""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "dags"))

from pokemon.extract import parse_pokemon  # noqa: E402

SAMPLE = {
    "id": 1, "name": "bulbasaur", "height": 7, "weight": 69, "base_experience": 64,
    "types": [{"type": {"name": "grass"}}, {"type": {"name": "poison"}}],
    "stats": [
        {"stat": {"name": n}, "base_stat": v}
        for n, v in [("hp", 45), ("attack", 49), ("defense", 49),
                     ("special-attack", 65), ("special-defense", 65), ("speed", 45)]
    ],
}


def test_parse_pokemon():
    row = parse_pokemon(SAMPLE)
    assert row["pokemon_id"] == 1
    assert row["tipos"] == "grass,poison"
    assert row["hp"] == 45 and row["velocidad"] == 45
    assert row["ataque_especial"] == 65
