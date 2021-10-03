import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "qrc:/uix/components/appbars/" as AppBars
import "qrc:/uix/scripts/api/auth.mjs" as AuthApi
import "qrc:/uix/components/containers/" as AppContainers
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants
import "qrc:/uix/scripts/constants/color.mjs" as ColorConstants

AppContainers.Page {
    id: root
    header: AppBars.AppHeader{
        text: "Login"
    }

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 15
        spacing: 20

        ColumnLayout{
            spacing: 10

            Label{
                text: qsTr("Welcome Back")
                font.pixelSize: FontConstants.BANNER
                color: thememanager.text
            }

            Label{
                text: qsTr("Fill in your details to continue")
                font.pixelSize: FontConstants.NORMAL
                color: thememanager.text
            }
        }

        ColumnLayout{
            spacing: 20
        }
    }
}
