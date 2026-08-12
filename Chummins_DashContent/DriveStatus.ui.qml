import QtQuick
import QtQuick.Studio.Components 1.0

Item {
    id: root

    // ==============================
    // PUBLIC PROPERTIES
    // ==============================
    property bool overdriveActive: false
    property bool lockupActive: false

    // Expected values:
    // "normal"
    // "lugging"
    // "economy"
    // "power"
    property string driveState: "normal"

    width: 200
    height: 100

    // ==============================
    // OVERDRIVE LABEL
    // ==============================
    Text {
        id: overdriveLabel

        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.top: parent.top
        anchors.topMargin: 8

        text: "OVERDRIVE"

        color: "#909090"

        font.pixelSize: 10
        font.bold: true
    }

    // ==============================
    // OVERDRIVE STATUS
    // ==============================
    Rectangle {
        id: overdriveStatus

        width: 42
        height: 20

        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.verticalCenter: overdriveLabel.verticalCenter

        radius: 4

        color: root.overdriveActive ? "#39D353" : "#101010"

        border.width: 1
        border.color: root.overdriveActive ? "#6BE57E" : "#505050"

        Text {
            anchors.centerIn: parent

            text: root.overdriveActive ? "ON" : "OFF"

            color: root.overdriveActive ? "#050505" : "#606060"

            font.pixelSize: 10
            font.bold: true
        }
    }

    // ==============================
    // TC LOCKUP LABEL
    // ==============================
    Text {
        id: lockupLabel

        anchors.left: parent.left
        anchors.leftMargin: 15

        anchors.top: overdriveLabel.bottom
        anchors.topMargin: 12

        text: "TC LOCKUP"

        color: "#909090"

        font.pixelSize: 10
        font.bold: true
    }

    // ==============================
    // TC LOCKUP STATUS
    // ==============================
    Rectangle {
        id: lockupStatus

        width: 42
        height: 20

        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.verticalCenter: lockupLabel.verticalCenter

        radius: 4

        color: root.lockupActive ? "#39D353" : "#101010"

        border.width: 1
        border.color: root.lockupActive ? "#6BE57E" : "#505050"

        Text {
            anchors.centerIn: parent

            text: root.lockupActive ? "ON" : "OFF"

            color: root.lockupActive ? "#050505" : "#606060"

            font.pixelSize: 10
            font.bold: true
        }
    }

    // ==============================
    // SEPARATOR
    // ==============================
    Rectangle {
        id: separator

        anchors.left: parent.left
        anchors.right: parent.right

        anchors.leftMargin: 15
        anchors.rightMargin: 15

        anchors.top: lockupLabel.bottom
        anchors.topMargin: 12

        height: 1

        color: "#404040"
    }

    // ==============================
    // DYNAMIC OPERATING STATE
    // ==============================
    Text {
        id: driveStateText

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: separator.bottom
        anchors.topMargin: 10

        text: root.driveState === "lugging" ? "!  LUGGING - UNLOCK TC" : root.driveState
                                              === "power" ? "POWER BAND" : "NORMAL"

        color: root.driveState === "lugging" ? "#FF3030" : root.driveState
                                               === "power" ? "#39D353" : "#606060"

        font.pixelSize: root.driveState === "lugging" ? 11 : 13
        font.bold: true
        font.letterSpacing: 0.7
    }
}
