import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.13

import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/components/popup/" as AppPopups
import "qrc:/uix/scripts/frozen/icon.js" as Icons
import "qrc:/uix/components/controls" as AppControls
import "qrc:/uix/components/delegates" as AppDelegates
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants


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

        // Hiding the Album Section
        /*ColumnLayout{
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
        }*/

        ColumnLayout{
            spacing: 10
            Layout.fillHeight: true
            Layout.fillWidth: true

            RowLayout{
                Layout.fillWidth: true

                Label{
                    text: qsTr("Playlists")
                    font.pixelSize: FontConstants.HEADING
                    color: thememanager.text
                    Layout.fillWidth: true
                    Layout.leftMargin: 15
                    Layout.rightMargin: 15
                }

                AppControls.Button{
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 70
                    borderRadius: 0
                    text: "Add New"
                    foregroundColor: thememanager.accent
                    backgroundColor: "transparent"
                    font.pixelSize: FontConstants.SUBTEXT

                    onClicked: {
                        bottomsheet.open()
                    }
                }
            }

            ProgressBar{
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                visible: sm.fetchingStatuses.playlist
                indeterminate: visible
            }

            ListView{
                id: play_list_view
                clip: true
                model: sm.playlistModel
                delegate: AppDelegates.PlayListItemDelegate{
                    width: play_list_view.width
                    imageSource: ""
                    title.text: name
                    descr.text: description
                    isAutoPlaylist: auto
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

            Component.onCompleted: {
                if (sm.playlistModel.count === 0){
                    api.music.fetchPlaylist()
                }
            }
        }
    }

    AppPopups.BottomSheet{
        id: bottomsheet
        title: "New Playlist"
        width: parent.width
        modal: true
        fillScreen: true
        sheetContent: Component{
            ColumnLayout{
                spacing: 1
            }
        }
    }
}
