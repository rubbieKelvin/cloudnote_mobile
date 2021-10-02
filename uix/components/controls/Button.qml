import QtQuick 2.15
import QtQuick.Controls 2.15 as T

T.Button{
    id: root
    height: 50
    text: qsTr("Button")

    background: Rectangle{
        color: root.down ? backgroundDownColor : backgroundColor
        radius: borderRadius

        Rectangle{
            anchors.fill: parent
            color: "black"
            opacity: .1
            radius: parent.radius
            visible: root.down && (root.backgroundColor === root.backgroundDownColor)
        }
    }

    contentItem: T.Label{
        text: root.text
        font: root.font
        color: root.down ? foregroundDownColor : foregroundColor
        opacity: enabled ? 1.0 : 0.3
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    property int borderRadius: 8
    property string foregroundColor: "#000000"
    property string backgroundColor: "#bdbdbd"
    property string backgroundDownColor: backgroundColor
    property string foregroundDownColor: foregroundColor
}
