"""
Relay output command handler.

Sends relay control commands to the ESP32 over the same serial connection
used by ESP32Serial (or a separate channel, TBD).

Relays controlled:
    - Overdrive relay     (engage / release overdrive gear)
    - Lockup relay        (engage / release torque converter lockup)
    - (add more as needed)

The outbound wire protocol is not yet defined — fill in _send_command()
once the ESP32 firmware command format is decided.
"""

from __future__ import annotations


class RelayCommands:
    """Sends relay control commands to the ESP32."""

    def __init__(self, serial_port=None) -> None:
        """
        Parameters
        ----------
        serial_port:
            An open serial.Serial instance shared with (or separate from)
            ESP32Serial.  Pass None until the protocol is wired up.
        """
        self._port = serial_port

    # ------------------------------------------------------------------
    # Public command API
    # ------------------------------------------------------------------

    def set_overdrive(self, active: bool) -> None:
        """Engage or release the overdrive relay."""
        self._send_command("OVERDRIVE", int(active))

    def set_lockup(self, active: bool) -> None:
        """Engage or release the torque converter lockup relay."""
        self._send_command("LOCKUP", int(active))

    # ------------------------------------------------------------------
    # Protocol layer  (fill in once ESP32 command format is defined)
    # ------------------------------------------------------------------

    def _send_command(self, name: str, value: int) -> None:
        """
        Encode and transmit a relay command to the ESP32.

        TODO: define the outbound wire format, then implement.
        Example formats to consider:
            ASCII:   f"SET:{name}:{value}\\n"  encoded to bytes
            Binary:  struct-packed command ID + value + checksum
        """
        if self._port is None:
            return
        raise NotImplementedError
