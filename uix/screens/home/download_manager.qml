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
import "qrc:/uix/components/popup/" as AppPopups

AppContainers.Page{
    id: root
    header: AppBars.AppHeader{
        text: "Downloads"
        font.pixelSize: FontConstants.LARGE
        leftButtonSource: Svg.fromString(Icons.ICON_COOLICONS_ARROW_CHEVRON_LEFT, {
            color: thememanager.text
        })
    }
}
