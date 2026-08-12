

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import Chummins_Dash

Rectangle {
    id: rectangle
    width: Constants.width
    height: Constants.height
    color: "#000000"

    StateGroup {
        id: newStateGroup
    }

    Image {
        id: image
        x: 13
        y: 27
        width: 800
        height: 400
        source: "images/chummins_bg.png"
        fillMode: Image.PreserveAspectFit
    }

    Tachometer {
        id: tachometer

        x: 553
        y: 78

        width: 233
        height: 256

        rpm: 1850
    }

    DriveStatus {
        id: driveStatus

        x: 270
        y: 377
        width: 264
        height: 129

        // Transmission states
        overdriveActive: true
        lockupActive: true

        // Engine operating state
        // power, normal, lugging
        driveState: "power"
    }

    Speedometer {
        id: speedometer
        x: 0
        y: 83
        width: 232
        height: 258
    }

    Image {
        id: image1
        x: 307
        y: 4
        width: 184
        height: 218
        source: "images/Cummins_logo.svg"
        fillMode: Image.PreserveAspectFit
    }
}
