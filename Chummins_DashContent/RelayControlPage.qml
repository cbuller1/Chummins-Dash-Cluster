import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    width: 800
    height: 480
    color: "#000000"

    Text {
        id: pageTitle
        anchors.top: parent.top
        anchors.topMargin: 14
        anchors.horizontalCenter: parent.horizontalCenter
        text: "RELAY CONTROLS"
        color: "#CCCCCC"
        font.pixelSize: 20
        font.bold: true
        font.letterSpacing: 3
    }

    Grid {
        anchors.top: pageTitle.bottom
        anchors.topMargin: 14
        anchors.horizontalCenter: parent.horizontalCenter
        columns: 4
        columnSpacing: 16
        rowSpacing: 16

        Repeater {
            model: 8

            Rectangle {
                id: relayBtn
                width: 178
                height: 180
                radius: 8

                property bool isActive: index < backend.relayStates.length
                                        && backend.relayStates[index] === true

                color: isActive ? "#1a5c2a" : "#1a1a1a"
                border.color: isActive ? "#48D978" : "#444444"
                border.width: 2

                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "R" + (index + 1)
                        color: "#FFFFFF"
                        font.pixelSize: 40
                        font.bold: true
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: relayBtn.isActive ? "ON" : "OFF"
                        color: relayBtn.isActive ? "#48D978" : "#707070"
                        font.pixelSize: 18
                        font.bold: true
                        font.letterSpacing: 1
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: backend.setRelay(index, !relayBtn.isActive)
                }
            }
        }
    }
}
