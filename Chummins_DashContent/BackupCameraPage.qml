import QtQuick
import QtQuick.Controls

Rectangle {
    width: 800
    height: 480
    color: "#000000"

    // Replace this Item with a VideoOutput once the camera source is configured.
    // On the RPi: source = "gst-pipeline: v4l2src device=/dev/video0 ! videoconvert ! qtvideosink"
    Item {
        id: cameraArea
        anchors.fill: parent
        anchors.bottomMargin: 30

        Rectangle {
            anchors.fill: parent
            anchors.margins: 8
            color: "#0a0a0a"
            radius: 4
            border.color: "#333333"
            border.width: 1

            Column {
                anchors.centerIn: parent
                spacing: 14

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "BACKUP CAMERA"
                    color: "#FFFFFF"
                    font.pixelSize: 26
                    font.bold: true
                    font.letterSpacing: 4
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "No signal"
                    color: "#555555"
                    font.pixelSize: 15
                    font.letterSpacing: 2
                }
            }
        }
    }
}
