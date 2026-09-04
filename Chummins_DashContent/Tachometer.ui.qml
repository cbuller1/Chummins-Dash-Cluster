import QtQuick
import QtQuick.Studio.Components 1.0

Item {
    id: root

    // ==============================
    // PUBLIC PROPERTIES
    // ==============================
    property real rpm: 1500
    property real maximumRpm: 3000
    property bool darkMode: true

    readonly property color majorMarkColor: darkMode ? "#F2F2EE" : "#181818"
    readonly property color minorMarkColor: darkMode ? "#AEB3B0" : "#666663"
    readonly property color scaleTextColor: darkMode ? "#F2F2EE" : "#181818"
    readonly property color secondaryTextColor: darkMode ? "#D8DAD7" : "#000000"

    // ==============================
    // COMPLETE GAUGE SIZE
    // Same structure as Speedometer
    // ==============================
    width: 360
    height: 360

    // ==============================
    // GAUGE CONTENT
    // ==============================
    Item {
        id: gaugeContent

        width: 300
        height: 300
        anchors.centerIn: parent

        // ==========================
        // GAUGE FACE / BEZEL
        // Same as working Speedometer
        // ==========================
        Image {
            id: bezel

            x: -20
            y: -20

            width: 340
            height: 340

            anchors.centerIn: parent

            source: "images/gauge_bezel.svg"

            anchors.verticalCenterOffset: 4
            anchors.horizontalCenterOffset: 0

            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true

            z: 0

            Image {
                id: image

                x: -6
                y: -6

                width: 350
                height: 350

                source: "images/gauge_bezel.svg"
                fillMode: Image.PreserveAspectFit
            }
        }

        // ==========================
        // OUTER GAUGE FACE
        // ==========================
        Rectangle {
            id: gaugeFace

            width: 292
            height: 292
            anchors.centerIn: parent

            radius: 146

            color: root.darkMode ? "#080A0B" : "#F2F1EC"

            border.width: 10
            border.color: root.darkMode ? "#4A4D4F" : "#92928F"
        }

        // ==========================
        // RECESSED FACE LIP
        // ==========================
        Rectangle {
            id: recessedFaceLip

            width: 272
            height: 272
            anchors.centerIn: parent

            radius: 136

            color: root.darkMode ? "#303436" : "#6A6A67"
        }

        // ==========================
        // INNER GAUGE FACE
        // ==========================
        Rectangle {
            id: innerGaugeFace

            width: 264
            height: 264
            anchors.centerIn: parent

            radius: 132

            color: root.darkMode ? "#080A0B" : "#F6F5F0"

            border.width: 1
            border.color: root.darkMode ? "#4A4D4F" : "#D8D7D2"
        }

        // ==================================================
        // RPM COLOR BAND
        // 0 RPM    = 225 degrees
        // 1500 RPM = 360 degrees
        // 3000 RPM = 495 degrees
        // ==================================================

        // 0 - 1400 RPM
        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 243
            end: 225
            strokeWidth: 6
            strokeColor: root.darkMode ? "#858A88" : "#3A3A3A"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 261
            end: 243
            strokeWidth: 6
            strokeColor: root.darkMode ? "#8B908D" : "#3B3E3C"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 279
            end: 261
            strokeWidth: 6
            strokeColor: root.darkMode ? "#919693" : "#3D423F"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 297
            end: 279
            strokeWidth: 6
            strokeColor: root.darkMode ? "#979C99" : "#3E4641"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 315
            end: 297
            strokeWidth: 6
            strokeColor: root.darkMode ? "#9DA29F" : "#404A43"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 333
            end: 315
            strokeWidth: 6
            strokeColor: root.darkMode ? "#A3A8A5" : "#414F46"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 351
            end: 333
            strokeWidth: 6
            strokeColor: root.darkMode ? "#A9AEAB" : "#435448"
            fillColor: "transparent"
        }

        // 1400 - 1500 transition
        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 354
            end: 351
            strokeWidth: 6
            strokeColor: "#42604C"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 357
            end: 354
            strokeWidth: 6
            strokeColor: "#417553"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 360
            end: 357
            strokeWidth: 6
            strokeColor: "#408B5C"
            fillColor: "transparent"
        }

        // 1500 - 2200 POWER BAND
        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 369
            end: 360
            strokeWidth: 6
            strokeColor: "#439F68"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 378
            end: 369
            strokeWidth: 6
            strokeColor: "#409D66"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 387
            end: 378
            strokeWidth: 6
            strokeColor: "#3F9F67"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 396
            end: 387
            strokeWidth: 6
            strokeColor: "#3D9B63"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 405
            end: 396
            strokeWidth: 6
            strokeColor: "#419D62"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 414
            end: 405
            strokeWidth: 6
            strokeColor: "#4B9F60"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 423
            end: 414
            strokeWidth: 6
            strokeColor: "#619F5C"
            fillColor: "transparent"
        }

        // 2200 - 2500 YELLOW / AMBER
        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 432
            end: 423
            strokeWidth: 6
            strokeColor: "#C7B044"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 441
            end: 432
            strokeWidth: 6
            strokeColor: "#D3A83E"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 450
            end: 441
            strokeWidth: 6
            strokeColor: "#D7953C"
            fillColor: "transparent"
        }

        // 2500 - 3000 REDLINE
        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 459
            end: 450
            strokeWidth: 6
            strokeColor: "#D95A4A"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 468
            end: 459
            strokeWidth: 6
            strokeColor: "#D65347"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 477
            end: 468
            strokeWidth: 6
            strokeColor: "#D64A42"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 486
            end: 477
            strokeWidth: 6
            strokeColor: "#CF453F"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent
            begin: 495
            end: 486
            strokeWidth: 6
            strokeColor: "#C9403C"
            fillColor: "transparent"
        }

        // ==================================================
        // STATIC TICK ARC
        // ==================================================
        ArcItem {
            id: tickArc

            width: 250
            height: 250
            anchors.centerIn: parent

            begin: 495
            end: 225

            strokeWidth: 2
            strokeColor: root.darkMode ? "#7F8587" : "#A0A09C"
            fillColor: "transparent"
        }

        // ==================================================
        // TICK MARKS
        // Explicit Items exactly like the working speedometer.
        // 31 marks, one every 100 RPM.
        // Major mark every 500 RPM.
        // ==================================================
        Item {
            id: tickMarks

            width: 300
            height: 300
            anchors.centerIn: parent

            // 0 RPM
            Item {
                width: 300
                height: 300
                rotation: -135

                Rectangle {
                    width: 4
                    height: 16
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.majorMarkColor
                }
            }

            // 100 RPM
            Item {
                width: 300
                height: 300
                rotation: -126

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 200 RPM
            Item {
                width: 300
                height: 300
                rotation: -117

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 300 RPM
            Item {
                width: 300
                height: 300
                rotation: -108

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 400 RPM
            Item {
                width: 300
                height: 300
                rotation: -99

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 500 RPM
            Item {
                width: 300
                height: 300
                rotation: -90

                Rectangle {
                    width: 4
                    height: 16
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.majorMarkColor
                }
            }

            // 600 RPM
            Item {
                width: 300
                height: 300
                rotation: -81

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 700 RPM
            Item {
                width: 300
                height: 300
                rotation: -72

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 800 RPM
            Item {
                width: 300
                height: 300
                rotation: -63

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 900 RPM
            Item {
                width: 300
                height: 300
                rotation: -54

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 1000 RPM
            Item {
                width: 300
                height: 300
                rotation: -45

                Rectangle {
                    width: 4
                    height: 16
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.majorMarkColor
                }
            }

            // 1100 RPM
            Item {
                width: 300
                height: 300
                rotation: -36

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 1200 RPM
            Item {
                width: 300
                height: 300
                rotation: -27

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 1300 RPM
            Item {
                width: 300
                height: 300
                rotation: -18

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 1400 RPM
            Item {
                width: 300
                height: 300
                rotation: -9

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 1500 RPM
            Item {
                width: 300
                height: 300
                rotation: 0

                Rectangle {
                    width: 4
                    height: 16
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.majorMarkColor
                }
            }

            // 1600 RPM
            Item {
                width: 300
                height: 300
                rotation: 9

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 1700 RPM
            Item {
                width: 300
                height: 300
                rotation: 18

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 1800 RPM
            Item {
                width: 300
                height: 300
                rotation: 27

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 1900 RPM
            Item {
                width: 300
                height: 300
                rotation: 36

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 2000 RPM
            Item {
                width: 300
                height: 300
                rotation: 45

                Rectangle {
                    width: 4
                    height: 16
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.majorMarkColor
                }
            }

            // 2100 RPM
            Item {
                width: 300
                height: 300
                rotation: 54

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 2200 RPM
            Item {
                width: 300
                height: 300
                rotation: 63

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 2300 RPM
            Item {
                width: 300
                height: 300
                rotation: 72

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 2400 RPM
            Item {
                width: 300
                height: 300
                rotation: 81

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 2500 RPM
            Item {
                width: 300
                height: 300
                rotation: 90

                Rectangle {
                    width: 4
                    height: 16
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.majorMarkColor
                }
            }

            // 2600 RPM
            Item {
                width: 300
                height: 300
                rotation: 99

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 2700 RPM
            Item {
                width: 300
                height: 300
                rotation: 108

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 2800 RPM
            Item {
                width: 300
                height: 300
                rotation: 117

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 2900 RPM
            Item {
                width: 300
                height: 300
                rotation: 126

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.minorMarkColor
                }
            }

            // 3000 RPM
            Item {
                width: 300
                height: 300
                rotation: 135

                Rectangle {
                    width: 4
                    height: 16
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.majorMarkColor
                }
            }
        }

        // ==================================================
        // RPM SCALE NUMBERS
        // ==================================================
        Text {
            text: "0"

            width: 40
            height: 20

            x: 58
            y: 211

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: root.scaleTextColor

            font.pixelSize: 12
            font.bold: true
        }

        Text {
            text: "500"

            width: 45
            height: 20

            x: 32
            y: 139

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: root.scaleTextColor

            font.pixelSize: 12
            font.bold: true
        }

        Text {
            text: "1000"

            width: 50
            height: 20

            x: 54
            y: 70

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: root.scaleTextColor

            font.pixelSize: 12
            font.bold: true
        }

        Text {
            text: "1500"

            width: 50
            height: 20

            x: 124
            y: 40

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: root.scaleTextColor

            font.pixelSize: 12
            font.bold: true
        }

        Text {
            text: "2000"

            width: 50
            height: 20

            x: 197
            y: 70

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: root.scaleTextColor

            font.pixelSize: 12
            font.bold: true
        }

        Text {
            text: "2500"

            width: 50
            height: 20

            x: 216
            y: 139

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: root.scaleTextColor

            font.pixelSize: 12
            font.bold: true
        }

        Text {
            text: "3000"

            width: 50
            height: 20

            x: 200
            y: 208

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: root.scaleTextColor

            font.pixelSize: 12
            font.bold: true
        }

        // ==================================================
        // NEEDLE
        // Same implementation style as working Speedometer
        // ==================================================
        Text {
            id: gaugeBrand

            y: 98

            anchors.horizontalCenter: parent.horizontalCenter

            text: "Cummins"

            color: root.secondaryTextColor

            font.family: "Roboto Condensed"
            font.pixelSize: 14
            anchors.horizontalCenterOffset: 2
            font.weight: Font.Bold
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 1.2
        }

        Item {
            id: needleAssembly

            width: 300
            height: 300

            anchors.centerIn: parent

            rotation: -135 + (270 * Math.min(Math.max(root.rpm, 0),
                                             root.maximumRpm) / root.maximumRpm)

            Behavior on rotation {
                NumberAnimation {
                    duration: 180
                }
            }

            Rectangle {
                id: needle

                width: 8
                height: 149

                anchors.horizontalCenter: parent.horizontalCenter

                y: 27

                radius: 6

                color: "#FF4500"
            }
        }

        LockupStatus {
            id: lockupStatus
            x: 121
            y: 249
            active: backend.lockupActive
        }

        // ==================================================
        // CENTER HUB
        // ==================================================
        Rectangle {
            id: needleHubOuter

            width: 22
            height: 22

            anchors.centerIn: parent

            radius: 11

            color: "#FF4500"

            border.width: 0
            border.color: "#3D3D3B"
        }
        Rectangle {
            id: needleHubInner

            width: 6
            height: 6
            color: "#000000"

            anchors.centerIn: parent

            radius: 4

            border.width: 0
            border.color: "#3D3D3B"
        }

        // ==================================================
        // RPM LABEL
        // ==================================================
        Text {
            id: rpmLabel

            y: 175

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 1

            text: "RPM"

            color: "#000000"

            font.pixelSize: 12
            font.bold: true
            font.letterSpacing: 3
        }

        // ==================================================
        // BRANDING
        // ==================================================

        // ==================================================
        // CURRENT RPM
        // ==================================================
        Text {
            id: rpmValue

            anchors.horizontalCenter: parent.horizontalCenter

            y: 195

            text: Math.round(root.rpm)

            color: root.darkMode ? "#FFFFFF" : "#181818"

            font.pixelSize: 40
            font.bold: true

            anchors.horizontalCenterOffset: -1
        }

        // ==================================================
        // TINTED / RECESSED GLASS LENS
        // ==================================================

        // Very subtle smoked tint over the entire lens

        // ==================================================
        // BROAD CURVED-GLASS REFLECTION
        // ==================================================

        // ==================================================
        // SECONDARY REFLECTION
        // ==================================================

        // ==================================================
        // SHARP SPECULAR HIGHLIGHT
        // ==================================================

        // ==================================================
        // DARK INNER LENS EDGE
        // Creates the recessed appearance
        // ==================================================

        // ==================================================
        // FINE OUTER GLASS HIGHLIGHT
        // ==================================================
    }
}
