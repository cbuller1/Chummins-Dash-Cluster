import argparse
import configparser
import os
import subprocess
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
#
# These imports happen while Plymouth is still displaying the boot splash.
# Importing PySide does not take ownership of DRM. QApplication does.
# ---------------------------------------------------------------------------

from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl, Qt
from PySide6.QtGui import QCursor

boot_log("PySide6 imported")

from backend import DashBackend

boot_log("DashBackend imported")


# ---------------------------------------------------------------------------
# Command-line arguments
# hardware.ini provides defaults; CLI args override
# ---------------------------------------------------------------------------

def _parse_args() -> argparse.Namespace:
    hw = configparser.ConfigParser()
    hw.read(PROJECT_ROOT / "hardware.ini")

    parser = argparse.ArgumentParser(
        description="Chummins Dash",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "Default port/baud values are read from hardware.ini "
            "in the project root."
        ),
    )

    parser.add_argument(
        "--port",
        metavar="PORT",
        help=(
            "Waveshare ESP32 USB serial port. "
            "Overrides hardware.ini [waveshare] port."
        ),
    )

    parser.add_argument(
        "--baud",
        type=int,
        metavar="BAUD",
        help=(
            "Waveshare baud rate. "
            "Overrides hardware.ini [waveshare] baud."
        ),
    )

    parser.add_argument(
        "--sim",
        action="store_true",
        help=(
            "Run in simulation mode (no hardware required). "
            "Overrides hardware.ini [app] sim."
        ),
    )

    parser.add_argument(
        "--gps-port",
        metavar="PORT",
        help=(
            "Feather GPS USB serial port. "
            "Overrides hardware.ini [feather_gps] port."
        ),
    )

    parser.add_argument(
        "--gps-baud",
        type=int,
        metavar="BAUD",
        help=(
            "Feather GPS baud rate. "
            "Overrides hardware.ini [feather_gps] baud."
        ),
    )

    parser.set_defaults(
        port=hw.get(
            "waveshare",
            "port",
            fallback=None,
        ) or None,

        baud=hw.getint(
            "waveshare",
            "baud",
            fallback=115200,
        ),

        sim=hw.getboolean(
            "app",
            "sim",
            fallback=False,
        ),

        gps_port=hw.get(
            "feather_gps",
            "port",
            fallback=None,
        ) or None,

        gps_baud=hw.getint(
            "feather_gps",
            "baud",
            fallback=115200,
        ),
    )

    # Allow Qt-specific command-line arguments to pass through.
    args, _ = parser.parse_known_args()

    return args


# ---------------------------------------------------------------------------
# Plymouth handoff
# ---------------------------------------------------------------------------

def release_plymouth() -> None:
    """
    Release Plymouth immediately before Qt EGLFS acquires DRM.

    The dashboard itself remains unprivileged. A root-owned helper is allowed
    through sudoers to perform only:

        plymouth quit --retain-splash

    This allows Plymouth to keep displaying the boot image while Python and
    PySide import, then release DRM immediately before QApplication/EGLFS
    acquires the display.
    """

    boot_log("releasing Plymouth")

    start = time.monotonic()

    try:
        result = subprocess.run(
            [
                "/usr/bin/sudo",
                "-n",
                "/usr/local/sbin/chummins-plymouth-quit",
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.PIPE,
            text=True,
            timeout=3.0,
            check=False,
        )

        elapsed = time.monotonic() - start

        if result.returncode == 0:
            boot_log(
                f"Plymouth released in {elapsed:.3f}s"
            )
        else:
            error = (result.stderr or "").strip()

            boot_log(
                "Plymouth quit returned "
                f"{result.returncode} after {elapsed:.3f}s"
                + (f": {error}" if error else "")
            )

    except FileNotFoundError:
        boot_log(
            "Plymouth helper or sudo not found — continuing"
        )

    except subprocess.TimeoutExpired:
        boot_log(
            "Plymouth quit timed out — continuing"
        )

    except Exception as exc:
        boot_log(
            f"Plymouth release failed: {exc}"
        )


# ---------------------------------------------------------------------------
# Main application
# ---------------------------------------------------------------------------

def main() -> None:
    boot_log("main() entered")

    # -----------------------------------------------------------------------
    # Arguments
    #
    # Do non-display work while Plymouth still owns the screen.
    # -----------------------------------------------------------------------

    args = _parse_args()

    boot_log("arguments parsed")

    # -----------------------------------------------------------------------
    # Visual handoff
    #
    # Correct ordering:
    #
    #   Plymouth owns DRM
    #       ↓
    #   Python/PySide imports complete
    #       ↓
    #   Plymouth releases DRM
    #       ↓
    #   QApplication/EGLFS acquires DRM
    #
    # Do NOT wait for frameSwapped before releasing Plymouth. EGLFS cannot
    # render a frame while Plymouth still owns DRM.
    # -----------------------------------------------------------------------

    release_plymouth()

    # -----------------------------------------------------------------------
    # Qt application
    # -----------------------------------------------------------------------

    boot_log("creating QApplication")

    app = QApplication(sys.argv)

    boot_log("QApplication created")

    # Hide the mouse pointer for the instrument cluster.
    app.setOverrideCursor(
        QCursor(Qt.CursorShape.BlankCursor)
    )

    boot_log("cursor hidden")

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
            f"ESP32Serial created: "
            f"port={args.port}, baud={args.baud}"
        )

    elif args.sim:
        from backend.inputs.sim_reader import SimReader

        reader = SimReader(backend)

        boot_log("SimReader created (simulation mode)")

    else:
        print(
            "WARNING: no data source configured — "
            "UI will show zero values.\n"
            "  Set [waveshare] port in hardware.ini, "
            "or pass --port / --sim.",
            flush=True,
        )

    boot_log("starting vehicle data reader")

    if reader:
        reader.start()
        boot_log("vehicle data reader started")
    else:
        boot_log(
            "no vehicle data reader — "
            "UI running in display-only mode"
        )

    # -----------------------------------------------------------------------
    # Feather GPS reader
    # -----------------------------------------------------------------------

    gps_reader = None

    if args.gps_port:
        from backend.inputs.feather_gps_serial import FeatherGPSSerial

        gps_reader = FeatherGPSSerial(
            backend,
            args.gps_port,
            args.gps_baud,
        )

        gps_reader.start()

        boot_log(
            f"FeatherGPSSerial started: "
            f"port={args.gps_port}"
        )

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

    boot_log(
        f"about to load App.qml: {qml_file}"
    )

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
        boot_log(
            "ERROR: QML root object failed to load"
        )

        print(
            "ERROR: QML root object failed to load.",
            file=sys.stderr,
        )

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

    # Flush final mileage / persistent vehicle data before exit.
    backend.save_data()

    boot_log("vehicle data saved")

    sys.exit(exit_code)


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    main()