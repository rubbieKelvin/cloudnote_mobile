import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import "qrc:/uix/scripts/app/main.mjs" as AppMain
import "qrc:/uix/components/controls" as AppControls
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstant

Rectangle {
    id: root
    color: thememanager.background
    border.width: 1
    border.color: thememanager.stroke
    radius: 8
    height: row.height + 16
    width: row.width + 16

    signal clicked

    RowLayout{
        id: row
        x: 8
        y: 8
        anchors.margins: 8
        spacing: 10

        AppControls.RoundImage{
            source: AppMain.randomDummyImage()
            height: 42
            width: 42
            radius: 8
            Layout.preferredHeight: height
            Layout.preferredWidth: width
            fillMode: Image.PreserveAspectCrop

        }

        ColumnLayout{
            Layout.fillWidth: true

            Label{
                text: "Album Name"
                Layout.fillWidth: true
            }

            Label{
                text: "artist name"
                Layout.fillWidth: true
                color: thememanager.textUnimportant
                font.pixelSize: FontConstant.SUBTEXT
            }
        }
    }

    AppControls.RippleArea{
        anchors.fill: parent
        clipRadius: parent.radius
        onClicked: root.clicked()
    }
}
