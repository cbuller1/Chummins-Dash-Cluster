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
    width: 60
    height: 20

    // ==============================
    // LOCKUP INDICATOR
    // ==============================
    Text {
        id: lockupText

        anchors.centerIn: parent

        text: "LOCKUP"

        color: root.active ? "#48D978" : "#707070"

        font.pixelSize: 13
        font.bold: true
        font.letterSpacing: 0.5
    }
}
