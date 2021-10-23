import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/scripts/frozen/icon.js" as Icons
import "qrc:/uix/components/controls" as AppControls
import "qrc:/uix/components/containers" as AppContainers

Rectangle {
    id: root
    color: thememanager.background

    property int currentIndex: 0

    readonly property var navlist: [
        {title: "Explore", icon: Icons.ICON_ICONLY_LIGHT_HOME},
        {title: "Library", icon: Icons.ICON_ICONLY_LIGHT_CHART},
        {title: "Me", icon: Icons.ICON_ICONLY_LIGHT_PROFILE}
    ]
    signal clicked(int index)

    RowLayout{
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        anchors.topMargin: 10
        anchors.bottomMargin: 10

        Repeater{
            id: repeater
            model: navlist

            AppControls.RippleArea{
                Layout.fillWidth: true
                Layout.fillHeight: true

                AppContainers.ResponsiveLayout{
                    anchors.fill: parent
                    columnSpacing: 8
                    rowSpacing: 8

                    Image{
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        source: Svg.fromString(modelData.icon, {
                            color: (index === currentIndex) ? thememanager.accent : thememanager.text
                        })
                        width: 30
                        height: 30
                    }

                    Label{
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        text: modelData.title
                        color: (index === currentIndex) ? thememanager.accent : thememanager.text
                    }
                }

                onClicked: root.clicked(index)
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
