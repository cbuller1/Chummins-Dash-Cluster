import sys

from PySide6.QtCore import Qt, QUrl
from PySide6.QtGui import QGuiApplication, QCursor
from PySide6.QtQml import QQmlApplicationEngine

app = QGuiApplication(sys.argv)

# Hide cursor
app.setOverrideCursor(QCursor(Qt.BlankCursor))

engine = QQmlApplicationEngine()

engine.load(
    QUrl.fromLocalFile(
        "/home/chummins/Github/Chummins-Dash-Cluster/Splash.qml"
    )
)

if not engine.rootObjects():
    sys.exit(1)

sys.exit(app.exec())