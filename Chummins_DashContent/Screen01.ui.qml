

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls

Rectangle {
    x: 0
    y: 0
    id: rectangle
    width: 800
    height: 480
    color: "#000000"

    StateGroup {
        id: newStateGroup
    }

    Image {
        id: image

        x: 15
        y: -3

        // Locked native dimensions
        width: 800
        height: 480

        source: "images/chummins_bg.png"
        fillMode: Image.PreserveAspectFit

        // Change ONLY this to visually resize it
        scale: .80
    }

    Tachometer {
        id: tachometer

        x: 509
        y: 60

        width: 290
        height: 290

        rpm: 1200
    }

    DriveStatus {
        id: driveStatus

        x: 258
        y: 356
        width: 272
        height: 125

        // Transmission states
        overdriveActive: true
        lockupActive: true

        // Engine operating state
        // power, normal, lugging, redline
        driveState: "power"
    }

    Speedometer {
        id: speedometer
        x: 1
        y: 60
        width: 290
        height: 290
        speed: 25
    }

    Image {
        id: image1
        x: 286
        y: -19
        width: 218
        height: 244
        source: "images/Cummins_logo.svg"
        fillMode: Image.PreserveAspectFit
    }
}
