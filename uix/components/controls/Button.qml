import QtQuick 2.15
import QtQuick.Controls 2.15 as T
import QtQuick.Layouts 1.3

T.Button{
    id: root
    height: 50
    width: {
        if (t_label.visible){
            return t_label.width + 10
        }else if (t_icon.visible){
            return t_icon.width + 10
        }else{
            return 70
        }
    }
    text: qsTr("Button")
    display: T.AbstractButton.TextOnly

    background: Rectangle{
        color: root.down ? backgroundDownColor : backgroundColor
        radius: borderRadius
        border.width: borderWidth
        border.color: borderColor

        RippleArea{
            id: ripplearea
            focus: true
            anchors.fill: parent

            onPressed: {
                root.focus = true
            }

            onClicked: {
                root.clicked()
                root.focus = true
            }
            clipRadius: parent.radius
        }
    }

    contentItem: Item{
        RowLayout{
            anchors.centerIn: parent
            spacing: root.spacing
            
            Image{
                id: t_icon
                source: root.icon.source
                height: root.icon.height
                width: root.icon.width
                visible: root.display === T.AbstractButton.TextBesideIcon || root.display === T.AbstractButton.IconOnly || root.display === T.AbstractButton.TextUnderIcon
            }
            
            T.Label{
                id: t_label
                visible: root.display === T.AbstractButton.TextOnly || root.display ===T.AbstractButton.TextBesideIcon || root.display === T.AbstractButton.TextUnderIcon
                text: root.text
                font: root.font
                color: root.down ? foregroundDownColor : foregroundColor
                opacity: enabled ? 1.0 : 0.3
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }
    }

    property alias mouse: ripplearea
    property int borderRadius: 8
    property string foregroundColor: "#000000"
    property string backgroundColor: "#bdbdbd"
    property string backgroundDownColor: backgroundColor
    property string foregroundDownColor: foregroundColor
    property string borderColor: thememanager.stroke
    property int borderWidth: 0
}
