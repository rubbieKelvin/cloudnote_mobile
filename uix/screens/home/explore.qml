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

AppContainers.Page {
    id: root
    header: Rectangle{
        height: 60

        RowLayout{
            spacing: 10
            anchors.fill: parent
            anchors.margins: 15

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
    }

    function handleBackPressed(event){
        event.accepted = true
    }

    RowLayout{
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 15

        AppControls.SearchField{
            Layout.fillWidth: true
            Layout.preferredHeight: 50
        }
    }
}
