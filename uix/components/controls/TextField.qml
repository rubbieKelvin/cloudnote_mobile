import QtQuick 2.15
import QtQuick.Controls 2.15 as T
import QtQuick.Layouts 1.3
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants

ColumnLayout{
    id: root
    spacing: 2

    property alias field: field
    property string label: "Enter a text"
    property string fieldBackgroundColor: "#00000000"
    property int fieldRadius: 8
    property alias leftButton: leftButton
    property alias rightButton: rightButton

    T.Label{
        Layout.fillWidth: true
        text: root.label
        font.pixelSize: FontConstants.HELP
        color: thememanager.text
        leftPadding: 5
    }

    T.TextField{
        id: field
        Layout.preferredHeight: 50
        Layout.fillWidth: true
        placeholderText: root.label
        color: thememanager.text
        placeholderTextColor: thememanager.placeholder

        background: Rectangle{
            radius: root.fieldRadius
            border.width: field.focus ? 2 : 1
            border.color: field.focus ? thememanager.accent : thememanager.stroke
            color: root.fieldBackgroundColor

            Button{
                id: leftButton
                x: 10
                width: 30
                height: 30
                borderRadius: 15
                backgroundColor: "#00000000"
                display: T.AbstractButton.IconOnly
                visible: false
                enabled: false
                anchors.verticalCenter: parent.verticalCenter
            }

            Button{
                id: rightButton
                anchors.right: parent.right
                anchors.rightMargin: 10
                width: 30
                height: 30
                borderRadius: 15
                backgroundColor: "#00000000"
                display: T.AbstractButton.IconOnly
                visible: false
                enabled: false
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        leftPadding: leftButton.visible ? leftButton.x+leftButton.width+10 : 10
        rightPadding: rightButton.visible ? 50 : 10
    }
}
