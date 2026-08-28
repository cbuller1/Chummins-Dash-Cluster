import QtQuick
import QtQuick.Window

Window {
    id: root

    visible: true
    visibility: Window.FullScreen
    color: "black"

    flags: Qt.FramelessWindowHint

    Image {
        anchors.centerIn: parent

        source: "file:///usr/share/plymouth/themes/chummins/boot.png"

        // Keep the image at its actual pixel dimensions
        fillMode: Image.Pad
        smooth: true
        mipmap: false
    }
}