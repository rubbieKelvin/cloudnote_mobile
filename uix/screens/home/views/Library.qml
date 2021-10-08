import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants

BaseView {
    id: root
    metaTitle: "My Library"

    ColumnLayout{
        width: parent.width
        y: 15

        Label{
            text: qsTr("Albums")
            font.pixelSize: FontConstants.HEADING
            color: thememanager.text
            Layout.fillWidth: true
        }

        ListView{
            id: album_list_view
            anchors.topMargin: 15
            anchors.bottomMargin: 5
            spacing: 15
            clip: true
            model: 15
            orientation: ListView.Horizontal
            boundsMovement: Flickable.StopAtBounds
            boundsBehavior: Flickable.StopAtBounds
            Layout.preferredHeight: 70
            footer: Item {
                width: 15
            }
        }
    }
}
