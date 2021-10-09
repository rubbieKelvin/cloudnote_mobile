import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.13

import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants
import "qrc:/uix/components/delegates" as AppDelegates

Base {
    id: root

    function goInPlaylistPage(){
        library_stack.push("qrc:/uix/screens/home/main-views/library-views/One.qml")
        library_screen.setHistory(library_stack, null)
    }

    ColumnLayout{
        anchors.fill: parent
        anchors.topMargin: 20
        spacing: 25

        ColumnLayout{
            spacing: 10
            Layout.fillWidth: true

            Label{
                text: qsTr("Albums")
                font.pixelSize: FontConstants.HEADING
                color: thememanager.text
                Layout.fillWidth: true
                Layout.leftMargin: 15
                Layout.rightMargin: 15
            }

            ListView{
                id: album_list_view
                spacing: 15
                clip: true
                model: 15
                delegate: AppDelegates.AlbumItemDelegate{
                    onClicked: goInPlaylistPage()
                }
                orientation: ListView.Horizontal
                boundsMovement: Flickable.StopAtBounds
                boundsBehavior: Flickable.StopAtBounds
                Layout.preferredHeight: 58
                Layout.fillWidth: true
                header: Item{width: 15}
                footer: Item{width: 15}
            }
        }

        ColumnLayout{
            spacing: 10
            Layout.fillHeight: true
            Layout.fillWidth: true

            Label{
                text: qsTr("Playlists")
                font.pixelSize: FontConstants.HEADING
                color: thememanager.text
                Layout.fillWidth: true
                Layout.leftMargin: 15
                Layout.rightMargin: 15
            }

            ListView{
                id: play_list_view
                clip: true
                model: 15
                delegate: AppDelegates.PlayListItemDelegate{
                    width: play_list_view.width
                    imageSource: ""
                    bottomStroke.visible: index !== (play_list_view.count-1)

                    onClicked: goInPlaylistPage()
                }
                boundsMovement: Flickable.StopAtBounds
                boundsBehavior: Flickable.StopAtBounds
                Layout.fillHeight: true
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                Layout.bottomMargin: 5
                Layout.fillWidth: true
                footer: Item {height: 15}
            }
        }
    }
}
