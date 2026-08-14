"""
ESP32 serial input handler.

Reads newline-delimited JSON from the ESP32 over USB CDC serial and pushes
parsed values into DashBackend.

Wire format (20 Hz, from firmware serial_protocol.cpp):
    {"rpm":...,"tps":...,"boost":...,"lockup":...,"od":...,"gear":...,"range":...}\n

Install dependency:  pip install pyserial
"""

from __future__ import annotations

import json
import logging
import threading
from typing import TYPE_CHECKING

import serial
import serial.serialutil

if TYPE_CHECKING:
    from backend.dash_backend import DashBackend

logger = logging.getLogger(__name__)


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
        self.connect()
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
    # Protocol parsing
    # ------------------------------------------------------------------

    def _parse_message(self, raw: bytes) -> None:
        """Parse one newline-delimited JSON frame and dispatch to handlers."""
        try:
            data: dict = json.loads(raw.decode("utf-8", errors="replace"))
        except json.JSONDecodeError:
            logger.debug("Non-JSON line: %r", raw)
            return

        if "rpm"     in data: self._on_rpm(float(data["rpm"]))
        if "tps"     in data: self._on_tps(float(data["tps"]))
        if "boost"   in data: self._on_boost(float(data["boost"]))
        if "lockup"  in data: self._on_lockup(bool(data["lockup"]))
        if "od"      in data: self._on_overdrive(bool(data["od"]))
        if "blink_l" in data: self._on_blinker_left(bool(data["blink_l"]))
        if "blink_r" in data: self._on_blinker_right(bool(data["blink_r"]))
        if "ign"     in data: self._backend.ignitionOn = bool(data["ign"])
        if "gear"    in data: self._on_gear(int(data["gear"]))
        if "range"   in data: self._on_range(str(data["range"]))

    # ------------------------------------------------------------------
    # Per-signal handlers
    # ------------------------------------------------------------------

    def _on_rpm(self, value: float) -> None:
        self._backend.rpm = value

    def _on_tps(self, value: float) -> None:
        self._backend.tps = value

    def _on_boost(self, value: float) -> None:
        self._backend.boost = value

    def _on_gear(self, gear: int) -> None:
        self._backend.gear = gear

    def _on_lockup(self, active: bool) -> None:
        self._backend.lockupActive = active

    def _on_overdrive(self, active: bool) -> None:
        self._backend.overdriveActive = active

    def _on_range(self, value: str) -> None:
        self._backend.range = value

    def _send_relay(self, index: int, state: bool) -> None:
        if self._serial and self._serial.is_open:
            cmd = json.dumps({"cmd": "relay", "i": index, "v": state}) + "\n"
            self._serial.write(cmd.encode("utf-8"))

    def _on_blinker_left(self, active: bool) -> None:
        self._backend.blinkerLeft = active
        self._backend.leftTurnActive = active

    def _on_blinker_right(self, active: bool) -> None:
        self._backend.blinkerRight = active
        self._backend.rightTurnActive = active
