"""
Powers off the Raspberry Pi after ignition hot has been absent for
SHUTDOWN_DELAY_MS. Cancelled immediately if ignition is restored.
Requires a sudoers entry: <user> ALL=(ALL) NOPASSWD: /sbin/shutdown
"""

from __future__ import annotations

import logging
import subprocess
from typing import TYPE_CHECKING

from PySide6.QtCore import QObject, QTimer, Slot

if TYPE_CHECKING:
    from backend.dash_backend import DashBackend

logger = logging.getLogger(__name__)

SHUTDOWN_DELAY_MS = 13 * 60 * 1000  # 13 minutes


class IgnitionShutdownTimer(QObject):
    def __init__(self, backend: DashBackend, parent: QObject | None = None) -> None:
        super().__init__(parent)
        self._backend = backend
        self._timer = QTimer(self)
        self._timer.setSingleShot(True)
        self._timer.setInterval(SHUTDOWN_DELAY_MS)
        self._timer.timeout.connect(self._shutdown)
        backend.ignitionOnChanged.connect(self._on_ignition_changed)

    @Slot()
    def _on_ignition_changed(self) -> None:
        if self._backend.ignitionOn:
            if self._timer.isActive():
                logger.info("Ignition restored — shutdown cancelled")
                self._timer.stop()
        else:
            logger.info("Ignition lost — shutdown in 13 minutes")
            self._timer.start()

    @Slot()
    def _shutdown(self) -> None:
        logger.warning("Ignition absent for 13 minutes — shutting down")
        subprocess.run(["sudo", "-n", "shutdown", "-h", "now"], check=False)
