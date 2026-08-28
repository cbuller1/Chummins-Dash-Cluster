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
    readonly property real contentScale: Math.min(
        width / 800,
        height / 480
    )

    // ============================================================
    // MAIN DASHBOARD CONTENT
    // ============================================================

    Item {
        id: contentRoot

        width: 800
        height: 480

        x: (root.width - 800 * root.contentScale) / 2
        y: (root.height - 480 * root.contentScale) / 2

        transform: Scale {
            xScale: root.contentScale
            yScale: root.contentScale
        }

        SwipeView {
            id: swipeView

            anchors.fill: parent

            // Start on cluster page
            currentIndex: 2

            BackupCameraPage {}

            FrontCameraPage {}

            Screen01 {
                id: mainScreen
            }

            RelayControlPage {}

            InfoPage {}
        }

        // ========================================================
        // PAGE INDICATOR
        // ========================================================

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
                    width: swipeView.currentIndex === index
                           ? 20
                           : 8

                    height: 8
                    radius: 4

                    color: swipeView.currentIndex === index
                           ? "#48D978"
                           : "#555555"

                    Behavior on width {
                        NumberAnimation {
                            duration: 150
                        }
                    }
                }
            }
        }
    }

    // ============================================================
    // BRIGHTNESS OVERLAY
    //
    // This remains separate from the startup fade.
    // backend.brightness controls normal dashboard brightness after
    // startup has completed.
    // ============================================================

    Rectangle {
        id: brightnessOverlay

        anchors.fill: parent

        color: "black"

        opacity: 1.0 - backend.brightness

        z: 100

        visible: opacity > 0.01

        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }
    }

    // ============================================================
    // STARTUP FADE
    //
    // No image is displayed here.
    //
    // Qt initially presents a completely black screen. The actual
    // dashboard is already rendered underneath this rectangle.
    //
    // Over 3.5 seconds the black overlay becomes transparent,
    // gradually revealing the gauges.
    // ============================================================

    Rectangle {
        id: startupFade

        anchors.fill: parent

        color: "black"

        z: 200

        opacity: 1.0
        visible: true

        Component.onCompleted: startupFadeAnimation.start()

        NumberAnimation {
            id: startupFadeAnimation

            target: startupFade
            property: "opacity"

            from: 1.0
            to: 0.0

            duration: 3500

            easing.type: Easing.InOutQuad

            onFinished: {
                startupFade.visible = false
            }
        }
    }
}