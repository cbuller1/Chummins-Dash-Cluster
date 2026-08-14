

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Studio.Components

Rectangle {
    x: 0
    y: 0
    id: rectangle
    width: 800
    height: 480
    color: "#000000"

    Image {
        id: image
        x: 0
        y: -24
        width: 800
        height: 480
        source: "images/chummins_bg_light.png"
        fillMode: Image.PreserveAspectFit
    }

    StateGroup {
        id: newStateGroup
    }

    Tachometer {
        id: tachometer

        x: 488
        y: 4

        width: 290
        height: 290

        rpm: backend.rpm
    }

    DriveStatus {
        id: driveStatus

        x: 586
        y: 383
        width: 210
        height: 104

        // Transmission states
        overdriveActive: backend.overdriveActive
        lockupActive: backend.lockupActive

        // Engine operating state
        // power, normal, lugging, redline
        driveState: backend.driveState
    }

    Speedometer {
        id: speedometer
        x: 44
        y: 24
        width: 250
        height: 250
        speed: backend.speed
    }

    Image {
        id: image1
        x: 256
        y: -76
        width: 284
        height: 289
        source: "images/Cummins_logo.svg"
        fillMode: Image.PreserveAspectFit
    }

    DriveStatus {
        id: driveStatus1
        x: 8
        y: 376
        width: 210
        height: 104
        overdriveActive: backend.overdriveActive
        lockupActive: backend.lockupActive
        driveState: backend.driveState
    }
}
