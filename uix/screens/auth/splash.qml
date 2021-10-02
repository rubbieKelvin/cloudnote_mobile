import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import "qrc:/uix/components/controls/" as AppControls
import "qrc:/uix/components/containers/" as AppContainers
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants

AppContainers.Page{
    id: root

    ColumnLayout{
        anchors.verticalCenterOffset: -root.height * .086
        spacing: 0
        anchors.centerIn: parent

        Label{
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "CloudNote."
            font.pixelSize: 36
            color: thememanager.text
        }

        Label{
            Layout.fillWidth: true
            text: "stuffsbyrubbie"
            color: thememanager.textUnimportant
            font.pixelSize: FontConstants.SUBTEXT
        }
    }

    ColumnLayout{
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        spacing: 12

        AppControls.Button{
            text: "Login"
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            foregroundColor: thememanager.accent
            backgroundColor: thememanager.accent15
        }

        AppControls.Button{
            text: "SignUp"
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            foregroundColor: thememanager.text
            backgroundColor: thememanager.accent
        }
    }
}
