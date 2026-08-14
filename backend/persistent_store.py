import json
from pathlib import Path

_DATA_FILE = Path(__file__).parents[1] / "data" / "vehicle_data.json"

_DEFAULTS: dict[str, float] = {
    "odometer":        0.0,
    "trip":            0.0,
    "engine_oil_trip": 0.0,
    "trans_oil_trip":  0.0,
    "diff_fluid_trip": 0.0,
    "coolant_trip":    0.0,
}


class PersistentStore:
    """Loads and saves vehicle mileage counters to a JSON file."""

    def __init__(self) -> None:
        self._data: dict[str, float] = dict(_DEFAULTS)
        self._load()

    def _load(self) -> None:
        try:
            if _DATA_FILE.exists():
                loaded: dict = json.loads(_DATA_FILE.read_text())
                for k in _DEFAULTS:
                    if k in loaded:
                        self._data[k] = float(loaded[k])
        except Exception:
            pass  # corrupted file — start from defaults

    def save(self) -> None:
        _DATA_FILE.parent.mkdir(parents=True, exist_ok=True)
        _DATA_FILE.write_text(json.dumps(self._data, indent=2))

    def get(self, key: str) -> float:
        return self._data.get(key, 0.0)

    def set(self, key: str, value: float) -> None:
        self._data[key] = value
