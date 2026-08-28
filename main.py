import argparse
import os
import subprocess
import sys
from pathlib import Path

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

# ---------------------------------------------------------------------------
# Qt / application imports
# ---------------------------------------------------------------------------

from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl

from backend import DashBackend


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
# Plymouth handoff
# ---------------------------------------------------------------------------

def dismiss_plymouth() -> None:
    """
    Tell Plymouth to release the display.

    This is called only after Qt has presented the dashboard's first frame,
    preventing a black gap between the boot splash and dashboard.
    """

    try:
        subprocess.Popen(
            [
                "sudo",
                "-n",
                "/usr/bin/plymouth",
                "quit",
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

    except Exception:
        # Plymouth may not be running when the application is started
        # manually during development. That should not prevent the
        # dashboard from starting.
        pass


# ---------------------------------------------------------------------------
# Main application
# ---------------------------------------------------------------------------

def main() -> None:
    args = _parse_args()

    # -----------------------------------------------------------------------
    # Qt application
    # -----------------------------------------------------------------------

    app = QApplication(sys.argv)

    # -----------------------------------------------------------------------
    # Dashboard backend
    # -----------------------------------------------------------------------

    backend = DashBackend()

    # -----------------------------------------------------------------------
    # Vehicle data source
    # -----------------------------------------------------------------------

    if args.port:
        from backend.inputs.esp32_serial import ESP32Serial

        reader = ESP32Serial(
            backend,
            args.port,
            args.baud,
        )

    else:
        from backend.inputs.sim_reader import SimReader

        reader = SimReader(backend)

    reader.start()

    # -----------------------------------------------------------------------
    # Data logger
    # -----------------------------------------------------------------------

    from backend.data_logger import DataLogger

    data_logger = DataLogger(backend)
    data_logger.start()

    # -----------------------------------------------------------------------
    # QML engine
    # -----------------------------------------------------------------------

    engine = QQmlApplicationEngine()

    engine.addImportPath(
        str(PROJECT_ROOT / "qml_imports")
    )

    engine.rootContext().setContextProperty(
        "backend",
        backend,
    )

    qml_file = (
        PROJECT_ROOT
        / "Chummins_DashContent"
        / "App.qml"
    )

    engine.load(
        QUrl.fromLocalFile(
            str(qml_file)
        )
    )

    # -----------------------------------------------------------------------
    # Verify QML loaded successfully
    # -----------------------------------------------------------------------

    if not engine.rootObjects():
        print(
            "ERROR: QML root object failed to load.",
            file=sys.stderr,
        )

        data_logger.stop()
        backend.save_data()

        sys.exit(-1)

    # -----------------------------------------------------------------------
    # Plymouth -> Dashboard handoff
    # -----------------------------------------------------------------------

    window = engine.rootObjects()[0]

    plymouth_dismissed = False

    def first_frame_presented() -> None:
        """
        Called when Qt reports that a rendered frame has been swapped
        to the display.
        """

        nonlocal plymouth_dismissed

        if plymouth_dismissed:
            return

        plymouth_dismissed = True

        # Disconnect immediately so this only happens once.
        try:
            window.frameSwapped.disconnect(
                first_frame_presented
            )
        except (RuntimeError, TypeError):
            pass

        dismiss_plymouth()

    # QQuickWindow emits frameSwapped after presenting a frame.
    if hasattr(window, "frameSwapped"):
        window.frameSwapped.connect(
            first_frame_presented
        )

    else:
        # Fallback in case the root QML object isn't a QQuickWindow.
        # This shouldn't normally happen with the dashboard.
        dismiss_plymouth()

    # -----------------------------------------------------------------------
    # Run application
    # -----------------------------------------------------------------------

    exit_code = app.exec()

    # -----------------------------------------------------------------------
    # Clean shutdown
    # -----------------------------------------------------------------------

    del engine

    data_logger.stop()

    # Flush final mileage / persistent vehicle data before exit.
    backend.save_data()

    sys.exit(exit_code)


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    main()