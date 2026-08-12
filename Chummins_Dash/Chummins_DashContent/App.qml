import QtQuick
import Chummins_Dash
import QtCharts
import QtQuick.Controls
import QtQuick.Studio.Components

Window {
    width: mainScreen.width
    height: mainScreen.height

    visible: true
    title: "Chummins_Dash"

    Screen01 {
        id: mainScreen

        anchors.centerIn: parent
    }

}

