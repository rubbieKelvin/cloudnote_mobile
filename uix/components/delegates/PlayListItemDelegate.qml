import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.13

import "qrc:/uix/scripts/app/main.mjs" as AppMain
import "qrc:/uix/components/controls" as AppControls
import "qrc:/uix/scripts/frozen/icon.js" as Icons
import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants
import "qrc:/uix/components/popup/" as AppPopups

Rectangle{
    id: root
    width: 345
    height: col.height + 2
    color: thememanager.background

    property var model: [
        {text: "Export"},
        {text: "Rename"},
        {text: "Duplicate"},
        {text: "Download"},
        {text: "Turn off Sync"},
        {text: "Delete", color: thememanager.red},
    ]
    property alias bottomStroke: bottomStroke
    property string imageSource: AppMain.randomDummyImage()

    signal clicked

    ColumnLayout {
        id: col
        y: 1
        spacing: 8
        anchors.left: parent.left
        anchors.right: parent.right

        Rectangle{
            color: "transparent"
            height: 1
            Layout.preferredHeight: 1
            Layout.fillWidth: true
        }

        RowLayout{
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 15

            AppControls.RoundImage{
                visible: imageSource.length>0
                source: imageSource
                radius: 8
                Layout.preferredHeight: 50
                Layout.preferredWidth: 50
                fillMode: Image.PreserveAspectCrop
            }

            ColumnLayout{
                spacing: 0
                Layout.fillWidth: true
                Layout.fillHeight: false

                Label{
                    text: "Playlist Name"
                    color: thememanager.text
                    Layout.fillWidth: true
                }

                Label{
                    text: "playlist description"
                    color: thememanager.textUnimportant
                    font.pixelSize: FontConstants.SUBTEXT
                    Layout.fillWidth: true
                }
            }

            Item{
                Layout.fillHeight: true
                Layout.preferredWidth: 40

                AppControls.Button{
                    display: AbstractButton.IconOnly
                    icon.source: Svg.fromString(Icons.ICON_COOLICONS_MENU_MORE_VERTICAL, {
                        color: thememanager.textUnimportant
                    })
                    backgroundColor: "transparent"
                    width: 40
                    height: 40

                    onClicked: {
                        // popup.x = x+mouse.mouseX
                        // popup.y = y+(mouse.mouseY-popup.height)
                        popup.open()
                    }

                    AppPopups.ContentPopup{
                        id: popup
                        x: (parent.x+(parent.width/2)) - width
                        width: 140

                        popupContent: Component{
                            ColumnLayout{
                                width: popup.width
                                spacing: 1

                                Repeater{
                                    model: root.model

                                    Rectangle{
                                        color: thememanager.background
                                        Layout.preferredHeight: 40
                                        Layout.fillWidth: true
                                        
                                        Label{
                                            anchors.fill: parent
                                            anchors.leftMargin: 20
                                            anchors.rightMargin: 20
                                            text: modelData.text
                                            color: modelData.color || thememanager.text
                                            verticalAlignment: Text.AlignVCenter
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
            }
        }

        Rectangle{
            id: bottomStroke
            color: thememanager.stroke
            height: 1
            Layout.preferredHeight: 1
            Layout.fillWidth: true
        }
    }

    AppControls.RippleArea{
        anchors.fill: parent
        anchors.rightMargin: 40
        clipRadius: parent.radius
        onClicked: root.clicked()
    }
}
