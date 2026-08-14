import QtQuick
import QtQuick.Studio.Components 1.0

Item {
    id: root

    // ==============================
    // PUBLIC PROPERTIES
    // ==============================

    // Expected:
    // "normal"
    // "lugging"
    // "power"
    // "redline"
    // "overboost"
    property string driveState: "normal"

    // Warning is active for lugging, redline, or overboost
    property bool warningActive: driveState === "lugging"
                                 || driveState === "redline"
                                 || driveState === "overboost"

    // ==============================
    // COMPONENT SIZE
    // ==============================
    width: 190
    height: 58

    // ==============================
    // RUGGED STATUS PANEL
    // ==============================
    Rectangle {
        id: panel

        anchors.fill: parent

        radius: 4
        color: "#E6101010"

        border.width: 4
        border.color: "#A8A8A4"

        // ==========================
        // INNER BORDER
        // ==========================
        Rectangle {
            id: innerBorder

            x: 4
            y: 4

            width: parent.width - 8
            height: parent.height - 8

            radius: 2

            color: "transparent"

            border.width: 1
            border.color: "#383838"
        }

        // ==========================
        // STATUS CONTENT
        // ==========================
        Item {
            id: statusArea

            x: 6
            y: 5

            width: parent.width - 12
            height: parent.height - 10

            opacity: root.warningActive ? 0.45 : 1.0

            // ==========================
            // WARNING PULSE
            // LUGGING:
            // 500 ms down / 500 ms up
            // REDLINE:
            // 250 ms down / 250 ms up
            // ==========================
            SequentialAnimation on opacity {
                id: warningPulse

                running: root.warningActive
                loops: Animation.Infinite

                NumberAnimation {
                    from: 1.0
                    to: 0.45

                    duration: (root.driveState === "redline" || root.driveState === "overboost") ? 250 : 500

                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    from: 0.45
                    to: 1.0

                    duration: (root.driveState === "redline" || root.driveState === "overboost") ? 250 : 500

                    easing.type: Easing.InOutQuad
                }
            }

            // ==========================
            // MAIN DRIVE STATE
            // ==========================
            Text {
                id: stateText

                anchors.horizontalCenter: parent.horizontalCenter

                // NORMAL has no hint, so center it
                // vertically in the entire status area.
                // All other states move upward to
                // make room for the hint below.
                y: root.driveState === "normal" ? (parent.height - height) / 2 : 5

                text: root.driveState
                      === "redline" ? "REDLINE" : root.driveState
                                      === "overboost" ? "OVERBOOST" : root.driveState
                                                        === "lugging" ? "LUGGING" : root.driveState
                                                                        === "power" ? "POWER BAND" : "NORMAL"

                color: root.driveState
                       === "redline" ? "#FF3B30" : root.driveState
                                       === "overboost" ? "#FF9500" : root.driveState
                                                         === "lugging" ? "#FF3B30" : root.driveState
                                                                         === "power" ? "#48D978" : "#E8E8E8"

                font.pixelSize: 15
                font.bold: true
                font.letterSpacing: 1.2
            }

            // ==========================
            // ACTION / STATUS HINT
            // ==========================
            Text {
                id: hintText

                anchors.horizontalCenter: parent.horizontalCenter

                y: 28

                // Completely hide hint for NORMAL
                visible: root.driveState !== "normal"

                text: root.driveState
                      === "redline" ? "BACK OFF" : root.driveState
                                      === "overboost" ? "CHECK BOOST" : root.driveState
                                                        === "lugging" ? "UNLOCK TC" : root.driveState
                                                                        === "power" ? "OPTIMAL" : ""

                color: root.driveState === "redline" ? "#FF3B30" : root.driveState
                                                       === "overboost" ? "#FF9500" : root.driveState
                                                                          === "lugging" ? "#FF3B30" : "#BFC4BF"

                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 2.0
            }
        }
    }
}
