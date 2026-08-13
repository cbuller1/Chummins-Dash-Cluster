import QtQuick
import QtQuick.Studio.Components 1.0

Item {
    id: root

    // ==============================
    // PUBLIC PROPERTIES
    // ==============================
    property bool overdriveActive: true
    property bool lockupActive: true

    // Expected values:
    // "normal"
    // "lugging"
    // "power"
    // "redline"
    property string driveState: "power"

    // Shared font size for drive mode + hint
    property int driveStateFontSize: 13

    // Warning is active for either red state
    property bool warningActive: driveState === "lugging"
                                 || driveState === "redline"

    // ==============================
    // COMPONENT SIZE
    // ==============================
    width: 200
    height: width * 0.5

    // ==============================
    // FIXED DESIGN CANVAS
    // ==============================
    Item {
        id: content

        width: 200
        height: 100

        anchors.centerIn: parent

        // Scale entire component together
        scale: root.width / 200

        // ==============================
        // OVERDRIVE ROW
        // ==============================
        Item {
            id: overdriveRow

            width: 170
            height: 24

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 2

            // STATUS DOT
            Rectangle {
                id: overdriveDot

                width: 8
                height: 8
                radius: 4

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                color: root.overdriveActive ? "#48D978" : "#303030"

                border.width: 1
                border.color: root.overdriveActive ? "#73E99A" : "#505050"
            }

            // LABEL
            Text {
                id: overdriveLabel

                anchors.left: overdriveDot.right
                anchors.leftMargin: 9
                anchors.verticalCenter: parent.verticalCenter

                text: "OVERDRIVE"

                color: root.overdriveActive ? "#E8E8E8" : "#707070"

                font.pixelSize: 12
                font.bold: true
                font.letterSpacing: 0.5
            }

            // STATE
            Text {
                id: overdriveState

                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                text: root.overdriveActive ? "ON" : "OFF"

                color: root.overdriveActive ? "#48D978" : "#606060"

                font.pixelSize: 12
                font.bold: true
                font.letterSpacing: 0.5
            }
        }

        // ==============================
        // TC LOCKUP ROW
        // ==============================
        Item {
            id: lockupRow

            width: 170
            height: 24

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: overdriveRow.bottom

            // STATUS DOT
            Rectangle {
                id: lockupDot

                width: 8
                height: 8
                radius: 4

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                color: root.lockupActive ? "#48D978" : "#303030"

                border.width: 1
                border.color: root.lockupActive ? "#73E99A" : "#505050"
            }

            // LABEL
            Text {
                id: lockupLabel

                anchors.left: lockupDot.right
                anchors.leftMargin: 9
                anchors.verticalCenter: parent.verticalCenter

                text: "TC LOCKUP"

                color: root.lockupActive ? "#E8E8E8" : "#707070"

                font.pixelSize: 12
                font.bold: true
                font.letterSpacing: 0.5
            }

            // STATE
            Text {
                id: lockupState

                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                text: root.lockupActive ? "ON" : "OFF"

                color: root.lockupActive ? "#48D978" : "#606060"

                font.pixelSize: 12
                font.bold: true
                font.letterSpacing: 0.5
            }
        }

        // ==============================
        // SEPARATOR
        // ==============================
        Rectangle {
            id: separator

            width: 170
            height: 1

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: lockupRow.bottom
            anchors.topMargin: 3

            color: "#303030"
        }

        // ==============================
        // DRIVE STATE AREA
        // ==============================
        Item {
            id: driveStateArea

            width: 170
            height: 34

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: separator.bottom
            anchors.topMargin: 3

            // ==========================
            // DRIVE MODE + HINT
            // ==========================
            Row {
                id: driveStateRow

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                spacing: 12

                // Steady at full brightness normally.
                // Warning animation overrides opacity
                // while running.
                opacity: root.warningActive ? 0.45 : 1.0

                // ==========================
                // WARNING PULSE
                // LUGGING:
                // 500 ms down + 500 ms up
                // REDLINE:
                // 250 ms down + 250 ms up
                // ==========================
                SequentialAnimation on opacity {
                    id: warningPulse

                    running: root.warningActive
                    loops: Animation.Infinite

                    NumberAnimation {
                        from: 1.0
                        to: 0.45

                        duration: root.driveState === "redline" ? 250 : 500

                        easing.type: Easing.InOutQuad
                    }

                    NumberAnimation {
                        from: 0.45
                        to: 1.0

                        duration: root.driveState === "redline" ? 250 : 500

                        easing.type: Easing.InOutQuad
                    }
                }

                // ======================
                // OPERATING STATE
                // ======================
                Text {
                    id: driveStateText

                    text: root.driveState === "redline" ? "REDLINE:" : root.driveState === "lugging" ? "LUGGING:" : root.driveState === "power" ? "POWER BAND:" : "NORMAL"

                    color: root.driveState === "redline" ? "#FF3B30" : root.driveState === "lugging" ? "#FF3B30" : root.driveState === "power" ? "#48D978" : "#808080"

                    font.pixelSize: root.driveStateFontSize
                    font.bold: true
                    font.letterSpacing: 0.8
                }

                // ======================
                // ACTION / STATUS HINT
                // ======================
                Text {
                    id: driveStateHint

                    text: root.driveState === "redline" ? "BACK OFF" : root.driveState === "lugging" ? "UNLOCK TC" : root.driveState === "power" ? "OPTIMAL" : ""

                    color: root.driveState === "redline" ? "#FF3B30" : root.driveState === "lugging" ? "#FF3B30" : root.driveState === "power" ? "#48D978" : "#606060"

                    font.pixelSize: root.driveStateFontSize
                    font.bold: true
                    font.letterSpacing: 0.8
                }
            }
        }
    }
}
