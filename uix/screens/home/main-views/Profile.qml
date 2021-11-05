import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import StuffsByRubbie 0.1

import "qrc:/uix/components/popup/" as AppPopup
import "qrc:/uix/components/sections/" as AppSections
import "qrc:/uix/components/controls/" as AppControls
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants
import "qrc:/uix/scripts/constants/routes.js" as Routes
import "qrc:/uix/scripts/constants/endpoints.js" as Endpoints


BaseView {
    id: root
    metaTitle: "Me"
    metaSubtitle: `signed in as ${sm.user.email}`

    Rectangle{
        y: 5
        width: parent.width
        height: 1
        color: thememanager.stroke
    }

    ScrollView{
        y: 6
        anchors.fill: parent
        anchors.topMargin: 20
        clip: true
        contentWidth: availableWidth
        
        ColumnLayout{
            x: 15
            width: root.width-30

            ColumnLayout{
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 1

                AppControls.SettingsMenuItem{
                    Layout.fillWidth: true
                    title: "Dark Mode"
                    subtitle: "switch theme to dark mode"
                    widget: Component{
                        AppControls.CSwitch{
                            id: themeswitch

                            Component.onCompleted: {
                                themeswitch.checked = sm.uisettings.theme===1
                            }

                            onCheckedChanged: {
                                sm.uisettings.theme = themeswitch.checked ? 1 : 0
                            }
                        }

                    }
                }

                AppControls.SettingsMenuItem{
                    Layout.fillWidth: true
                    title: "Auto-Download Playlists"
                    subtitle: "Download all your playlists directly to your device"
                    widget: Component{
                        AppControls.CSwitch{

                        }
                    }
                }

                AppControls.SettingsMenuItem{
                    Layout.fillWidth: true
                    title: "Clear Cache"
                    subtitle: "cache size at 512mb"
                }

                AppControls.SettingsMenuItem{
                    Layout.fillWidth: true
                    title: "Clear Storage"
                    subtitle: "delete all downloaded songs on your device"
                    widget: Component{
                        Label{
                            text: "20gb"
                            font.pixelSize: FontConstants.SUBTEXT
                            color: thememanager.textUnimportant
                        }
                    }
                }

                AppControls.SettingsMenuItem{
                    Layout.fillWidth: true
                    title: "Offline Sync"
                    subtitle: "sync downloaded song with cloudnote desktop"
                    onClicked: {
                        mainstack.push(Routes.OFFLINE_SYNC)
                    }
                }

                AppControls.SettingsMenuItem{
                    Layout.fillWidth: true
                    title: "Download Manager"
                    subtitle: "20 songs downloding. 80% done"
                    onClicked: {
                        mainstack.push(Routes.DOWNLOAD_MANAGER)
                    }
                }

                AppControls.SettingsMenuItem{
                    Layout.fillWidth: true
                    title: "Logout"
                    subtitle: "remove your account from this device"
					onClicked: logoutPopup.open()
                }

            }

            ColumnLayout{
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

				Item{Layout.preferredHeight: 20}

                Label{
                    text: "cloudnote.v1.0"
                    color: thememanager.textUnimportant
                    font.pixelSize: FontConstants.HELP
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillHeight: false
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
                }

                Label{
                    text: "stuffsbyrubbie"
                    color: thememanager.textUnimportant
                    font.pixelSize: FontConstants.HELP
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: false
                    Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
                }
            }
        }
    }

	AppPopup.ContentPopup{
		id: logoutPopup
		dim: true
		modal: true
		parent: Overlay.overlay
		anchors.centerIn: parent
		popupContent: Component{
			ColumnLayout{
				spacing: 20

				ProgressBar{
					id: pb
					indeterminate: true
					visible: false
				}

				Label{
					text: "Are you sure you want to logout?"
					font.pixelSize: FontConstants.HEADING
					color: thememanager.text
					Layout.margins: 10
				}

				RowLayout{
					spacing: 20
					Layout.margins: 10

					AppControls.Button{
						text: "Cancel"
						Layout.fillWidth: true
						Layout.preferredHeight: 45
						onClicked: logoutPopup.close()
					}

					AppControls.Button{
						text: "Logout"
						Layout.fillWidth: true
						Layout.preferredHeight: 45
						onClicked: {
							logoutApi.setHeader({
								Authorization: `Token ${sm.user.token}`
							})
							pb.visible = true
							logoutApi.call()
						}

						RestClient{
							id: logoutApi
							url: Endpoints.AUTH_LOGOUT
							method: "post"

							onFinally: {
								// delete the token
								// not caring for success or faliur if online
								if (! isNetworkError(body.error || -1)){
									sm.user.clear()
									mainstack.replace(Routes.AUTHSPLASH)
								}
								pb.visible = false
							}
						}
					}
				}
			}
		}
	}
}
