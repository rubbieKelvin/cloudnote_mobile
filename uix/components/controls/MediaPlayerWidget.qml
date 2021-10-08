import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/scripts/frozen/icon.js" as Icons
import "qrc:/uix/scripts/app/main.mjs" as AppMain
import "qrc:/uix/components/controls" as AppControls
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants


RowLayout {
    id: root
    spacing: 20

    Image{
        source: AppMain.randomDummyImage()
        fillMode: Image.PreserveAspectCrop
        Layout.preferredHeight: 56
        Layout.preferredWidth: 56
    }

    ColumnLayout{
        Layout.fillWidth: true
        Layout.fillHeight: true

        Label{
            text: "Song Name"
            Layout.fillWidth: true
            color: thememanager.text
            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
        }

        Label{
            text: "Artist, Album"
            Layout.fillWidth: true
            color: thememanager.textUnimportant
            font.pixelSize: FontConstants.SUBTEXT
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
        }
    }

    Item{
        Layout.preferredHeight: 56
        Layout.preferredWidth: 56

        AppControls.Button{
            borderRadius: 0
            backgroundColor: "transparent"
            anchors.fill: parent
            display: AbstractButton.IconOnly
            icon.height: 30
            icon.width: 30
            icon.source: Svg.fromString(Icons.ICON_ICONLY_LIGHT_PLAY, {
                color: thememanager.accent
            })
        }
    }

}
