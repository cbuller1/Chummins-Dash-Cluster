"""
Drive state calculation logic.

Determines the current drive state label shown on the dashboard:

    "normal"   — engine is operating in a healthy, efficient range
    "power"    — engine is in the upper power band (high demand or passing)
    "lugging"  — engine RPM is too low for the current gear/load
    "redline"  — engine is approaching or at the maximum safe RPM

The thresholds below are reasonable defaults for a diesel engine.
Tune RPM_* values to match the specific engine's power curve.
"""

from __future__ import annotations

from dataclasses import dataclass


# ------------------------------------------------------------------
# Tuneable thresholds
# ------------------------------------------------------------------

@dataclass
class DriveStateThresholds:
    """RPM-based thresholds used by DriveStateCalculator."""
    lug_max: float = 1100.0    # RPM at or below this → "lugging" (if under load)
    normal_max: float = 1800.0 # RPM at or below this → "normal"
    power_max: float = 2400.0  # RPM at or below this → "power"
    redline_min: float = 2400.0  # RPM at or above this → "redline"


# ------------------------------------------------------------------
# Calculator
# ------------------------------------------------------------------

class DriveStateCalculator:
    """
    Computes the drive state string from live engine / transmission data.

    Usage
    -----
    calc = DriveStateCalculator()
    state = calc.calculate(rpm=1400, gear=3, lockup_active=True)
    backend.driveState = state
    """

    def __init__(self, thresholds: DriveStateThresholds | None = None) -> None:
        self.thresholds = thresholds or DriveStateThresholds()

    def calculate(
        self,
        rpm: float,
        gear: int,
        lockup_active: bool,
        overdrive_active: bool = False,
    ) -> str:
        """
        Return the drive state label for the current engine/transmission state.

        Parameters
        ----------
        rpm:
            Current engine RPM.
        gear:
            Currently selected gear (0 = neutral).
        lockup_active:
            Whether the torque converter lockup is engaged.
        overdrive_active:
            Whether overdrive is currently engaged.
        """
        t = self.thresholds

        # Redline — always highest priority regardless of gear
        if rpm >= t.redline_min:
            return "redline"

        # Neutral — no meaningful drive state
        if gear == 0:
            return "normal"

        # Lugging — RPM too low for the load; worse in higher gears
        # Also flag if lockup is active at very low RPM (can't slip to compensate)
        if rpm <= t.lug_max:
            if gear >= 3 or lockup_active:
                return "lugging"

        # Power band
        if rpm > t.normal_max:
            return "power"

        return "normal"
