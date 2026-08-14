"""
USB GNSS speed sensor input handler.

Reads ground speed from a USB-connected GNSS receiver (e.g. u-blox, SiRF)
and pushes the value into DashBackend.  Most USB GNSS receivers expose a
virtual COM port and stream NMEA 0183 sentences.

Expected data:
    - Ground speed in km/h or mph (from NMEA $GNRMC / $GPVTG sentences)

Install dependency:  pip install pyserial pynmea2
"""

from __future__ import annotations

import threading
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from backend.dash_backend import DashBackend


class GNSSSensor:
    """Reads ground speed from a USB GNSS receiver and updates DashBackend."""

    DEFAULT_BAUD = 9600   # standard NMEA baud rate; some receivers use 115200

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
        """Open the serial port to the GNSS receiver."""
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
        """Connect and start the background NMEA reader thread."""
        self.connect()
        self._running = True
        self._thread = threading.Thread(target=self._read_loop, daemon=True, name="gnss-sensor")
        self._thread.start()

    def stop(self) -> None:
        """Stop the reader thread and disconnect."""
        self._running = False
        if self._thread:
            self._thread.join(timeout=2)
            self._thread = None
        self.disconnect()

    def _read_loop(self) -> None:
        """Background thread: read NMEA sentences and extract speed."""
        # TODO:
        #   import pynmea2
        #   while self._running:
        #       line = self._serial.readline().decode("ascii", errors="replace").strip()
        #       self._parse_nmea(line)
        raise NotImplementedError

    # ------------------------------------------------------------------
    # NMEA parsing
    # ------------------------------------------------------------------

    def _parse_nmea(self, sentence: str) -> None:
        """
        Parse one NMEA sentence and extract ground speed if present.

        Relevant sentence types:
            $GNRMC / $GPRMC  — speed over ground in knots (field 7)
            $GNVTG / $GPVTG  — speed over ground in km/h (field 7) and knots (field 5)

        TODO: implement once sensor model and unit preference are confirmed.
        """
        raise NotImplementedError

    def _on_speed(self, speed_kph: float) -> None:
        self._backend.speed = speed_kph
