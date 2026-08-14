import QtQuick
import QtQuick.Controls

Rectangle {
    id: infoPage
    width: 800
    height: 480
    color: "#000000"

    // ── Trip & Odometer ───────────────────────────────────────────────
    Row {
        id: topRow
        anchors.top: parent.top; anchors.topMargin: 18
        anchors.left: parent.left; anchors.leftMargin: 20
        anchors.right: parent.right; anchors.rightMargin: 20
        height: 116

        Column {
            width: parent.width / 2
            spacing: 7
            Text { text: "TRIP"; color: "#666666"; font.pixelSize: 11; font.letterSpacing: 3 }
            Text { text: backend.trip.toFixed(1) + " mi"; color: "#FFFFFF"; font.pixelSize: 34; font.bold: true }
            Rectangle {
                width: 132; height: 32; radius: 5
                color: "#0d2a0d"; border.color: "#48D978"; border.width: 2
                Text { anchors.centerIn: parent; text: "RESET TRIP"; color: "#48D978"; font.pixelSize: 11; font.bold: true; font.letterSpacing: 1 }
                MouseArea { anchors.fill: parent; onClicked: backend.resetCounter("trip") }
            }
        }

        Column {
            width: parent.width / 2
            spacing: 7
            Text { text: "ODOMETER"; color: "#666666"; font.pixelSize: 11; font.letterSpacing: 3 }
            Text { text: backend.odometer.toFixed(1) + " mi"; color: "#FFFFFF"; font.pixelSize: 34; font.bold: true }
            Text { text: "non-resettable"; color: "#333333"; font.pixelSize: 11 }
        }
    }

    // ── Status bar ───────────────────────────────────────────────
    Row {
        id: statusRow
        anchors.top: topRow.bottom; anchors.topMargin: 8
        anchors.left: parent.left; anchors.leftMargin: 20
        height: 18
        spacing: 24
        Row {
            spacing: 6
            Rectangle { width: 8; height: 8; radius: 4; anchors.verticalCenter: parent.verticalCenter; color: backend.esp32Connected ? "#48D978" : "#FF4444" }
            Text { text: backend.esp32Connected ? "ESP32  CONNECTED" : "ESP32  NO SIGNAL"; color: backend.esp32Connected ? "#48D978" : "#FF4444"; font.pixelSize: 11 }
        }
        Row {
            spacing: 6
            Rectangle { width: 8; height: 8; radius: 4; anchors.verticalCenter: parent.verticalCenter; color: backend.ignitionOn ? "#FFD700" : "#333333" }
            Text { text: "IGNITION"; color: backend.ignitionOn ? "#FFD700" : "#444444"; font.pixelSize: 11 }
        }
    }

    Rectangle {
        id: divider
        anchors.top: statusRow.bottom; anchors.topMargin: 10
        anchors.left: parent.left; anchors.right: parent.right
        height: 1; color: "#2a2a2a"
    }

    Text {
        id: serviceLabel
        anchors.top: divider.bottom; anchors.topMargin: 10
        anchors.left: parent.left; anchors.leftMargin: 20
        text: "SERVICE INTERVALS"
        color: "#555555"; font.pixelSize: 10; font.letterSpacing: 4; font.bold: true
    }

    // ── 2×2 service card grid ────────────────────────────────────────
    Column {
        id: serviceGrid
        anchors.top: serviceLabel.bottom; anchors.topMargin: 10
        anchors.left: parent.left; anchors.leftMargin: 20
        anchors.right: parent.right; anchors.rightMargin: 20
        anchors.bottom: parent.bottom; anchors.bottomMargin: 14
        spacing: 10

        property real cardW: (width - 10) / 2
        property real cardH: (height - 10) / 2

        Row {
            spacing: 10
            ServiceCard { width: serviceGrid.cardW; height: serviceGrid.cardH; label: "ENGINE OIL"; miles: backend.engineOilTrip; onResetClicked: backend.resetCounter("engineOilTrip") }
            ServiceCard { width: serviceGrid.cardW; height: serviceGrid.cardH; label: "TRANS OIL";  miles: backend.transOilTrip;  onResetClicked: backend.resetCounter("transOilTrip") }
        }
        Row {
            spacing: 10
            ServiceCard { width: serviceGrid.cardW; height: serviceGrid.cardH; label: "DIFF FLUID"; miles: backend.diffFluidTrip; onResetClicked: backend.resetCounter("diffFluidTrip") }
            ServiceCard { width: serviceGrid.cardW; height: serviceGrid.cardH; label: "COOLANT";    miles: backend.coolantTrip;   onResetClicked: backend.resetCounter("coolantTrip") }
        }
    }

    component ServiceCard: Rectangle {
        id: card
        property string label: ""
        property real   miles: 0.0
        signal resetClicked()

        color: "#0e0e0e"; border.color: "#2a2a2a"; border.width: 1; radius: 6

        Column {
            anchors.left: parent.left; anchors.leftMargin: 14
            anchors.top: parent.top; anchors.topMargin: 12
            spacing: 6
            Text { text: card.label; color: "#666666"; font.pixelSize: 10; font.letterSpacing: 3; font.bold: true }
            Text { text: card.miles.toFixed(1) + " mi"; color: "#FFFFFF"; font.pixelSize: 26; font.bold: true }
            Rectangle {
                width: 90; height: 28; radius: 4
                color: "#1a1a1a"; border.color: "#3a3a3a"; border.width: 1
                Text { anchors.centerIn: parent; text: "RESET"; color: "#666666"; font.pixelSize: 11; font.letterSpacing: 2 }
                MouseArea { anchors.fill: parent; onClicked: card.resetClicked() }
            }
        }
    }
}
