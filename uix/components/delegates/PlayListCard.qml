import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.13

import "qrc:/uix/scripts/app/main.mjs" as AppMain
import "qrc:/uix/components/controls/" as AppControls
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants


Rectangle{
    id: root
    radius: 8
    width: 300
    height: 300
    color: thememanager.background
    border.width: 1
    border.color: thememanager.stroke
    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Item {
            width: root.width
            height: root.height

            Rectangle {
                anchors.centerIn: parent
                width: root.width
                height: root.height
                radius: root.radius
            }
        }
    }

    property string image: AppMain.randomDummyImage()
    property string title: "Playlist Name"
    property string subtitle: "Artist Name"
    property string info: "x songs"

    signal clicked

    ColumnLayout{
        id: col
        anchors.fill: parent
        spacing: 0

        Image{
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 250
            source: image
            fillMode: Image.PreserveAspectCrop
        }

        Item{
            Layout.fillWidth: true
            Layout.preferredHeight: 50

            RowLayout{
                anchors.fill: parent
                anchors.margins: 7
                spacing: 4

                ColumnLayout{
                    spacing: 0
                    Layout.fillWidth: true

                    Label{
                        text: root.title
                        Layout.fillWidth: true
                        color: thememanager.text
                    }

                    Label{
                        text: root.subtitle
                        color: thememanager.text
                        font.pixelSize: FontConstants.SUBTEXT
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.fillWidth: true
                    }
                }

                Label{
                    text: root.info
                    color: thememanager.textUnimportant
                    font.pixelSize: FontConstants.SMALL
                    Layout.fillWidth: false
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                }
            }
        }
    }

    AppControls.RippleArea{
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
