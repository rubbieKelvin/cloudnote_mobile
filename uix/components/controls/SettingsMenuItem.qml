import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants

Rectangle{
    id: root
    height: col.height
    color: thememanager.background

    property string title: "Title"
    property string subtitle: "subtitle"
    property bool rippleAreaEnabled: true
    property Component widget

    signal clicked

    RippleArea{
        enabled: rippleAreaEnabled
        anchors.fill: parent
        onClicked: root.clicked()
    }

    ColumnLayout {
        id: col
        spacing: 4
        width: parent.width

        RowLayout{
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            spacing: 20

            ColumnLayout{
                spacing: 0
                Layout.fillWidth: true
                Layout.fillHeight: true

                Label{
                    text: title
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    verticalAlignment: Text.AlignBottom
                    color: thememanager.text
                }

                Label{
                    text: subtitle
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    verticalAlignment: Text.AlignTop
                    font.pixelSize: FontConstants.SUBTEXT
                    color: thememanager.textUnimportant
                }
            }

            Loader{
                Layout.fillWidth: false
                Layout.fillHeight: true
                sourceComponent: widget
            }
        }

        Rectangle{
            Layout.preferredHeight: 1
            Layout.fillWidth: true
            color: thememanager.stroke
        }
    }
}
