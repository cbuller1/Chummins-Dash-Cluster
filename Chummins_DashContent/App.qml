import QtQuick
import QtCharts
import QtQuick.Controls
import QtQuick.Studio.Components

Window {
    id: root
    width: 800
    height: 480
    visibility: Window.FullScreen
    visible: true
    title: "Chummins_Dash"

    // Scale 800x480 design space uniformly to fill the screen
    readonly property real contentScale: Math.min(width / 800, height / 480)

    Item {
        id: contentRoot
        width: 800
        height: 480
        x: (root.width  - 800 * root.contentScale) / 2
        y: (root.height - 480 * root.contentScale) / 2
        transform: Scale {
            xScale: root.contentScale
            yScale: root.contentScale
        }

        SwipeView {
            id: swipeView
            anchors.fill: parent
            currentIndex: 2  // start on cluster page

            BackupCameraPage {}

            FrontCameraPage {}

            Screen01 { id: mainScreen }

            RelayControlPage {}

            InfoPage {}
        }

        // Page indicator dots — active dot expands and turns green
        Row {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8
            opacity: 0.75
            z: 10

            Repeater {
                model: 5
                Rectangle {
                    width: swipeView.currentIndex === index ? 20 : 8
                    height: 8
                    radius: 4
                    color: swipeView.currentIndex === index ? "#48D978" : "#555555"
                    Behavior on width { NumberAnimation { duration: 150 } }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 1.0 - backend.brightness
        z: 100
        visible: opacity > 0.01
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    Rectangle {
        id: startupFade
        anchors.fill: parent
        color: "black"
        opacity: 1.0
        z: 200

        Component.onCompleted: fadeOut.start()

        NumberAnimation {
            id: fadeOut
            target: startupFade
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: 1200
            easing.type: Easing.InOutQuad
        }
    }
}

