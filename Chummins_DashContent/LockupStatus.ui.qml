import QtQuick
import QtQuick.Studio.Components 1.0

Item {
    id: root

    // ==============================
    // PUBLIC PROPERTY
    // ==============================
    property bool active: true

    // ==============================
    // COMPONENT SIZE
    // ==============================
    width: 92
    height: 24

    // ==============================
    // LOCKUP INDICATOR
    // ==============================
    Rectangle {
        anchors.fill: parent
        radius: 5

        color: root.active ? "#48D978" : "#1A1A1A"
        border.width: 2
        border.color: root.active ? "#48D978" : "#4A4A4A"

        Text {
            id: lockupText

            anchors.centerIn: parent

            text: "LOCKUP"

            color: root.active ? "#101010" : "#5F5F5F"

            font.pixelSize: 14
            font.bold: true
            font.letterSpacing: 1.0
        }
    }
}
