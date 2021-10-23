import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.3

Popup{
    id: root
    padding: 0
    dim: false
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    property Component popupContent
    background: Rectangle{
        radius: 8
        anchors.fill: parent
        anchors.topMargin: -radius
        anchors.bottomMargin: -radius
        color: thememanager.background
        layer.enabled: true
        layer.effect: DropShadow{
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            color: thememanager.shadow
            radius: 8
            spread: 0
        }
    }

    Loader{
        width: parent.width
        sourceComponent: popupContent
    }
}
