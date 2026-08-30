"""
Drive state logic for a 1991.5 12-valve Cummins 5.9 6BT (K30 swap).

States (highest to lowest priority):
    "redline"   — RPM at or above governor; ease off immediately
    "overboost" — boost beyond safe threshold; risk of head gasket failure
    "lugging"   — low RPM under high load or with TC locked; severe stress
    "power"     — healthy power band with boost building
    "normal"    — efficient cruise
"""

from __future__ import annotations

from dataclasses import dataclass


@dataclass
class DriveStateThresholds:
    """1991.5 12-valve Cummins 5.9 6BT P7100 defaults — tune to your pump."""
    # Lugging with TC locked (manual lockup engaged at low RPM)
    lug_rpm_max: float = 1300.0        # RPM ceiling when lockup is on
    lug_tps_min_lockup: float = 25.0   # minimum TPS to care about with lockup on
    # Lugging without lockup (extreme stall-level condition only)
    lug_extreme_rpm: float = 900.0     # RPM at which unlocked lug is flagged
    lug_extreme_tps: float = 90.0      # TPS% required to flag unlocked lug
    # Power band
    power_rpm_min: float = 1500.0
    power_tps_min: float = 0.0
    power_boost_min: float = 0.0
    # Limits
    redline_rpm_min: float = 2500.0
    overboost_psi_min: float = 25.0


class DriveStateCalculator:
    def __init__(self, thresholds: DriveStateThresholds | None = None) -> None:
        self.thresholds = thresholds or DriveStateThresholds()

    def calculate(
        self,
        rpm: float,
        gear: int,
        lockup_active: bool,
        overdrive_active: bool = False,
        boost: float = 0.0,
        tps: float = 0.0,
    ) -> str:
        t = self.thresholds

        # 1 — Redline
        if rpm >= t.redline_rpm_min:
            return "redline"

        # 2 — Overboost (dangerous at any RPM)
        if boost >= t.overboost_psi_min:
            return "overboost"

        if gear == 0:
            return "normal"

        # 3 — Lugging
        #   With lockup on: converter can't slip, so any meaningful load at low RPM is dangerous
        #   Without lockup: only flag at extreme near-stall conditions
        if lockup_active:
            if rpm <= t.lug_rpm_max and tps >= t.lug_tps_min_lockup:
                return "lugging"
        else:
            if rpm <= t.lug_extreme_rpm and tps >= t.lug_extreme_tps:
                return "lugging"

        # 4 — Power band
        if rpm >= t.power_rpm_min and tps >= t.power_tps_min and boost >= t.power_boost_min:
            return "power"

        return "normal"
