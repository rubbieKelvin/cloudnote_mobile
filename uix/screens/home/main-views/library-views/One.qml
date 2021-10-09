import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.13

import "qrc:/uix/components/delegates" as AppDelegates
import "qrc:/uix/scripts/constants/routes.js" as Routes

Base {
    id: root
    title: "playlist name"

    ListView{
        id: list_view
        clip: true
        model: 15
        delegate: AppDelegates.PlayListItemDelegate{
            width: list_view.width
            bottomStroke.visible: index !== (list_view.count-1)

            onClicked: {
                mainstack.push(Routes.NOW_PLAYING)
            }
        }
        boundsMovement: Flickable.StopAtBounds
        boundsBehavior: Flickable.StopAtBounds
        anchors.fill: parent
        anchors.topMargin: 20
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        anchors.bottomMargin: 5
        footer: Item {height: 15}
    }
}
