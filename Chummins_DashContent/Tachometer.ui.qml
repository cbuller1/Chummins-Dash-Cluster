import QtQuick
import QtQuick.Studio.Components 1.0

Item {
    id: root

    // ==============================
    // PUBLIC PROPERTIES
    // ==============================
    property real rpm: 1850
    property real maximumRpm: 3000

    property bool overdriveActive: false
    property bool lockupActive: false

    // Native design size
    width: 300
    height: 300

    // ==============================
    // GAUGE CONTENT
    // Everything is designed at
    // 300x300 and scaled together.
    // ==============================
    Item {
        id: gaugeContent

        width: 300
        height: 300

        anchors.centerIn: parent

        // Automatically scale everything when
        // the component width changes.
        scale: root.width / 300

        // ==========================
        // OUTER SILVER RING
        // ==========================
        Rectangle {
            id: outerRing

            anchors.centerIn: parent

            width: 280
            height: 280
            radius: 140

            color: "#080808"

            border.width: 5
            border.color: "#A0A0A0"
        }

        // ==========================
        // RPM VALUE
        // ==========================
        Text {
            id: rpmValue

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -9

            text: root.rpm

            color: "#F5F5F5"

            font.pixelSize: 48
            font.bold: true
        }

        // ==========================
        // RPM LABEL
        // ==========================
        Text {
            id: rpmLabel

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: rpmValue.bottom
            anchors.topMargin: -9

            text: "RPM"

            color: "#909090"

            font.pixelSize: 13
            font.bold: true
            font.letterSpacing: 3
        }

        // ==========================
        // DRIVETRAIN INDICATORS
        // ==========================
        Item {
            id: drivetrainIndicators

            width: 160
            height: 60

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 37

            // ======================
            // OVERDRIVE
            // ======================

            // ======================
            // TC LOCKUP
            // ======================
        }
    }
}
