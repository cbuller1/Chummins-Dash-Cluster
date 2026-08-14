from __future__ import annotations

from typing import TYPE_CHECKING

from PySide6.QtCore import QTimer

if TYPE_CHECKING:
    from backend.dash_backend import DashBackend


class DataLogger:
    """Samples speed from DashBackend at 1 Hz to accumulate mileage counters."""

    def __init__(self, backend: DashBackend) -> None:
        self._backend = backend
        self._tick: int = 0
        self._timer = QTimer()
        self._timer.setInterval(1000)
        self._timer.timeout.connect(self._sample)

    def start(self) -> None:
        self._tick = 0
        self._timer.start()

    def stop(self) -> None:
        self._timer.stop()

    def _sample(self) -> None:
        self._tick += 1
        # speed is mph; at 1 Hz one tick = 1 second = 1/3600 hours
        miles = self._backend.speed / 3600.0
        self._backend.add_distance(miles)
        if self._tick % 30 == 0:  # flush to disk every 30 s
            self._backend.save_data()
