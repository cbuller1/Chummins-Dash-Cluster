import QtQuick
import QtQuick.Studio.Components 1.0

Item {
    id: root

    property bool active: false

    width: 42
    height: 28

    // Arrow shaft
    Rectangle {
        id: arrowShaft

        x: 3
        y: 11

        width: 27
        height: 6

        radius: 1

        opacity: root.active ? 1.0 : 0.22

        color: root.active ? "#48D978" : "#707070"
    }

    // Arrow head
    Item {
        id: arrowHead

        x: 22
        y: 2

        width: 20
        height: 24

        opacity: root.active ? 1.0 : 0.22

        Rectangle {
            width: 17
            height: 6

            x: 1
            y: 5

            rotation: 45

            color: root.active ? "#48D978" : "#707070"
        }

        Rectangle {
            width: 17
            height: 6

            x: 1
            y: 13

            rotation: -45

            color: root.active ? "#48D978" : "#707070"
        }
    }
}
