import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "qrc:/uix/components/sections/" as AppSections

BaseView {
    id: root
    metaUsesSearchBar: true
    metaTitle: "Explore"

    ListView{
        id: list
        anchors.topMargin: 15
        anchors.bottomMargin: 5
        anchors.fill: parent
        spacing: 20
        clip: true
        model: 6
        boundsMovement: Flickable.StopAtBounds
        boundsBehavior: Flickable.StopAtBounds
        delegate: AppSections.PlaylistCardScrollView{
            height: 350
            width: list.width
        }
        footer: Item{
            height: 10
        }
    }
}
