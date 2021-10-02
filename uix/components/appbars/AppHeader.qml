import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/scripts/frozen/icon.js" as Icons

Rectangle{
    id: root
    height: 60

    RowLayout{
        spacing: 20
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 15

        Image{
            source: Svg.fromString(Icons.ICON_COOLICONS_ARROW_SHORT_LEFT, {
                color: "red"
            })
        }
    }
}
