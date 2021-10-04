import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "qrc:/uix/components/appbars/" as AppBars
import "qrc:/uix/scripts/api/auth.mjs" as AuthApi
import "qrc:/uix/components/containers/" as AppContainers
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants
import "qrc:/uix/components/controls/" as AppControls
import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/scripts/frozen/icon.js" as Icons
import "qrc:/uix/scripts/constants/routes.js" as Routes
import "qrc:/uix/components/sections/" as AppSections

AppContainers.Page {
    id: root
    header: AppContainers.ResponsiveLayout{
        columnSpacing: 2
        rowSpacing: 15

        RowLayout{
            spacing: 10
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.topMargin: application.portrait ? 0 : 10
            Layout.fillWidth: false

            Image {
                source: Svg.fromString(Icons.ICON_ICONLY_BULK_ACTIVITY, {
                    color: thememanager.accent
                })
            }

            Label{
                color: thememanager.text
                font.pixelSize: FontConstants.XLARGE
                text: "Explore"
                Layout.fillWidth: true
            }
        }

        AppControls.SearchField{
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.topMargin: application.portrait ? 0 : 10
            Layout.fillWidth: true
            Layout.preferredHeight: 50
        }
    }

    function handleBackPressed(event){
        event.accepted = true
    }

    ListView{
        id: list
        anchors.topMargin: 15
        anchors.bottomMargin: 15
        anchors.fill: parent
        spacing: 20
        clip: true
        model: 6
        delegate: AppSections.PlaylistCardScrollView{
            height: 300
            width: list.width
        }
        footer: Item{
            height: 15
        }
    }

}
