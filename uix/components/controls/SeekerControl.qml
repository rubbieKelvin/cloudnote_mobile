import QtQuick 2.15
import QtQuick.Controls 2.15

Slider {
    id: root
    from: 0
    to: 100
    height: 20

     background: Rectangle {
         x: root.leftPadding
         y: root.topPadding + root.availableHeight / 2 - height / 2
         implicitWidth: 200
         implicitHeight: 2
         width: root.availableWidth
         height: implicitHeight
         radius: 2
         color: thememanager.stroke

         Rectangle {
             width: root.visualPosition * parent.width
             height: parent.height
             color: thememanager.accent
             radius: 2
         }
     }

     handle: Rectangle {
         x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
         y: root.topPadding + root.availableHeight / 2 - height / 2
         implicitWidth: root.pressed ? 20 : 10
         implicitHeight: root.pressed ? 20 : 10
         radius: 10
         color: thememanager.accent
         border.color: thememanager.background
         border.width: 1
     }
}
