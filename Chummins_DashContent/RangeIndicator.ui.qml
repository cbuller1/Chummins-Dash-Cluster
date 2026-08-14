import QtQuick
import QtQuick.Studio.Components 1.0

Item {
    id: root

    // ==============================
    // PUBLIC PROPERTY
    // ==============================
    // Expected values:
    // "2hi"
    // "4hi"
    // "n"
    // "4lo"
    property string range: "2hi"

    // ==============================
    // COMPONENT SIZE
    // ==============================
    width: 200
    height: width * 0.2

    // ==============================
    // FIXED DESIGN CANVAS
    // ==============================
    Item {
        id: content

        width: 200
        height: 100

        anchors.centerIn: parent

        scale: root.width / 200

        // ==============================
        // TITLE
        // ==============================

        // ==============================
        // SEPARATOR
        // ==============================

        // ==============================
        // 2HI
        // ==============================
        Text {
            id: text2hi

            x: 63
            y: 40

            width: 24
            height: 20

            text: "2HI"

            color: root.range === "2hi" ? "#48D978" : "#E0E0E0"

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.pixelSize: 12
            font.bold: true
        }

        // ==============================
        // 4HI
        // ==============================
        Text {
            id: text4hi

            x: 14
            y: 40

            width: 24
            height: 20

            text: "4HI"

            color: root.range === "4hi" ? "#48D978" : "#E0E0E0"

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.pixelSize: 12
            font.bold: true
        }

        // ==============================
        // NEUTRAL
        // ==============================
        Text {
            id: textNeutral

            x: 110
            y: 40

            width: 24
            height: 20

            text: "N"

            color: root.range === "n" ? "#48D978" : "#E0E0E0"

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.pixelSize: 12
            font.bold: true
        }

        // ==============================
        // 4LO
        // ==============================
        Text {
            id: text4lo

            x: 159
            y: 40

            width: 28
            height: 20

            text: "4LO"

            color: root.range === "4lo" ? "#48D978" : "#E0E0E0"

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.pixelSize: 12
            font.bold: true
        }
    }
}
