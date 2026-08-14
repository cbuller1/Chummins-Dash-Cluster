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
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl

from backend import DashBackend
from backend.inputs.sim_reader import SimReader


def main() -> None:
    app = QApplication(sys.argv)

    backend = DashBackend()

    # --- Simulation (disable when using real hardware) ---------------
    sim = SimReader(backend)
    sim.start()
    # ----------------------------------------------------------------

    engine = QQmlApplicationEngine()
    engine.addImportPath(str(PROJECT_ROOT / "qml_imports"))
    engine.rootContext().setContextProperty("backend", backend)
    engine.load(QUrl.fromLocalFile(str(PROJECT_ROOT / "Chummins_DashContent" / "App.qml")))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
