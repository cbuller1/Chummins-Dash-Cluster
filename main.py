import os
import sys
from pathlib import Path

# Must be set before QApplication is created
os.environ["QML_COMPAT_RESOLVE_URLS_ON_ASSIGNMENT"] = "1"
os.environ["QT_ENABLE_HIGHDPI_SCALING"] = "0"
os.environ["QT_LOGGING_RULES"] = "qt.qml.connections=false"

PROJECT_ROOT = Path(__file__).parent
os.environ["QT_QUICK_CONTROLS_CONF"] = str(PROJECT_ROOT / "qtquickcontrols2.conf")

from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType
from PySide6.QtCore import QUrl, QObject, Signal, Property


class DashBackend(QObject):
    """
    Exposes dashboard data to QML.
    Set these properties from your data source (CAN bus, serial, etc.).
    In QML, access via: backend.rpm, backend.speed, etc.
    """

    rpmChanged = Signal()
    speedChanged = Signal()
    driveStateChanged = Signal()
    overdriveActiveChanged = Signal()
    lockupActiveChanged = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._rpm = 1500.0
        self._speed = 50.0
        self._driveState = "power"   # "normal", "lugging", "power", "redline"
        self._overdriveActive = True
        self._lockupActive = True

    @Property(float, notify=rpmChanged)
    def rpm(self):
        return self._rpm

    @rpm.setter
    def rpm(self, value):
        if self._rpm != value:
            self._rpm = value
            self.rpmChanged.emit()

    @Property(float, notify=speedChanged)
    def speed(self):
        return self._speed

    @speed.setter
    def speed(self, value):
        if self._speed != value:
            self._speed = value
            self.speedChanged.emit()

    @Property(str, notify=driveStateChanged)
    def driveState(self):
        return self._driveState

    @driveState.setter
    def driveState(self, value):
        if self._driveState != value:
            self._driveState = value
            self.driveStateChanged.emit()

    @Property(bool, notify=overdriveActiveChanged)
    def overdriveActive(self):
        return self._overdriveActive

    @overdriveActive.setter
    def overdriveActive(self, value):
        if self._overdriveActive != value:
            self._overdriveActive = value
            self.overdriveActiveChanged.emit()

    @Property(bool, notify=lockupActiveChanged)
    def lockupActive(self):
        return self._lockupActive

    @lockupActive.setter
    def lockupActive(self, value):
        if self._lockupActive != value:
            self._lockupActive = value
            self.lockupActiveChanged.emit()


def main():
    app = QApplication(sys.argv)

    backend = DashBackend()

    engine = QQmlApplicationEngine()

    # QtQuick.Studio.Components is not bundled with PySide6; use local shim
    engine.addImportPath(str(PROJECT_ROOT / "qml_imports"))

    # Expose the backend object to all QML files under the name "backend"
    engine.rootContext().setContextProperty("backend", backend)

    qml_file = PROJECT_ROOT / "Chummins_DashContent" / "App.qml"
    engine.load(QUrl.fromLocalFile(str(qml_file)))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
