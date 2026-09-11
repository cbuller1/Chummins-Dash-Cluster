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
    width: 118
    height: 24

    // ==============================
    // O/D INDICATOR
    // ==============================
    Rectangle {
        anchors.fill: parent
        radius: 5

        color: root.active ? "#48D978" : "#1A1A1A"
        border.width: 2
        border.color: root.active ? "#48D978" : "#4A4A4A"

        Text {
            id: overdriveText

            anchors.centerIn: parent

            text: "OVERDRIVE"

            color: root.active ? "#101010" : "#5F5F5F"

            font.pixelSize: 12
            font.bold: true
            font.letterSpacing: 1.0
        }
    }
}
