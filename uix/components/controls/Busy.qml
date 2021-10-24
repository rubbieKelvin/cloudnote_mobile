import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.13

Rectangle{
    id: root
    width: 20
    height: 30
    color: "#00000000"
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    visible: running
    property bool running: false
    property string budColor: thememanager.text

    onRunningChanged: {
        if(visible) return anim.restart()
        anim.stop()
    }

    RowLayout {
        anchors.fill: parent

        Rectangle{
            id: bud
            radius: 2
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 4
            Layout.preferredWidth: 4
            color: budColor
            opacity: 0
        }

        Rectangle{
            id: bud_2
            radius: 2
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 4
            Layout.preferredWidth: 4
            color: budColor
            opacity: 0
        }

        Rectangle{
            id: bud_3
            radius: 2
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 4
            Layout.preferredWidth: 4
            color: budColor
            opacity: 1
        }
    }

    SequentialAnimation{
        id: anim
        loops: -1
        property int _delay_int: 200

        ParallelAnimation{
            NumberAnimation {
                target: bud
                easing.type: Easing.InQuad
                properties: "opacity"
                duration: anim._delay_int
                from: 0
                to: 1
            }

            NumberAnimation {
                target: bud_3
                property: "opacity"
                duration: anim._delay_int
                easing.type: Easing.InQuad
                from: 1
                to: 0
            }
        }
        ParallelAnimation{
            NumberAnimation {
                target: bud_2
                easing.type: Easing.InQuad
                properties: "opacity"
                duration: anim._delay_int
                from: 0
                to: 1
            }

            NumberAnimation {
                target: bud
                property: "opacity"
                duration: anim._delay_int
                easing.type: Easing.InQuad
                from: 1
                to: 0
            }
        }
        ParallelAnimation{
            NumberAnimation {
                target: bud_3
                easing.type: Easing.InQuad
                properties: "opacity"
                duration: anim._delay_int
                from: 0
                to: 1
            }

            NumberAnimation {
                target: bud_2
                property: "opacity"
                duration: anim._delay_int
                easing.type: Easing.InQuad
                from: 1
                to: 0
            }
        }
    }
}
