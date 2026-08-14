import QtQuick
import QtQuick.Studio.Components 1.0

Item {
    id: root

    // ==============================
    // PUBLIC PROPERTIES
    // ==============================
    property real speed: 50
    property real maximumSpeed: 100

    // ==============================
    // COMPLETE GAUGE SIZE
    // Same as tachometer
    // ==============================
    width: 360
    height: 360

    // ==============================
    // GAUGE CONTENT
    // Original gauge remains 300x300
    // ==============================
    Item {
        id: gaugeContent

        width: 300
        height: 300
        anchors.centerIn: parent

        // ==========================
        // GAUGE FACE / BEZEL
        // Same positioning as tach
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
        // GAUGE FACE
        // ==========================
        Rectangle {
            id: gaugeFace

            width: 292
            height: 292
            anchors.centerIn: parent

            radius: 146

            // AUTOMETER WHITE FACE
            color: "#F2F1EC"

            border.width: 10
            border.color: "#92928F"
        }

        // ==================================================
        // OUTER SPEED SCALE BAND
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
            strokeColor: "#343434"
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
            strokeColor: "#A0A09C"
            fillColor: "transparent"
        }

        // ==================================================
        // TICK MARKS
        // 21 ticks total
        // 0 through 100 MPH
        // One tick every 5 MPH
        // Major tick every 10 MPH
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
                    color: "#202020"
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
                    color: "#606060"
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
                    color: "#202020"
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
                    color: "#606060"
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
                    color: "#202020"
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
                    color: "#606060"
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
                    color: "#202020"
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
                    color: "#606060"
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
                    color: "#202020"
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
                    color: "#606060"
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
                    color: "#202020"
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
                    color: "#606060"
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
                    color: "#202020"
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
                    color: "#606060"
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
                    color: "#202020"
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
                    color: "#606060"
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
                    color: "#202020"
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
                    color: "#606060"
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
                    color: "#202020"
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
                    color: "#606060"
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
                    color: "#202020"
                }
            }
        }

        // ==================================================
        // SPEED SCALE NUMBERS
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

            color: "#181818"

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

            color: "#181818"

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

            color: "#181818"

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

            color: "#181818"

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

            color: "#181818"

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

            color: "#181818"

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

            color: "#181818"

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

            color: "#181818"

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

            color: "#181818"

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

            color: "#181818"

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

            color: "#181818"

            font.pixelSize: 12
            font.bold: true
        }

        // ==================================================
        // NEEDLE
        // 0 MPH   = -135°
        // 50 MPH  =    0°
        // 100 MPH = +135°
        // ==================================================
        Text {
            id: gaugeBrand
            y: 97
            color: "#000000"
            text: "K/30"
            font.family: "Roboto Condensed"
            font.pixelSize: 16
            font.weight: Font.Bold
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 1.2
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
        }

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

                width: 8
                height: 149

                anchors.horizontalCenter: parent.horizontalCenter

                y: 27

                radius: 6

                color: "#FF4500"
            }
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
            border.color: "#606060"
        }
        Rectangle {
            id: needleHubInner

            width: 6
            height: 6

            anchors.centerIn: parent

            radius: 4

            color: "#000000"

            border.width: 0
            border.color: "#3D3D3B"
        }

        // ==================================================
        // CURRENT SPEED
        // ==================================================
        Text {
            id: speedValue

            anchors.horizontalCenter: parent.horizontalCenter

            anchors.top: needleHubOuter.bottom
            anchors.topMargin: 34

            text: Math.round(root.speed)

            color: "#181818"

            font.pixelSize: 45
            font.bold: true

            anchors.horizontalCenterOffset: -1
        }

        OverdriveStatus {
            id: overdriveStatus
            x: 129
            y: 252
            active: backend.overdriveActive
        }

        // ==================================================
        // MPH LABEL
        // ==================================================
        Text {
            id: speedLabel

            y: 176

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: -45

            text: "MPH"

            color: "#000000"

            font.pixelSize: 12
            font.bold: true
            font.letterSpacing: 3

            anchors.horizontalCenterOffset: 1
        }
    }
}
