"""
ESP32 serial input handler.

Reads newline-delimited JSON from the ESP32 over USB CDC serial and pushes
parsed values into DashBackend.

Wire format (20 Hz, from firmware serial_protocol.cpp):
    {"rpm":...,"tps":...,"boost":...,"lockup":...,"od":...,"blink_l":...,"blink_r":...,"ign":...,"gear":...,"range":...}\n

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

from backend.logic.drive_state import DriveStateCalculator

if TYPE_CHECKING:
    from backend.dash_backend import DashBackend

logger = logging.getLogger(__name__)


class _MainThreadDispatcher(QObject):
    """Receives parsed frames cross-thread and applies them on the main thread."""
    frameReady = Signal(dict)


class ESP32Serial:
    """Reads status messages from an ESP32 and updates DashBackend."""

    DEFAULT_BAUD = 115200

    def __init__(self, backend: DashBackend, port: str, baud_rate: int = DEFAULT_BAUD) -> None:
        self._backend = backend
        self._port = port
        self._baud_rate = baud_rate
        self._serial: serial.Serial | None = None
        self._thread: threading.Thread | None = None
        self._running = False
        self._write_lock = threading.Lock()
        self._calc = DriveStateCalculator()
        # QueuedConnection delivers the signal on the main thread regardless
        # of which thread emits it, keeping all QObject writes on the main thread.
        self._dispatcher = _MainThreadDispatcher()
        self._dispatcher.frameReady.connect(
            self._apply_frame, Qt.ConnectionType.QueuedConnection
        )

    # ------------------------------------------------------------------
    # Connection lifecycle
    # ------------------------------------------------------------------

    def connect(self) -> None:
        """Open the serial port."""
        self._serial = serial.Serial(self._port, self._baud_rate, timeout=1)
        self._backend.esp32Connected = True
        logger.info("Connected to ESP32 on %s at %d baud", self._port, self._baud_rate)

    def disconnect(self) -> None:
        """Close the serial port."""
        if self._serial and self._serial.is_open:
            self._serial.close()
        self._backend.esp32Connected = False

    # ------------------------------------------------------------------
    # Reader thread
    # ------------------------------------------------------------------

    def start(self) -> None:
        """Connect and start the background reader thread."""
        try:
            self.connect()
        except serial.serialutil.SerialException as exc:
            logger.warning("Waveshare port %r unavailable: %s — running without it", self._port, exc)
            return
        self._backend.relayCommandRequested.connect(self._send_relay)
        self._running = True
        self._thread = threading.Thread(target=self._read_loop, daemon=True, name="esp32-serial")
        self._thread.start()

    def stop(self) -> None:
        """Stop the reader thread and disconnect."""
        self._running = False
        if self._thread:
            self._thread.join(timeout=2)
            self._thread = None
        self.disconnect()

    def _read_loop(self) -> None:
        """Background thread: continuously read lines from the serial port."""
        while self._running:
            try:
                raw = self._serial.readline()
                if raw:
                    self._parse_message(raw)
            except serial.serialutil.SerialException as exc:
                logger.error("Serial read error: %s", exc)
                self._backend.esp32Connected = False
                break
            except Exception as exc:  # noqa: BLE001
                logger.warning("Unexpected error in read loop: %s", exc)

    # ------------------------------------------------------------------
    # Protocol parsing  (called from background thread)
    # ------------------------------------------------------------------

    def _parse_message(self, raw: bytes) -> None:
        """Decode one JSON frame and post it to the main thread."""
        try:
            data: dict = json.loads(raw.decode("utf-8", errors="replace"))
        except json.JSONDecodeError:
            logger.debug("Non-JSON line: %r", raw)
            return
        self._dispatcher.frameReady.emit(data)

    # ------------------------------------------------------------------
    # Frame application  (called on the Qt main thread via QueuedConnection)
    # ------------------------------------------------------------------

    @Slot(dict)
    def _apply_frame(self, data: dict) -> None:
        b = self._backend

        if "rpm"     in data: b.rpm             = float(data["rpm"])
        if "tps"     in data: b.tps             = float(data["tps"])
        if "boost"   in data: b.boost           = float(data["boost"])
        if "lockup"  in data: b.lockupActive    = bool(data["lockup"])
        if "od"      in data: b.overdriveActive = bool(data["od"])
        if "blink_l" in data:
            active = bool(data["blink_l"])
            b.blinkerLeft    = active
            b.leftTurnActive = active
        if "blink_r" in data:
            active = bool(data["blink_r"])
            b.blinkerRight    = active
            b.rightTurnActive = active
        if "ign"     in data: b.ignitionOn = bool(data["ign"])
        if "gear"    in data: b.gear       = int(data["gear"])
        if "range"   in data: b.range      = str(data["range"])

        b.driveState = self._calc.calculate(
            rpm=b.rpm,
            gear=b.gear,
            lockup_active=b.lockupActive,
            overdrive_active=b.overdriveActive,
            boost=b.boost,
            tps=b.tps,
        )

    def _send_relay(self, index: int, state: bool) -> None:
        if self._serial and self._serial.is_open:
            cmd = json.dumps({"cmd": "relay", "i": index, "v": state}) + "\n"
            with self._write_lock:
                self._serial.write(cmd.encode("utf-8"))
