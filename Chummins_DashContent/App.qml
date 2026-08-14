import QtQuick
import QtCharts
import QtQuick.Controls
import QtQuick.Studio.Components

Window {
    width: 800
    height: 480
    visible: true
    title: "Chummins_Dash"

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: 2  // start on cluster page

        BackupCameraPage {}

        FrontCameraPage {}

        Screen01 { id: mainScreen }

        RelayControlPage {}

        InfoPage {}
    }

    // Page indicator dots — active dot expands and turns green
    Row {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 6
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 8
        opacity: 0.75
        z: 10

        Repeater {
            model: 5
            Rectangle {
                width: swipeView.currentIndex === index ? 20 : 8
                height: 8
                radius: 4
                color: swipeView.currentIndex === index ? "#48D978" : "#555555"
                Behavior on width { NumberAnimation { duration: 150 } }
            }
        }
    }
}

