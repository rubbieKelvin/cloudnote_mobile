import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import "qrc:/uix/scripts/app/main.mjs" as AppMain
import "qrc:/uix/components/appbars/" as AppBars
import "qrc:/uix/components/containers/" as AppContainers
import "qrc:/uix/components/controls/" as AppControls
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants
import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/scripts/frozen/icon.js" as Icons


AppContainers.Page{
    id: root
    header: AppBars.AppHeader{
        text: "Now Playing"
        font.pixelSize: FontConstants.LARGE
        rightButton.visible: true
        rightButton.display: AbstractButton.IconOnly
        rightButton.icon.source: Svg.fromString(Icons.ICON_COOLICONS_MENU_MORE_VERTICAL, {
            color: thememanager.textUnimportant
        })

        onRightButtonClicked: {
            console.log("more button clicked")
        }
    }

    ColumnLayout{
        anchors.fill: parent
        anchors.bottomMargin: (rl.flow === rl.portraitLayout) ? 50 : 24

        Rectangle{
            Layout.fillWidth: true
            height: 1
            Layout.preferredHeight: height
            color: thememanager.stroke
        }

        AppContainers.ResponsiveLayout{
            id: rl
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            columnSpacing: 20
            rowSpacing: 20

            Item{
                Layout.fillWidth: true
                Layout.fillHeight: true

                AppControls.RoundImage{
                    radius: 8
                    anchors.centerIn: parent
                    source: AppMain.randomDummyImage()
                    width: parent.width
                    height: Math.min(((rl.flow === rl.portraitLayout) ? parent.width : parent.height), parent.height)
                }
            }

            AppControls.MediaPlayerControl{
                Layout.fillWidth: true
                Layout.fillHeight: (rl.flow === rl.portraitLayout) ? false : true
                Layout.maximumWidth: Math.min(application.height, application.width)
            }
        }
    }
}
