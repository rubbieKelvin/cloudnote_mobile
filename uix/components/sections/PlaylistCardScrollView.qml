import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import "qrc:/uix/components/delegates/" as AppDelegate
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants

ColumnLayout{
    id: root
    property string heading: "Heading"

    Label{
        text: heading
        font.pixelSize: FontConstants.HEADING
        color: thememanager.text
        font.weight: Font.Medium
        Layout.fillWidth: true
        Layout.leftMargin: 15
        Layout.rightMargin: 15
        Layout.topMargin: 15
    }

    ListView{
        boundsMovement: Flickable.StopAtBounds
        boundsBehavior: Flickable.StopAtBounds
        model: 10
        spacing: 10
        Layout.preferredHeight: 270
        Layout.leftMargin: 15
        Layout.fillHeight: true
        Layout.fillWidth: true
        orientation: ListView.Horizontal
        delegate: AppDelegate.PlayListCard{
            height: 300
            width: 300
        }
        footer: Item{
            width: 15
        }
    }
}
