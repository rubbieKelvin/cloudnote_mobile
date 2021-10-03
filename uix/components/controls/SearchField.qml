import QtQuick 2.15
import QtQuick.Controls 2.15 as T
import QtQuick.Layouts 1.3
import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/scripts/frozen/icon.js" as Icons
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants

T.TextField{
    id: root
    Layout.preferredHeight: 50
    Layout.fillWidth: true
    placeholderText: "Search..."
    color: thememanager.text
    placeholderTextColor: thememanager.placeholder

    property string fieldBackgroundColor: "#00000000"

    background: Rectangle{
        radius: 8
        border.width: root.focus ? 2 : 1
        border.color: root.focus ? thememanager.accent : thememanager.stroke
        color: root.fieldBackgroundColor

        Image{
            id: icon
            x: 10
            width: 30
            height: 30
            source: Svg.fromString(Icons.ICON_ICONLY_LIGHT_SEARCH, {
                color: root.focus ? thememanager.accent : thememanager.text
            })
            visible: true
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    leftPadding: icon.x+icon.width+10
    rightPadding: 10
}
