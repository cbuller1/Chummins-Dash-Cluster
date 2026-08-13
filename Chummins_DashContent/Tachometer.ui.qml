import QtQuick
import QtQuick.Studio.Components 1.0

Item {
    id: root

    // ==============================
    // PUBLIC PROPERTIES
    // ==============================
    property real rpm: 1000
    property real maximumRpm: 3000

    width: 300
    height: 300

    // ==============================
    // GAUGE CONTENT
    // ==============================
    Item {
        id: gaugeContent

        width: 300
        height: 300
        anchors.centerIn: parent
        scale: root.width / 300

        // ==========================
        // GAUGE FACE
        // ==========================
        Rectangle {
            id: gaugeFace

            width: 292
            height: 292
            anchors.centerIn: parent

            radius: 146
            color: "#080808"

            border.width: 5
            border.color: "#404040"
        }

        // ==================================================
        // MODERN GRADIENT RPM BAND
        // Total sweep = 270 degrees
        // 100 RPM = 9 degrees
        // 0 RPM    = 225°
        // 500      = 270°
        // 1000     = 315°
        // 1400     = 351°
        // 1500     = 360°
        // 1600     = 369°
        // 2000     = 405°
        // 2200     = 423°
        // 2500     = 450°
        // 3000     = 495°
        // 0-1400    COOL WHITE
        // 1400-1500 WHITE -> GREEN
        // 1500-2200 GREEN
        // 2200-2500 YELLOW / AMBER
        // 2500-3000 RED
        // ==================================================

        // ==================================================
        // 0 - 1400 RPM
        // COOL WHITE
        // ==================================================
        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 243
            end: 225

            strokeWidth: 8
            strokeColor: "#F5F7F7"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 261
            end: 243

            strokeWidth: 8
            strokeColor: "#F4F7F6"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 279
            end: 261

            strokeWidth: 8
            strokeColor: "#F3F6F5"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 297
            end: 279

            strokeWidth: 8
            strokeColor: "#F1F5F3"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 315
            end: 297

            strokeWidth: 8
            strokeColor: "#EFF4F2"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 333
            end: 315

            strokeWidth: 8
            strokeColor: "#ECF3EF"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 351
            end: 333

            strokeWidth: 8
            strokeColor: "#E7F1EB"
            fillColor: "transparent"
        }

        // ==================================================
        // 1400 - 1500 RPM
        // WHITE -> GREEN TRANSITION
        // ==================================================
        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 354
            end: 351

            strokeWidth: 8
            strokeColor: "#D1E9DC"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 357
            end: 354

            strokeWidth: 8
            strokeColor: "#A8DCC0"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 360
            end: 357

            strokeWidth: 8
            strokeColor: "#72CFA0"
            fillColor: "transparent"
        }

        // ==================================================
        // 1500 - 2200 RPM
        // GREEN
        // ==================================================
        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 369
            end: 360

            strokeWidth: 8
            strokeColor: "#4EC88A"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 378
            end: 369

            strokeWidth: 8
            strokeColor: "#42C27E"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 387
            end: 378

            strokeWidth: 8
            strokeColor: "#39BC75"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 396
            end: 387

            strokeWidth: 8
            strokeColor: "#35B66F"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 405
            end: 396

            strokeWidth: 8
            strokeColor: "#38B46B"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 414
            end: 405

            strokeWidth: 8
            strokeColor: "#43B768"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 423
            end: 414

            strokeWidth: 8
            strokeColor: "#5FBA62"
            fillColor: "transparent"
        }

        // ==================================================
        // 2200 - 2500 RPM
        // YELLOW -> AMBER
        // ==================================================
        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 432
            end: 423

            strokeWidth: 8
            strokeColor: "#D9C84F"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 441
            end: 432

            strokeWidth: 8
            strokeColor: "#E7B747"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 450
            end: 441

            strokeWidth: 8
            strokeColor: "#ED9D42"
            fillColor: "transparent"
        }

        // ==================================================
        // 2500 - 3000 RPM
        // RED
        // ==================================================
        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 459
            end: 450

            strokeWidth: 8
            strokeColor: "#EB6555"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 468
            end: 459

            strokeWidth: 8
            strokeColor: "#E95B50"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 477
            end: 468

            strokeWidth: 8
            strokeColor: "#E4514C"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 486
            end: 477

            strokeWidth: 8
            strokeColor: "#DC494A"
            fillColor: "transparent"
        }

        ArcItem {
            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 495
            end: 486

            strokeWidth: 8
            strokeColor: "#D34046"
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
            strokeColor: "#606060"
            fillColor: "transparent"
        }

        // ==================================================
        // TICK MARKS
        // 31 marks total
        // 0 through 3000 RPM
        // One mark every 100 RPM
        // Every 500 RPM is a major tick.
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
                    width: 3
                    height: 14
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#D0D0D0"
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
                    color: "#707070"
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
                    color: "#707070"
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
                    color: "#707070"
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
                    color: "#707070"
                }
            }

            // 500 RPM
            Item {
                width: 300
                height: 300
                rotation: -90

                Rectangle {
                    width: 3
                    height: 14
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#D0D0D0"
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
                    color: "#707070"
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
                    color: "#707070"
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
                    color: "#707070"
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
                    color: "#707070"
                }
            }

            // 1000 RPM
            Item {
                width: 300
                height: 300
                rotation: -45

                Rectangle {
                    width: 3
                    height: 14
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#D0D0D0"
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
                    color: "#707070"
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
                    color: "#707070"
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
                    color: "#707070"
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
                    color: "#707070"
                }
            }

            // 1500 RPM
            Item {
                width: 300
                height: 300
                rotation: 0

                Rectangle {
                    width: 3
                    height: 14
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#D0D0D0"
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
                    color: "#707070"
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
                    color: "#707070"
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
                    color: "#707070"
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
                    color: "#707070"
                }
            }

            // 2000 RPM
            Item {
                width: 300
                height: 300
                rotation: 45

                Rectangle {
                    width: 3
                    height: 14
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#D0D0D0"
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
                    color: "#707070"
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
                    color: "#707070"
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
                    color: "#707070"
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
                    color: "#707070"
                }
            }

            // 2500 RPM
            Item {
                width: 300
                height: 300
                rotation: 90

                Rectangle {
                    width: 3
                    height: 14
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#D0D0D0"
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
                    color: "#707070"
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
                    color: "#707070"
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
                    color: "#707070"
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
                    color: "#707070"
                }
            }

            // 3000 RPM
            Item {
                width: 300
                height: 300
                rotation: 135

                Rectangle {
                    width: 3
                    height: 14
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#D0D0D0"
                }
            }
        }

        // ==================================================
        // RPM SCALE NUMBERS
        // ==================================================
        Text {
            text: "0"
            x: 73
            y: 215

            color: "#FFFFFF"

            font.pixelSize: 12
            font.bold: true
        }

        Text {
            text: "1000"
            x: 64
            y: 72

            color: "#FFFFFF"

            font.pixelSize: 12
            font.bold: true
        }

        Text {
            text: "1500"
            anchors.horizontalCenter: parent.horizontalCenter
            y: 43

            color: "#FFFFFF"

            font.pixelSize: 12
            anchors.horizontalCenterOffset: -1
            font.bold: true
        }

        Text {
            text: "2000"
            x: 205
            y: 72

            color: "#FFFFFF"

            font.pixelSize: 12
            font.bold: true
        }

        Text {
            text: "3000"
            x: 211
            y: 210

            color: "#FFFFFF"

            font.pixelSize: 12
            font.bold: true
        }

        // ==================================================
        // NEEDLE
        // ==================================================
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

                width: 4
                height: 128

                anchors.horizontalCenter: parent.horizontalCenter
                y: 27

                radius: 6
                anchors.horizontalCenterOffset: 0

                color: "#707070"
            }
        }

        // ==================================================
        // CENTER HUB
        // ==================================================
        Rectangle {
            id: needleHubOuter

            width: 20
            height: 20

            anchors.centerIn: parent

            radius: 10
            color: "#303030"

            border.width: 2
            border.color: "#A0A0A0"
        }

        // ==================================================
        // CURRENT RPM
        // ==================================================
        Text {
            id: rpmValue

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: needleHubOuter.bottom
            anchors.topMargin: 48

            text: Math.round(root.rpm)

            color: "#F5F5F5"

            font.pixelSize: 40
            anchors.horizontalCenterOffset: -3
            font.bold: true
        }

        // ==================================================
        // RPM LABEL
        // ==================================================
        Text {
            id: rpmLabel

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: rpmValue.bottom
            anchors.topMargin: -90

            text: "RPM"

            color: "#909090"

            font.pixelSize: 12
            anchors.horizontalCenterOffset: 1
            font.bold: true
            font.letterSpacing: 3
        }

        Text {
            text: "500"
            x: 42
            y: 142

            color: "#FFFFFF"

            font.pixelSize: 12
            font.bold: true
        }

        Text {
            text: "2500"
            x: 235
            y: 142

            color: "#FFFFFF"

            font.pixelSize: 12
            font.bold: true
        }
    }
}
