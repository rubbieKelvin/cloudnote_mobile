import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants


Popup{
    id: root
    dim: true
    parent: Overlay.overlay
    
    property bool fillScreen: false
    property int fillOffset: 25
    property string title: qsTr("Bottom Sheet")
    property Component sheetContent

    height: fillScreen ? application.height-fillOffset : col.height

    enter: Transition {
        NumberAnimation { property: "y"; from: application.height; to: fillScreen ? application.height-root.height : application.height-col.height}
    }

    exit: Transition {
        NumberAnimation { property: "y"; from: root.y; to: application.height}
    }

    background: Rectangle{
        radius: 16
        anchors.fill: parent
        anchors.bottomMargin: -radius
        color: thememanager.background
    }

    ColumnLayout{
        id: col
        spacing: 10
        width: parent.width

        Rectangle{
            width: 32
            height: 4
            radius: 4
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            color:  thememanager.handles

            MouseArea{
                anchors.margins: -4
                anchors.fill: parent
                onClicked: root.close()
            }
        }

        Label {
            text: root.title
            font.weight: Font.Medium
            font.pixelSize: FontConstants.HEADING
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: thememanager.text
            Layout.fillWidth: true
        }

        Loader{
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            sourceComponent: sheetContent
        }

        // spacing
        Item{height: 30}
    }
}
