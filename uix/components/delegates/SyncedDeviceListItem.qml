import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.13
import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants
import "qrc:/uix/scripts/frozen/icon.js" as Icons

Rectangle{
    id: root
    width: 300
    height: 60
    color: thememanager.background

    RowLayout{
        anchors.fill: parent
        anchors.leftMargin: 25
        anchors.rightMargin: 25
        spacing: 20

        Image{
            Layout.preferredHeight: 24
            Layout.preferredWidth: 24
            source: Svg.fromString(Icons.ICON_COOLICONS_DEVICE_LAPTOP, {
                color: thememanager.text
            })
        }

        ColumnLayout{
            spacing: 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            Label{
                text: "rubbie.fedora"
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: thememanager.text
                verticalAlignment: Text.AlignBottom
            }

            Label{
                verticalAlignment: Text.AlignTop
                text: "linux"
                Layout.fillWidth: true
                Layout.fillHeight: true
                font.pixelSize: FontConstants.SUBTEXT
                color: thememanager.textUnimportant
            }
        }

        Label{
            text: "connected"
            font.pixelSize: FontConstants.SUBTEXT
            color: thememanager.accent
        }
    }
}
