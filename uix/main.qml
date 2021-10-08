import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.0
import StuffsByRubbie 0.1
import "qrc:/uix/scripts/app/main.mjs" as App
import "qrc:/uix/components/interface/" as AppInterface
import "qrc:/uix/scripts/constants/routes.js" as Routes
import "qrc:/uix/components/containers/" as AppContainers
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants

ApplicationWindow {
    id: application
    
    // portrait
    width: 340
    height: 610

    // landscape
    // width: 550
    // height: 300

    visible: true
    flags: Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
    font.family: fontmanager.fontRegular
    font.pixelSize: FontConstants.NORMAL

    readonly property bool portrait: height > width
    readonly property bool landscape: height < width

    StatusBar{
        id: statusbar
    }

    Settings{
        id: themesettings
        fileName: "set.ini"
        property int theme: thememanager.theme
    }

    AppInterface.ThemeManager {
        id: thememanager
    }

    AppInterface.FontManager{
        id: fontmanager
    }

    AppContainers.StackView {
        id: mainstack
        anchors.fill: parent
    }

    Component.onCompleted: {
        // just got to splash screen
        mainstack.push(Routes.AUTHSPLASH)
    }

    Connections{
        target: application
        function onClosing(event){
            if (App.isMobileDevice()){
                event.accepted = false
                mainstack.handleBackPressed(event)
            }
        }
    }
}
