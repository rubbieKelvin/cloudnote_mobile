import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.13
import StuffsByRubbie 0.1

import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/components/popup/" as AppPopups
import "qrc:/uix/scripts/frozen/icon.js" as Icons
import "qrc:/uix/scripts/lib/differ.mjs" as Differ
import "qrc:/uix/components/controls" as AppControls
import "qrc:/uix/components/delegates" as AppDelegates
import "qrc:/uix/scripts/constants/endpoints.js" as Endpoints
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
				visible: sm.playlistModel.count > 0
                model: sm.playlistModel
                delegate: AppDelegates.PlayListItemDelegate{
                    width: play_list_view.width
                    bottomStroke.visible: index !== (play_list_view.count-1)

                    onClicked: goInPlaylistPage()

					Component.onCompleted: {
						const modelData = sm.playlistModel.get(index)
						title.text = modelData.name
						descr.text = modelData.description
						isAutoPlaylist = modelData.auto
						imageSource = modelData.playlistArt ? getPlaylistApi.BASEURL+modelData.playlistArt : ""
					}
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

			Item{
				// show if there's no item
				id: emptyState
				visible: !play_list_view.visible
                Layout.fillHeight: true
                Layout.fillWidth: true

                ColumnLayout{
                    anchors.centerIn: parent

                    Label{
                        text: "Your playlist is currently empty"
                        Layout.fillHeight: true
                        Layout.fillWidth: true
						font.pixelSize: FontConstants.HEADING
						color: thememanager.text
                    }

                    RowLayout{
                        spacing: 10
                        Layout.fillWidth: true

                        AppControls.Button{
							Layout.preferredHeight: 40
							enabled: !sm.fetchingStatuses.playlist
                            Layout.fillWidth: true
                            text: "Reload"
							onClicked: getPlaylistApi.doCall()
							borderRadius: height
							borderColor: thememanager.text
							foregroundColor: thememanager.text
							backgroundColor: "transparent"
							borderWidth: 1
                        }

                        AppControls.Button{
							Layout.preferredHeight: 40
                            Layout.fillWidth: true
                            text: "Create new"
							borderRadius: height
							borderWidth: 1
							borderColor: thememanager.accent
							foregroundColor: thememanager.accent
                            onClicked: bottomsheet.open()
							backgroundColor: "transparent"
                        }
                    }
                }
			}

			RestClient{
				id: getPlaylistApi
                method: "get"
				retry: Number(10)
				url: Endpoints.MUSIC_PLAYLISTS
				saveOffline: true

				function doCall(){
					if (sm.playlistModel.count === 0){
						sm.fetchingStatuses.playlist = true
						setHeader({Authorization: `Token ${sm.user.token}`})
						call()
					}
				}

				Component.onCompleted: doCall()

				onLoaded: {
                    const body = response.body;
                    if (response.status === 200){
						Differ.sortDiffrence(sm.playlistModel, body, item=>item.id);
                    }
				}

				onError: {

				}

				onFinally: {
					sm.fetchingStatuses.playlist = false
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
