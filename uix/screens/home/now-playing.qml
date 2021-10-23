import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import "qrc:/uix/scripts/app/main.mjs" as AppMain
import "qrc:/uix/components/appbars/" as AppBars
import "qrc:/uix/components/containers/" as AppContainers
import "qrc:/uix/components/controls/" as AppControls
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants
import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/scripts/frozen/icon.js" as Icons
import "qrc:/uix/components/popup/" as AppPopups

AppContainers.Page{
    id: root
    header: AppBars.AppHeader{
        text: "Now Playing"
        font.pixelSize: FontConstants.LARGE
        rightButton.visible: true
        rightButton.display: AbstractButton.IconOnly
        rightButton.icon.source: Svg.fromString(Icons.ICON_COOLICONS_MENU_MORE_VERTICAL, {
            color: thememanager.textUnimportant
        })

        leftButtonSource: Svg.fromString(Icons.ICON_COOLICONS_ARROW_CHEVRON_LEFT, {
            color: thememanager.text
        })

        onRightButtonClicked: {
            bottomsheet.open()
        }
    }

    ColumnLayout{
        anchors.fill: parent
        anchors.bottomMargin: (rl.flow === rl.portraitLayout) ? 50 : 24

        Rectangle{
            Layout.fillWidth: true
            height: 1
            Layout.preferredHeight: height
            color: thememanager.stroke
        }

        AppContainers.ResponsiveLayout{
            id: rl
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            columnSpacing: 20
            rowSpacing: 20

            Item{
                Layout.fillWidth: true
                Layout.fillHeight: true

                AppControls.RoundImage{
                    radius: 8
                    anchors.centerIn: parent
                    source: AppMain.randomDummyImage()
                    width: parent.width
                    height: Math.min(((rl.flow === rl.portraitLayout) ? parent.width : parent.height), parent.height)
                }
            }

            AppControls.MediaPlayerControl{
                Layout.fillWidth: true
                Layout.fillHeight: (rl.flow === rl.portraitLayout) ? false : true
                Layout.maximumWidth: Math.min(application.height, application.width)
            }
        }
    }

    AppPopups.BottomSheet{
        id: bottomsheet
        title: "Now Playing"
        width: parent.width
        sheetContent: Component{
            ColumnLayout{
                spacing: 1

                Repeater{
                    model: [
                        {text: "Audio Information", iconSource: Icons.ICON_COOLICONS_ATTENTION_INFO_CIRCLE_OUTLINE},
                        {text: "Queue Manager", iconSource: Icons.ICON_COOLICONS_EDIT_LIST_OL},
                        {text: "Add to Playlist", iconSource: Icons.ICON_COOLICONS_EDIT_LIST_PLUS},
                        {text: "Download to device", iconSource: Icons.ICON_COOLICONS_BASIC_DOWNLOAD},
                        {text: "Share", iconSource: Icons.ICON_COOLICONS_BASIC_SHARE}
                    ]

                    Rectangle{
                        color: thememanager.background
                        Layout.preferredHeight: 50
                        Layout.fillWidth: true

                        RowLayout{
                            anchors.fill: parent
                            spacing: 25

                            Image{
                                source: Svg.fromString(modelData.iconSource, {
                                    color: thememanager.text
                                })
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                            }

                            Label{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                text: modelData.text
                                color: thememanager.text
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        AppControls.RippleArea{
                            anchors.fill: parent
                        }
                    }
                }
            }
        }
    }
}
