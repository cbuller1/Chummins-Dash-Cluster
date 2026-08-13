import QtQuick
import QtQuick.Studio.Components 1.0

Item {
    id: root

    // ==============================
    // PUBLIC PROPERTIES
    // ==============================
    property real speed: 35
    property real maximumSpeed: 100

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
        // OUTER WHITE SCALE BAND
        // Same 270-degree sweep as tachometer
        // 0 MPH   = 225°
        // 50 MPH  = 360°
        // 100 MPH = 495°
        // ==================================================
        ArcItem {
            id: speedBand

            width: 272
            height: 272
            anchors.centerIn: parent

            begin: 495
            end: 225

            strokeWidth: 8
            strokeColor: "#F5F7F7"
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
        // 21 ticks total
        // 0 through 100 MPH
        // One tick every 5 MPH
        // Major tick every 10 MPH
        // 270° / 20 intervals = 13.5° per 5 MPH
        // ==================================================
        Item {
            id: tickMarks

            width: 300
            height: 300
            anchors.centerIn: parent

            // 0 MPH
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

            // 5 MPH
            Item {
                width: 300
                height: 300
                rotation: -121.5

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#707070"
                }
            }

            // 10 MPH
            Item {
                width: 300
                height: 300
                rotation: -108

                Rectangle {
                    width: 3
                    height: 14
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#D0D0D0"
                }
            }

            // 15 MPH
            Item {
                width: 300
                height: 300
                rotation: -94.5

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#707070"
                }
            }

            // 20 MPH
            Item {
                width: 300
                height: 300
                rotation: -81

                Rectangle {
                    width: 3
                    height: 14
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#D0D0D0"
                }
            }

            // 25 MPH
            Item {
                width: 300
                height: 300
                rotation: -67.5

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#707070"
                }
            }

            // 30 MPH
            Item {
                width: 300
                height: 300
                rotation: -54

                Rectangle {
                    width: 3
                    height: 14
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#D0D0D0"
                }
            }

            // 35 MPH
            Item {
                width: 300
                height: 300
                rotation: -40.5

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#707070"
                }
            }

            // 40 MPH
            Item {
                width: 300
                height: 300
                rotation: -27

                Rectangle {
                    width: 3
                    height: 14
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#D0D0D0"
                }
            }

            // 45 MPH
            Item {
                width: 300
                height: 300
                rotation: -13.5

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#707070"
                }
            }

            // 50 MPH
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

            // 55 MPH
            Item {
                width: 300
                height: 300
                rotation: 13.5

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#707070"
                }
            }

            // 60 MPH
            Item {
                width: 300
                height: 300
                rotation: 27

                Rectangle {
                    width: 3
                    height: 14
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#D0D0D0"
                }
            }

            // 65 MPH
            Item {
                width: 300
                height: 300
                rotation: 40.5

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#707070"
                }
            }

            // 70 MPH
            Item {
                width: 300
                height: 300
                rotation: 54

                Rectangle {
                    width: 3
                    height: 14
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#D0D0D0"
                }
            }

            // 75 MPH
            Item {
                width: 300
                height: 300
                rotation: 67.5

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#707070"
                }
            }

            // 80 MPH
            Item {
                width: 300
                height: 300
                rotation: 81

                Rectangle {
                    width: 3
                    height: 14
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#D0D0D0"
                }
            }

            // 85 MPH
            Item {
                width: 300
                height: 300
                rotation: 94.5

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#707070"
                }
            }

            // 90 MPH
            Item {
                width: 300
                height: 300
                rotation: 108

                Rectangle {
                    width: 3
                    height: 14
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#D0D0D0"
                }
            }

            // 95 MPH
            Item {
                width: 300
                height: 300
                rotation: 121.5

                Rectangle {
                    width: 2
                    height: 8
                    y: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#707070"
                }
            }

            // 100 MPH
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
        // SPEED SCALE NUMBERS
        // Every 10 MPH
        // All labels follow the same circular radius
        // ==================================================

        // 0 MPH
        Text {
            text: "0"
            width: 32
            height: 20
            x: 61
            y: 215

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: "#FFFFFF"
            font.pixelSize: 12
            font.bold: true
        }

        // 10 MPH
        Text {
            text: "10"
            width: 32
            height: 20
            x: 36
            y: 171

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: "#FFFFFF"
            font.pixelSize: 12
            font.bold: true
        }

        // 20 MPH
        Text {
            text: "20"
            width: 32
            height: 20
            x: 34
            y: 124

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: "#FFFFFF"
            font.pixelSize: 12
            font.bold: true
        }

        // 30 MPH
        Text {
            text: "30"
            width: 32
            height: 20
            x: 53
            y: 78

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: "#FFFFFF"
            font.pixelSize: 12
            font.bold: true
        }

        // 40 MPH
        Text {
            text: "40"
            width: 32
            height: 20
            x: 87
            y: 49

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: "#FFFFFF"
            font.pixelSize: 12
            font.bold: true
        }

        // 50 MPH
        Text {
            text: "50"
            width: 32
            height: 20
            x: 134
            y: 37

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: "#FFFFFF"
            font.pixelSize: 12
            font.bold: true
        }

        // 60 MPH
        Text {
            text: "60"
            width: 32
            height: 20
            x: 181
            y: 49

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: "#FFFFFF"
            font.pixelSize: 12
            font.bold: true
        }

        // 70 MPH
        Text {
            text: "70"
            width: 32
            height: 20
            x: 216
            y: 80

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: "#FFFFFF"
            font.pixelSize: 12
            font.bold: true
        }

        // 80 MPH
        Text {
            text: "80"
            width: 32
            height: 20
            x: 233
            y: 123

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: "#FFFFFF"
            font.pixelSize: 12
            font.bold: true
        }

        // 90 MPH
        Text {
            text: "90"
            width: 32
            height: 20
            x: 230
            y: 172

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: "#FFFFFF"
            font.pixelSize: 12
            font.bold: true
        }

        // 100 MPH
        Text {
            text: "100"
            width: 36
            height: 20
            x: 201
            y: 210

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: "#FFFFFF"
            font.pixelSize: 12
            font.bold: true
        }

        // ==================================================
        // NEEDLE
        // 0 MPH   = -135°
        // 50 MPH  =    0°
        // 100 MPH = +135°
        // ==================================================
        Item {
            id: needleAssembly

            width: 300
            height: 300
            anchors.centerIn: parent

            rotation: -135 + (270 * Math.min(
                                  Math.max(root.speed, 0),
                                  root.maximumSpeed) / root.maximumSpeed)

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
        // CURRENT SPEED
        // ==================================================
        Text {
            id: speedValue

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: needleHubOuter.bottom
            anchors.topMargin: 41

            color: "#F5F5F5"
            text: Math.round(root.speed)

            font.pixelSize: 45
            anchors.horizontalCenterOffset: 0
            font.bold: true
        }

        // ==================================================
        // MPH LABEL
        // ==================================================
        Text {
            id: speedLabel
            y: 168

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: -45

            text: "MPH"

            color: "#909090"

            font.pixelSize: 12
            anchors.horizontalCenterOffset: 1
            font.bold: true
            font.letterSpacing: 3
        }
    }
}
