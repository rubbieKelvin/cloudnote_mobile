import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/scripts/frozen/icon.js" as Icons
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstant
import "qrc:/uix/components/controls/" as AppControls

Rectangle{
    id: root
    height: 60
    property string text: qsTr("StuffsbyRubbie")

    RowLayout{
        spacing: 20
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 15

        AppControls.Button{
            Layout.preferredWidth: 30
            Layout.preferredHeight: 30
            display: AbstractButton.IconOnly
            backgroundColor: "#00000000"
            borderRadius: 15
            icon.source: Svg.fromString(Icons.ICON_COOLICONS_ARROW_SHORT_LEFT, {
                color: thememanager.text
            })

            onClicked: {
                if (mainstack.depth > 1){
                    mainstack.pop()
                }else{
                    Qt.quit()
                }
            }
        }

        Label{
            text: root.text
            color: thememanager.text
            font.pixelSize: FontConstant.HEADING
            Layout.fillWidth: true
        }
    }
}
