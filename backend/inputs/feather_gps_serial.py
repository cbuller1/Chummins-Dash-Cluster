"""
Feather M4 Express GPS serial input handler.

Reads speed, odometer, trip, and service-interval counters from the
Feather GPS node over USB CDC serial, and pushes values into DashBackend.
Also forwards counter-reset commands from the UI back to the Feather.

Wire format (1 Hz, from firmware serial_protocol.cpp):
    {"speed":...,"odo":...,"trip":...,"eng_oil":...,"trans":...,"diff":...,"coolant":...}

Reset command (to firmware command_handler.cpp):
    {"cmd":"reset","counter":"trip"}   — valid counters: trip eng_oil trans diff coolant
    "odo" is intentionally rejected by the firmware.

Install dependency:  pip install pyserial
"""

from __future__ import annotations

import json
import logging
import threading
from typing import TYPE_CHECKING

import serial
import serial.serialutil
from PySide6.QtCore import QObject, Signal, Slot, Qt

if TYPE_CHECKING:
    from backend.dash_backend import DashBackend

logger = logging.getLogger(__name__)

# Maps DashBackend resetCounter() QML names → firmware counter names
_RESET_NAME_MAP: dict[str, str] = {
    "trip":         "trip",
    "engineOilTrip": "eng_oil",
    "transOilTrip":  "trans",
    "diffFluidTrip": "diff",
    "coolantTrip":   "coolant",
    # "odometer" intentionally absent — firmware refuses it too
}


class _MainThreadDispatcher(QObject):
    frameReady = Signal(dict)


class FeatherGPSSerial:
    """Reads speed/mileage frames from the Feather GPS node and updates DashBackend."""

    DEFAULT_BAUD = 115200

    def __init__(self, backend: DashBackend, port: str, baud_rate: int = DEFAULT_BAUD) -> None:
        self._backend   = backend
        self._port      = port
        self._baud_rate = baud_rate
        self._serial: serial.Serial | None = None
        self._thread: threading.Thread | None = None
        self._running   = False
        self._write_lock = threading.Lock()
        self._dispatcher = _MainThreadDispatcher()
        self._dispatcher.frameReady.connect(
            self._apply_frame, Qt.ConnectionType.QueuedConnection
        )

    # ------------------------------------------------------------------
    # Lifecycle
    # ------------------------------------------------------------------

    def connect(self) -> None:
        self._serial = serial.Serial(self._port, self._baud_rate, timeout=1)
        self._backend.featherGpsConnected = True
        logger.info("Connected to Feather GPS on %s at %d baud", self._port, self._baud_rate)

    def disconnect(self) -> None:
        if self._serial and self._serial.is_open:
            self._serial.close()
        self._backend.featherGpsConnected = False

    def start(self) -> None:
        try:
            self.connect()
        except serial.serialutil.SerialException as exc:
            logger.warning("Feather GPS port %r unavailable: %s — running without it", self._port, exc)
            return
        self._backend.counterResetRequested.connect(self._send_reset)
        self._running = True
        self._thread = threading.Thread(
            target=self._read_loop, daemon=True, name="feather-gps-serial"
        )
        self._thread.start()

    def stop(self) -> None:
        self._running = False
        if self._thread:
            self._thread.join(timeout=2)
            self._thread = None
        self.disconnect()

    # ------------------------------------------------------------------
    # Background reader thread
    # ------------------------------------------------------------------

    def _read_loop(self) -> None:
        while self._running:
            try:
                raw = self._serial.readline()
                if raw:
                    self._parse_message(raw)
            except serial.serialutil.SerialException as exc:
                logger.error("Feather GPS serial read error: %s", exc)
                break
            except Exception as exc:  # noqa: BLE001
                logger.warning("Unexpected error in Feather GPS read loop: %s", exc)

    # ------------------------------------------------------------------
    # Protocol parsing  (background thread → queued to main thread)
    # ------------------------------------------------------------------

    def _parse_message(self, raw: bytes) -> None:
        try:
            data: dict = json.loads(raw.decode("utf-8", errors="replace"))
        except json.JSONDecodeError:
            logger.debug("Non-JSON from Feather GPS: %r", raw)
            return
        self._dispatcher.frameReady.emit(data)

    @Slot(dict)
    def _apply_frame(self, data: dict) -> None:
        b = self._backend
        if "speed"   in data: b.speed        = float(data["speed"])
        if "odo"     in data: b.odometer      = float(data["odo"])
        if "trip"    in data: b.trip          = float(data["trip"])
        if "eng_oil" in data: b.engineOilTrip = float(data["eng_oil"])
        if "trans"   in data: b.transOilTrip  = float(data["trans"])
        if "diff"    in data: b.diffFluidTrip = float(data["diff"])
        if "coolant" in data: b.coolantTrip   = float(data["coolant"])

    # ------------------------------------------------------------------
    # Reset command (main thread — called via counterResetRequested signal)
    # ------------------------------------------------------------------

    def _send_reset(self, qml_name: str) -> None:
        firmware_name = _RESET_NAME_MAP.get(qml_name)
        if not firmware_name:
            return  # odometer or unknown name — silently ignore
        if self._serial and self._serial.is_open:
            cmd = json.dumps({"cmd": "reset", "counter": firmware_name}) + "\n"
            with self._write_lock:
                self._serial.write(cmd.encode("utf-8"))
