from PySide6.QtCore import QObject, Signal, Property


class DashBackend(QObject):
    """
    Exposes dashboard state to QML via Qt properties and signals.

    Set properties from an input handler (CAN bus, serial, simulation, etc.).
    QML accesses values via the context property name set in main.py, e.g.:
        Tachometer { rpm: backend.rpm }
        Speedometer { speed: backend.speed }
    """

    rpmChanged = Signal()
    speedChanged = Signal()
    gearChanged = Signal()
    driveStateChanged = Signal()
    overdriveActiveChanged = Signal()
    lockupActiveChanged = Signal()
    rangeChanged = Signal()
    boostChanged = Signal()
    tpsChanged = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._rpm: float = 1500.0
        self._speed: float = 50.0
        self._gear: int = 1           # 0 = neutral, 1-6 = forward gears
        self._driveState: str = "normal"  # "normal" | "lugging" | "power" | "redline"
        self._overdriveActive: bool = False
        self._lockupActive: bool = False
        self._range: str = "2hi"  # "2hi" | "4hi" | "4lo" | "n"
        self._boost: float = 0.0   # turbo boost pressure in psi
        self._tps: float = 0.0     # throttle position 0–100 %

    # ------------------------------------------------------------------
    # rpm
    # ------------------------------------------------------------------

    @Property(float, notify=rpmChanged)
    def rpm(self) -> float:
        return self._rpm

    @rpm.setter
    def rpm(self, value: float) -> None:
        if self._rpm != value:
            self._rpm = value
            self.rpmChanged.emit()

    # ------------------------------------------------------------------
    # speed
    # ------------------------------------------------------------------

    @Property(float, notify=speedChanged)
    def speed(self) -> float:
        return self._speed

    @speed.setter
    def speed(self, value: float) -> None:
        if self._speed != value:
            self._speed = value
            self.speedChanged.emit()

    # ------------------------------------------------------------------
    # gear
    # ------------------------------------------------------------------

    @Property(int, notify=gearChanged)
    def gear(self) -> int:
        return self._gear

    @gear.setter
    def gear(self, value: int) -> None:
        if self._gear != value:
            self._gear = value
            self.gearChanged.emit()

    # ------------------------------------------------------------------
    # driveState
    # ------------------------------------------------------------------

    @Property(str, notify=driveStateChanged)
    def driveState(self) -> str:
        return self._driveState

    @driveState.setter
    def driveState(self, value: str) -> None:
        if self._driveState != value:
            self._driveState = value
            self.driveStateChanged.emit()

    # ------------------------------------------------------------------
    # overdriveActive
    # ------------------------------------------------------------------

    @Property(bool, notify=overdriveActiveChanged)
    def overdriveActive(self) -> bool:
        return self._overdriveActive

    @overdriveActive.setter
    def overdriveActive(self, value: bool) -> None:
        if self._overdriveActive != value:
            self._overdriveActive = value
            self.overdriveActiveChanged.emit()

    # ------------------------------------------------------------------
    # lockupActive
    # ------------------------------------------------------------------

    @Property(bool, notify=lockupActiveChanged)
    def lockupActive(self) -> bool:
        return self._lockupActive

    @lockupActive.setter
    def lockupActive(self, value: bool) -> None:
        if self._lockupActive != value:
            self._lockupActive = value
            self.lockupActiveChanged.emit()

    # ------------------------------------------------------------------
    # range
    # ------------------------------------------------------------------

    @Property(str, notify=rangeChanged)
    def range(self) -> str:
        return self._range

    @range.setter
    def range(self, value: str) -> None:
        if self._range != value:
            self._range = value
            self.rangeChanged.emit()

    # ------------------------------------------------------------------
    # boost
    # ------------------------------------------------------------------

    @Property(float, notify=boostChanged)
    def boost(self) -> float:
        return self._boost

    @boost.setter
    def boost(self, value: float) -> None:
        if self._boost != value:
            self._boost = value
            self.boostChanged.emit()

    # ------------------------------------------------------------------
    # tps
    # ------------------------------------------------------------------

    @Property(float, notify=tpsChanged)
    def tps(self) -> float:
        return self._tps

    @tps.setter
    def tps(self, value: float) -> None:
        if self._tps != value:
            self._tps = value
            self.tpsChanged.emit()
