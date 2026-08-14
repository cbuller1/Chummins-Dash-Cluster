"""
Simulation input — generates smooth dummy data for UI testing.

Replaces real hardware inputs (ESP32 serial, GNSS) while developing the UI.
Uses a QTimer so all updates happen on the Qt event loop — no threads needed
and no race conditions with QML property bindings.

Disable by commenting out the sim lines in main.py and wiring up real inputs.

Simulation cycle (~30 s):
    0 – 14 s   smooth acceleration from idle through 6 gears to ~100 km/h
    14 – 16 s  brief cruise at top speed
    16 – 30 s  smooth deceleration back to idle
    (repeats)

Transfer case cycles independently every 8 s: 2hi → 4hi → 4lo → N → …
"""

from __future__ import annotations

import math
from typing import TYPE_CHECKING

from PySide6.QtCore import QTimer

from backend.logic.drive_state import DriveStateCalculator

if TYPE_CHECKING:
    from backend.dash_backend import DashBackend


# ------------------------------------------------------------------
# Engine / drivetrain constants  (tune to match actual vehicle)
# ------------------------------------------------------------------

IDLE_RPM: float = 750.0
MAX_RPM: float = 2800.0
REDLINE_RPM: float = 2600.0

CYCLE_PERIOD: float = 30.0   # seconds for one full accel/decel sweep
TICK_MS: int = 50            # update interval in milliseconds (20 Hz)

# Speed-per-RPM factor for each gear (mph per RPM).
# 3-speed + overdrive (gear 4).  Gear 4 at max RPM ≈ 100 mph.
_GEAR_SPEED_FACTOR: dict[int, float] = {
    1: 0.011,
    2: 0.021,
    3: 0.030,
    4: 0.036,   # overdrive
}

# Minimum RPM to be in each gear (index = gear - 1)
_UPSHIFT_RPM: list[float] = [0, 1200, 1800, 2300]

_TRANSFER_CASE_SEQUENCE: list[str] = ["2hi", "4hi", "4lo", "N"]
_TC_CHANGE_INTERVAL_S: float = 8.0  # seconds between transfer case changes


class SimReader:
    """Drives DashBackend with smooth simulated vehicle data."""

    def __init__(self, backend: DashBackend) -> None:
        self._backend = backend
        self._calc = DriveStateCalculator()
        self._timer = QTimer()
        self._timer.setInterval(TICK_MS)
        self._timer.timeout.connect(self._tick)

        self._elapsed: float = 0.0          # total simulated seconds
        self._tc_index: int = 0             # current transfer case index

    # ------------------------------------------------------------------
    # Lifecycle
    # ------------------------------------------------------------------

    def start(self) -> None:
        self._elapsed = 0.0
        self._timer.start()

    def stop(self) -> None:
        self._timer.stop()

    # ------------------------------------------------------------------
    # Per-tick update
    # ------------------------------------------------------------------

    def _tick(self) -> None:
        dt = TICK_MS / 1000.0
        self._elapsed += dt

        rpm, speed, gear, lockup, overdrive = self._simulate_drivetrain(self._elapsed)

        self._backend.rpm = rpm
        self._backend.speed = speed
        self._backend.gear = gear
        self._backend.lockupActive = lockup
        self._backend.overdriveActive = overdrive
        self._backend.driveState = self._calc.calculate(
            rpm=rpm,
            gear=gear,
            lockup_active=lockup,
            overdrive_active=overdrive,
        )

        # Transfer case: advance index every _TC_CHANGE_INTERVAL_S seconds
        tc_index = int(self._elapsed / _TC_CHANGE_INTERVAL_S) % len(_TRANSFER_CASE_SEQUENCE)
        if tc_index != self._tc_index:
            self._tc_index = tc_index
            self._backend.transferCase = _TRANSFER_CASE_SEQUENCE[self._tc_index]

    # ------------------------------------------------------------------
    # Drivetrain simulation
    # ------------------------------------------------------------------

    def _simulate_drivetrain(
        self, t: float
    ) -> tuple[float, float, int, bool, bool]:
        """
        Return (rpm, speed_kph, gear, lockup_active, overdrive_active)
        for simulation time *t* (seconds).
        """
        # Smooth 0→1→0 envelope over the cycle using a sine arch
        phase = (t % CYCLE_PERIOD) / CYCLE_PERIOD
        envelope = math.sin(phase * math.pi)        # 0 at start/end, 1 at midpoint

        rpm = IDLE_RPM + (MAX_RPM - IDLE_RPM) * _ease_in_out(envelope)

        # Select gear from RPM position in the upswing
        gear = self._rpm_to_gear(rpm)

        speed = rpm * _GEAR_SPEED_FACTOR.get(gear, 0.05)

        # Torque converter lockup: engaged in gear 3+ above 1200 RPM
        lockup = gear >= 3 and rpm > 1200.0

        # Overdrive: gear 4 is the OD gear
        overdrive = gear == 4

        return rpm, speed, gear, lockup, overdrive

    @staticmethod
    def _rpm_to_gear(rpm: float) -> int:
        """Map current RPM to the appropriate gear (1–4, where 4 = OD)."""
        for gear in range(4, 0, -1):
            if rpm >= _UPSHIFT_RPM[gear - 1]:
                return gear
        return 1


# ------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------

def _ease_in_out(x: float) -> float:
    """Cubic ease-in-out for smoother transitions (x in [0, 1])."""
    return x * x * (3.0 - 2.0 * x)
