import argparse
import configparser
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
# Command-line arguments  (hardware.ini provides defaults; CLI args override)
# ---------------------------------------------------------------------------

def _parse_args() -> argparse.Namespace:
    # Load hardware.ini — values here become the default for every arg below.
    hw = configparser.ConfigParser()
    hw.read(PROJECT_ROOT / "hardware.ini")

    parser = argparse.ArgumentParser(
        description="Chummins Dash",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="Default port/baud values are read from hardware.ini in the project root.",
    )

    parser.add_argument(
        "--port",
        metavar="PORT",
        help="Waveshare ESP32 USB serial port.  Overrides hardware.ini [waveshare] port.",
    )

    parser.add_argument(
        "--baud",
        type=int,
        metavar="BAUD",
        help="Waveshare baud rate.  Overrides hardware.ini [waveshare] baud.",
    )

    parser.add_argument(
        "--sim",
        action="store_true",
        help="Run in simulation mode (no hardware required).  Overrides hardware.ini [app] sim.",
    )

    parser.add_argument(
        "--gps-port",
        metavar="PORT",
        help="Feather GPS USB serial port.  Overrides hardware.ini [feather_gps] port.",
    )

    parser.add_argument(
        "--gps-baud",
        type=int,
        metavar="BAUD",
        help="Feather GPS baud rate.  Overrides hardware.ini [feather_gps] baud.",
    )

    # Apply hardware.ini values as argparse defaults so CLI args still override.
    parser.set_defaults(
        port     = hw.get("waveshare",  "port", fallback=None) or None,
        baud     = hw.getint("waveshare",  "baud", fallback=115200),
        sim      = hw.getboolean("app", "sim", fallback=False),
        gps_port = hw.get("feather_gps", "port", fallback=None) or None,
        gps_baud = hw.getint("feather_gps", "baud", fallback=115200),
    )

    # parse_known_args lets Qt platform arguments (--platform, etc.) pass through.
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

    reader = None
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

    elif args.sim:
        from backend.inputs.sim_reader import SimReader

        reader = SimReader(backend)

        boot_log("SimReader created (simulation mode)")

    else:
        print(
            "WARNING: no data source configured — UI will show zero values.\n"
            "  Set [waveshare] port in hardware.ini, or pass --port / --sim.",
            flush=True,
        )

    boot_log("starting vehicle data reader")

    if reader:
        reader.start()
        boot_log("vehicle data reader started")
    else:
        boot_log("no vehicle data reader — UI running in display-only mode")

    # -----------------------------------------------------------------------
    # Feather GPS reader (optional — speed, odometer, trip)
    # -----------------------------------------------------------------------

    if args.gps_port:
        from backend.inputs.feather_gps_serial import FeatherGPSSerial

        gps_reader = FeatherGPSSerial(
            backend,
            args.gps_port,
            args.gps_baud,
        )
        gps_reader.start()
        boot_log(f"FeatherGPSSerial started: port={args.gps_port}")

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