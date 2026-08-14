import QtQuick
import QtQuick.Studio.Components 1.0

Item {
    id: root

    // ==============================
    // SENSOR VALUES
    // ==============================
    property real boostPsi: 8.4
    property real throttlePosition: 32

    // Add future sensors here
    property real egt: 650
    property real coolantTemp: 185

    // ==============================
    // SENSOR COUNT
    // Change this as sensors are added
    // ==============================
    property int sensorCount: 2

    // ==============================
    // COMPONENT SIZE
    // ==============================
    width: 760
    height: 44

    // ==============================
    // BACKGROUND PANEL
    // ==============================
    Rectangle {
        id: panel

        anchors.fill: parent

        radius: 4
        color: "transparent"

        border.width: 0
        border.color: "#B8B8B4"

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

            border.width: 0
            border.color: "#383838"
        }

        // ==========================
        // SENSOR ROW
        // ==========================
        Row {
            id: sensorRow

            x: 6
            y: 4

            width: parent.width - 12
            height: parent.height - 8

            // ======================
            // BOOST
            // ======================
            Item {
                id: boostSensor

                width: sensorRow.width / root.sensorCount
                height: sensorRow.height

                Text {
                    id: boostLabel

                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    text: "BOOST"

                    color: "#B8B8B4"

                    font.pixelSize: 14
                    font.bold: true
                    font.letterSpacing: 1.0
                }

                Text {
                    id: boostValue

                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    text: root.boostPsi.toFixed(1) + " PSI"

                    color: "#48D978"

                    font.pixelSize: 16
                    font.bold: true
                    font.letterSpacing: 0.4
                }

                Rectangle {
                    anchors.right: parent.right

                    width: 1
                    height: 24

                    anchors.verticalCenter: parent.verticalCenter

                    color: "#555555"
                }
            }

            // ======================
            // THROTTLE
            // ======================
            Item {
                id: throttleSensor

                width: sensorRow.width / root.sensorCount
                height: sensorRow.height

                Text {
                    id: throttleLabel

                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    text: "THROTTLE"

                    color: "#B8B8B4"

                    font.pixelSize: 14
                    font.bold: true
                    font.letterSpacing: 1.0
                }

                Text {
                    id: throttleValue

                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    text: Math.round(root.throttlePosition) + "%"

                    color: "#48D978"

                    font.pixelSize: 16
                    font.bold: true
                    font.letterSpacing: 0.4
                }
            }
        }
    }
}
