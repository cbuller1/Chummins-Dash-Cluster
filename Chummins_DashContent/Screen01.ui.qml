

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
        y: 0
        width: 800
        height: 480
        source: "images/chummins_bg_light.png"
        fillMode: Image.PreserveAspectFit

        RangeIndicator {
            id: rangeIndicator1
            x: 285
            y: -3
            width: 232
            height: 36
            range: backend.range
        }

        EngineSensors {
            id: engineSensors
            x: 250
            y: 425
            width: 303
            height: 44
            boostPsi: backend.boost
            throttlePosition: backend.tps
        }
    }

    StateGroup {
        id: newStateGroup
    }

    DriveState {
        id: driveStatus
        driveState: backend.driveState
        x: 316
        y: 117
        width: 179
        height: 59
    }

    Tachometer {
        id: tachometer

        x: 488
        y: 25

        width: 290
        height: 290

        rpm: backend.rpm
    }

    Speedometer {
        id: speedometer
        x: 44
        y: 45
        width: 250
        height: 250
        speed: backend.speed
    }

    Image {
        id: image1
        x: 341
        y: 11
        width: 110
        height: 127
        source: "images/chummins.svg"
        fillMode: Image.PreserveAspectFit
    }
    LeftTurnIndicator {
        id: leftTurnIndicator

        x: 307
        y: 60

        width: 42
        height: 28

        active: backend.leftTurnActive
    }

    RightTurnIndicator {
        id: rightTurnIndicator

        x: 441
        y: 60

        width: 42
        height: 28

        active: backend.rightTurnActive
    }
}
