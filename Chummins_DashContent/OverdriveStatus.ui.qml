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
    width: 40
    height: 20

    // ==============================
    // O/D INDICATOR
    // ==============================
    Text {
        id: overdriveText

        anchors.centerIn: parent

        text: "OVERDRIVE"

        color: root.active ? "#48D978" : "#707070"

        font.pixelSize: 13
        font.bold: true
        font.letterSpacing: 0.5
    }
}
