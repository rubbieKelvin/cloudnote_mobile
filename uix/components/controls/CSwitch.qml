import QtQuick 2.15
import QtQuick.Controls 2.15

Switch {
    id: root
    visible: true
    indicator: Rectangle {
        implicitWidth: 40
        implicitHeight: 20

        x: root.leftPadding
        y: (parent.height/2) - (height/2)

        radius: (height/2)
        color: root.checked ? thememanager.accent15 : thememanager.stroke

        Rectangle {
            id: handle
            x: root.checked ? (parent.width - width) : 0
            width: parent.height
            height: parent.height
            radius: parent.radius
            color: root.checked ? thememanager.accent : thememanager.placeholder

            Behavior on x {
                NumberAnimation{
                    duration: 100
                }
            }
        }

    }
}
