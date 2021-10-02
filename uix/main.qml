import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.0

import "qrc:/uix/components/interface/" as AppInterface
import "qrc:/uix/scripts/constants/routes.mjs" as Routes
import "qrc:/uix/components/containers/" as AppContainers
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants

ApplicationWindow {
    id: application
    width: 300
    height: 550
    visible: true
    flags: Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
    font.family: fontmananger.fontRegular
    font.pixelSize: FontConstants.NORMAL

    Settings{
        fileName: "set.ini"
        property int theme: thememanager.theme
    }

    AppInterface.ThemeManager {
        id: thememanager
    }

    AppInterface.FontManager{
        id: fontmananger
    }

    AppContainers.StackView {
        id: mainstack
        anchors.fill: parent
    }

    Component.onCompleted: {
        // just got to splash screen
        mainstack.push(Routes.AUTHSPLASH)
    }
}
