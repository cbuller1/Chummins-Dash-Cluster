import argparse
import os
import sys
import time
from pathlib import Path

# ---------------------------------------------------------------------------
# Startup timing
# ---------------------------------------------------------------------------

BOOT_TIME = time.monotonic()


def boot_log(message: str) -> None:
    """Print a timestamp relative to the start of main.py."""
    print(
        f"BOOT +{time.monotonic() - BOOT_TIME:.3f}s: {message}",
        flush=True,
    )


boot_log("Python started")


# ---------------------------------------------------------------------------
# Qt environment
# These must be set before QApplication is created.
# ---------------------------------------------------------------------------

os.environ["QML_COMPAT_RESOLVE_URLS_ON_ASSIGNMENT"] = "1"
os.environ["QT_ENABLE_HIGHDPI_SCALING"] = "0"
os.environ["QT_LOGGING_RULES"] = "qt.qml.connections=false"

PROJECT_ROOT = Path(__file__).parent

os.environ["QT_QUICK_CONTROLS_CONF"] = str(
    PROJECT_ROOT / "qtquickcontrols2.conf"
)

boot_log("Qt environment configured")


# ---------------------------------------------------------------------------
# Qt / application imports
# ---------------------------------------------------------------------------

from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl

boot_log("PySide6 imported")

from backend import DashBackend

boot_log("DashBackend imported")


# ---------------------------------------------------------------------------
# Command-line arguments
# ---------------------------------------------------------------------------

def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Chummins Dash")

    parser.add_argument(
        "--port",
        metavar="PORT",
        help=(
            "ESP32 USB serial port (e.g. /dev/ttyACM0). "
            "Omit to run in simulation mode."
        ),
    )

    parser.add_argument(
        "--baud",
        type=int,
        default=115200,
        metavar="BAUD",
    )

    # parse_known_args allows Qt arguments such as --platform
    # to pass through without argparse rejecting them.
    args, _ = parser.parse_known_args()

    return args


# ---------------------------------------------------------------------------
# Main application
# ---------------------------------------------------------------------------

def main() -> None:
    boot_log("main() entered")

    # -----------------------------------------------------------------------
    # Arguments
    # -----------------------------------------------------------------------

    args = _parse_args()

    boot_log("arguments parsed")

    # -----------------------------------------------------------------------
    # Qt application
    # -----------------------------------------------------------------------

    boot_log("creating QApplication")

    app = QApplication(sys.argv)

    boot_log("QApplication created")

    # -----------------------------------------------------------------------
    # Dashboard backend
    # -----------------------------------------------------------------------

    boot_log("creating DashBackend")

    backend = DashBackend()

    boot_log("DashBackend created")

    # -----------------------------------------------------------------------
    # Vehicle data source
    # -----------------------------------------------------------------------

    boot_log("creating vehicle data reader")

    if args.port:
        from backend.inputs.esp32_serial import ESP32Serial

        reader = ESP32Serial(
            backend,
            args.port,
            args.baud,
        )

        boot_log(
            f"ESP32Serial created: port={args.port}, baud={args.baud}"
        )

    else:
        from backend.inputs.sim_reader import SimReader

        reader = SimReader(backend)

        boot_log("SimReader created")

    boot_log("starting vehicle data reader")

    reader.start()

    boot_log("vehicle data reader started")

    # -----------------------------------------------------------------------
    # Data logger
    # -----------------------------------------------------------------------

    boot_log("importing DataLogger")

    from backend.data_logger import DataLogger

    boot_log("DataLogger imported")

    data_logger = DataLogger(backend)

    boot_log("DataLogger created")

    data_logger.start()

    boot_log("DataLogger started")

    # -----------------------------------------------------------------------
    # QML engine
    # -----------------------------------------------------------------------

    boot_log("creating QQmlApplicationEngine")

    engine = QQmlApplicationEngine()

    boot_log("QQmlApplicationEngine created")

    engine.addImportPath(
        str(PROJECT_ROOT / "qml_imports")
    )

    boot_log("QML import path added")

    engine.rootContext().setContextProperty(
        "backend",
        backend,
    )

    boot_log("backend exposed to QML")

    qml_file = (
        PROJECT_ROOT
        / "Chummins_DashContent"
        / "App.qml"
    )

    boot_log(f"about to load App.qml: {qml_file}")

    # -----------------------------------------------------------------------
    # Load dashboard
    # -----------------------------------------------------------------------

    engine.load(
        QUrl.fromLocalFile(
            str(qml_file)
        )
    )

    boot_log("engine.load(App.qml) returned")

    # -----------------------------------------------------------------------
    # Verify QML loaded successfully
    # -----------------------------------------------------------------------

    if not engine.rootObjects():
        boot_log("ERROR: QML root object failed to load")

        print(
            "ERROR: QML root object failed to load.",
            file=sys.stderr,
        )

        data_logger.stop()
        backend.save_data()

        sys.exit(-1)

    boot_log("QML root object exists")

    # -----------------------------------------------------------------------
    # Run application
    # -----------------------------------------------------------------------

    boot_log("entering Qt event loop")

    exit_code = app.exec()

    # -----------------------------------------------------------------------
    # Clean shutdown
    # -----------------------------------------------------------------------

    boot_log("Qt event loop exited")

    del engine

    boot_log("QML engine destroyed")

    data_logger.stop()

    boot_log("DataLogger stopped")

    # Flush final mileage / persistent vehicle data before exit.
    backend.save_data()

    boot_log("vehicle data saved")

    sys.exit(exit_code)


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    main()