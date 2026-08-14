from PySide6.QtCore import QObject, Signal, Property, Slot
from backend.persistent_store import PersistentStore


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
    blinkerLeftChanged = Signal()
    blinkerRightChanged = Signal()
    leftTurnActiveChanged = Signal()
    rightTurnActiveChanged = Signal()
    relayStatesChanged = Signal()
    relayCommandRequested = Signal(int, bool)
    tripChanged = Signal()
    odometerChanged = Signal()
    esp32ConnectedChanged = Signal()
    historyChanged = Signal()  # kept for compatibility; no longer emitted
    ignitionOnChanged = Signal()
    engineOilTripChanged = Signal()
    transOilTripChanged = Signal()
    diffFluidTripChanged = Signal()
    coolantTripChanged = Signal()

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
        self._blinkerLeft: bool = False
        self._blinkerRight: bool = False
        self._leftTurnActive: bool = False
        self._rightTurnActive: bool = False
        self._relay_states: list = [False] * 8
        self._store = PersistentStore()
        self._trip: float = self._store.get("trip")
        self._odometer: float = self._store.get("odometer")
        self._engine_oil_trip: float = self._store.get("engine_oil_trip")
        self._trans_oil_trip: float = self._store.get("trans_oil_trip")
        self._diff_fluid_trip: float = self._store.get("diff_fluid_trip")
        self._coolant_trip: float = self._store.get("coolant_trip")
        self._esp32Connected: bool = False
        self._ignitionOn: bool = False

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

    # ------------------------------------------------------------------
    # blinkerLeft
    # ------------------------------------------------------------------

    @Property(bool, notify=blinkerLeftChanged)
    def blinkerLeft(self) -> bool:
        return self._blinkerLeft

    @blinkerLeft.setter
    def blinkerLeft(self, value: bool) -> None:
        if self._blinkerLeft != value:
            self._blinkerLeft = value
            self.blinkerLeftChanged.emit()

    # ------------------------------------------------------------------
    # blinkerRight
    # ------------------------------------------------------------------

    @Property(bool, notify=blinkerRightChanged)
    def blinkerRight(self) -> bool:
        return self._blinkerRight

    @blinkerRight.setter
    def blinkerRight(self, value: bool) -> None:
        if self._blinkerRight != value:
            self._blinkerRight = value
            self.blinkerRightChanged.emit()

    # ------------------------------------------------------------------
    # leftTurnActive (QML-facing alias for blinkerLeft)
    # ------------------------------------------------------------------

    @Property(bool, notify=leftTurnActiveChanged)
    def leftTurnActive(self) -> bool:
        return self._leftTurnActive

    @leftTurnActive.setter
    def leftTurnActive(self, value: bool) -> None:
        if self._leftTurnActive != value:
            self._leftTurnActive = value
            self.leftTurnActiveChanged.emit()

    # ------------------------------------------------------------------
    # rightTurnActive (QML-facing alias for blinkerRight)
    # ------------------------------------------------------------------

    @Property(bool, notify=rightTurnActiveChanged)
    def rightTurnActive(self) -> bool:
        return self._rightTurnActive

    @rightTurnActive.setter
    def rightTurnActive(self, value: bool) -> None:
        if self._rightTurnActive != value:
            self._rightTurnActive = value
            self.rightTurnActiveChanged.emit()

    # ------------------------------------------------------------------
    # relayStates / setRelay
    # ------------------------------------------------------------------

    @Property('QVariantList', notify=relayStatesChanged)
    def relayStates(self) -> list:
        return list(self._relay_states)

    @Slot(int, bool)
    def setRelay(self, index: int, state: bool) -> None:
        if 0 <= index < 8 and self._relay_states[index] != state:
            self._relay_states[index] = state
            self.relayStatesChanged.emit()
            self.relayCommandRequested.emit(index, state)

    # ------------------------------------------------------------------
    # trip
    # ------------------------------------------------------------------

    @Property(float, notify=tripChanged)
    def trip(self) -> float:
        return self._trip

    @trip.setter
    def trip(self, value: float) -> None:
        if self._trip != value:
            self._trip = value
            self.tripChanged.emit()

    # ------------------------------------------------------------------
    # odometer
    # ------------------------------------------------------------------

    @Property(float, notify=odometerChanged)
    def odometer(self) -> float:
        return self._odometer

    @odometer.setter
    def odometer(self, value: float) -> None:
        if self._odometer != value:
            self._odometer = value
            self.odometerChanged.emit()

    # ------------------------------------------------------------------
    # esp32Connected
    # ------------------------------------------------------------------

    @Property(bool, notify=esp32ConnectedChanged)
    def esp32Connected(self) -> bool:
        return self._esp32Connected

    @esp32Connected.setter
    def esp32Connected(self, value: bool) -> None:
        if self._esp32Connected != value:
            self._esp32Connected = value
            self.esp32ConnectedChanged.emit()

    # ------------------------------------------------------------------
    # ignitionOn
    # ------------------------------------------------------------------

    @Property(bool, notify=ignitionOnChanged)
    def ignitionOn(self) -> bool:
        return self._ignitionOn

    @ignitionOn.setter
    def ignitionOn(self, value: bool) -> None:
        if self._ignitionOn != value:
            self._ignitionOn = value
            self.ignitionOnChanged.emit()

    # ------------------------------------------------------------------
    # Service interval trip counters (read-only properties; use add_distance / resetCounter)
    # ------------------------------------------------------------------

    @Property(float, notify=engineOilTripChanged)
    def engineOilTrip(self) -> float:
        return self._engine_oil_trip

    @Property(float, notify=transOilTripChanged)
    def transOilTrip(self) -> float:
        return self._trans_oil_trip

    @Property(float, notify=diffFluidTripChanged)
    def diffFluidTrip(self) -> float:
        return self._diff_fluid_trip

    @Property(float, notify=coolantTripChanged)
    def coolantTrip(self) -> float:
        return self._coolant_trip

    # ------------------------------------------------------------------
    # Mileage accumulation & persistence
    # ------------------------------------------------------------------

    def add_distance(self, miles: float) -> None:
        """Called by DataLogger at 1 Hz; increments all mileage counters."""
        if miles <= 0:
            return
        self._odometer        += miles
        self._trip            += miles
        self._engine_oil_trip += miles
        self._trans_oil_trip  += miles
        self._diff_fluid_trip += miles
        self._coolant_trip    += miles
        self.odometerChanged.emit()
        self.tripChanged.emit()
        self.engineOilTripChanged.emit()
        self.transOilTripChanged.emit()
        self.diffFluidTripChanged.emit()
        self.coolantTripChanged.emit()

    def save_data(self) -> None:
        self._store.set("odometer",        self._odometer)
        self._store.set("trip",             self._trip)
        self._store.set("engine_oil_trip",  self._engine_oil_trip)
        self._store.set("trans_oil_trip",   self._trans_oil_trip)
        self._store.set("diff_fluid_trip",  self._diff_fluid_trip)
        self._store.set("coolant_trip",     self._coolant_trip)
        self._store.save()

    @Slot(str)
    def resetCounter(self, name: str) -> None:
        """Reset a resettable trip counter by its QML property name."""
        if   name == "trip":           self._trip = 0.0;            self.tripChanged.emit()
        elif name == "engineOilTrip":  self._engine_oil_trip = 0.0; self.engineOilTripChanged.emit()
        elif name == "transOilTrip":   self._trans_oil_trip = 0.0;  self.transOilTripChanged.emit()
        elif name == "diffFluidTrip":  self._diff_fluid_trip = 0.0; self.diffFluidTripChanged.emit()
        elif name == "coolantTrip":    self._coolant_trip = 0.0;    self.coolantTripChanged.emit()
        # odometer is intentionally excluded
        self.save_data()
