"""
ESP32 serial input handler.

Reads incoming messages from an ESP32 over a UART/USB-serial connection and
pushes parsed values into DashBackend.  The wire protocol is not yet defined —
fill in _parse_message() once the ESP32 firmware message format is decided.

Expected inbound data:
    - Engine RPM
    - Torque converter lockup status  (bool)
    - Overdrive status                (bool)
    - Gear selected                   (int, 0 = neutral)

Install dependency:  pip install pyserial
"""

from __future__ import annotations

import threading
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from backend.dash_backend import DashBackend


class ESP32Serial:
    """Reads status messages from an ESP32 and updates DashBackend."""

    DEFAULT_BAUD = 115200

    def __init__(self, backend: DashBackend, port: str, baud_rate: int = DEFAULT_BAUD) -> None:
        self._backend = backend
        self._port = port
        self._baud_rate = baud_rate
        self._serial = None        # serial.Serial instance, set in connect()
        self._thread: threading.Thread | None = None
        self._running = False

    # ------------------------------------------------------------------
    # Connection lifecycle
    # ------------------------------------------------------------------

    def connect(self) -> None:
        """Open the serial port."""
        # TODO: import serial; self._serial = serial.Serial(self._port, self._baud_rate, timeout=1)
        raise NotImplementedError

    def disconnect(self) -> None:
        """Close the serial port."""
        # TODO: if self._serial and self._serial.is_open: self._serial.close()
        raise NotImplementedError

    # ------------------------------------------------------------------
    # Reader thread
    # ------------------------------------------------------------------

    def start(self) -> None:
        """Connect and start the background reader thread."""
        self.connect()
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
        # TODO: while self._running:
        #           raw = self._serial.readline()
        #           if raw:
        #               self._parse_message(raw)
        raise NotImplementedError

    # ------------------------------------------------------------------
    # Protocol parsing  (fill in once ESP32 message format is defined)
    # ------------------------------------------------------------------

    def _parse_message(self, raw: bytes) -> None:
        """
        Parse one raw message and dispatch to the appropriate handler.

        TODO: define the wire format with the ESP32 firmware, then implement.
        Example formats to consider:
            JSON:    b'{"rpm":1500,"gear":3,"lockup":true,"od":false}\\n'
            Binary:  struct-packed bytes with a header/checksum
            ASCII:   b'RPM:1500\\n', b'GEAR:3\\n', etc.
        """
        raise NotImplementedError

    # ------------------------------------------------------------------
    # Per-signal handlers — called by _parse_message
    # ------------------------------------------------------------------

    def _on_rpm(self, value: float) -> None:
        self._backend.rpm = value

    def _on_gear(self, gear: int) -> None:
        self._backend.gear = gear

    def _on_lockup(self, active: bool) -> None:
        self._backend.lockupActive = active

    def _on_overdrive(self, active: bool) -> None:
        self._backend.overdriveActive = active
