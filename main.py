import argparse
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


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Chummins Dash")
    parser.add_argument(
        "--port",
        metavar="PORT",
        help="ESP32 USB serial port (e.g. /dev/ttyACM0). Omit to run in simulation mode.",
    )
    parser.add_argument("--baud", type=int, default=115200, metavar="BAUD")
    # parse_known_args so Qt args (--platform, etc.) are not rejected
    args, _ = parser.parse_known_args()
    return args


def main() -> None:
    args = _parse_args()
    app = QApplication(sys.argv)

    backend = DashBackend()

    if args.port:
        from backend.inputs.esp32_serial import ESP32Serial
        reader = ESP32Serial(backend, args.port, args.baud)
    else:
        from backend.inputs.sim_reader import SimReader
        reader = SimReader(backend)

    reader.start()

    engine = QQmlApplicationEngine()
    engine.addImportPath(str(PROJECT_ROOT / "qml_imports"))
    engine.rootContext().setContextProperty("backend", backend)
    engine.load(QUrl.fromLocalFile(str(PROJECT_ROOT / "Chummins_DashContent" / "App.qml")))

    if not engine.rootObjects():
        sys.exit(-1)

    exit_code = app.exec()
    del engine   # tear down QML bindings before backend is garbage-collected
    sys.exit(exit_code)


if __name__ == "__main__":
    main()
