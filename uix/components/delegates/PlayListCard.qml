import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.13
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants

Rectangle{
    id: root
    radius: 12
    width: 270
    height: 270
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

    property string image: "qrc:/uix/assets/images/dummy/dummy-1.png"
    property string title: "Playlist Name"
    property string subtitle: "Artist Name"
    property string info: "x songs"

    ColumnLayout{
        id: col
        anchors.fill: parent
        spacing: 0

        Image{
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 220
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
}
