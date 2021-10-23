import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/components/popup/" as AppPopups
import "qrc:/uix/scripts/frozen/icon.js" as Icons
import "qrc:/uix/scripts/app/main.mjs" as AppMain
import "qrc:/uix/components/controls" as AppControls
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants

Rectangle {
    id: root
    color: thememanager.background
    border.width: 1
    border.color: thememanager.stroke
    radius: 8
    height: row.height + 16
    width: row.width + 16

    signal clicked

    property var model: [
        {text: "Export"},
        {text: "Download"},
        {text: "Turn off Sync"},
        {text: "Delete", color: thememanager.red},
    ]

    AppControls.RippleArea{
        anchors.fill: parent
        clipRadius: parent.radius
        onClicked: root.clicked()
    }

    RowLayout{
        id: row
        x: 8
        y: 8
        anchors.margins: 8
        spacing: 10

        AppControls.RoundImage{
            source: AppMain.randomDummyImage()
            height: 42
            width: 42
            radius: 8
            Layout.preferredHeight: height
            Layout.preferredWidth: width
            fillMode: Image.PreserveAspectCrop

        }

        ColumnLayout{
            Layout.fillWidth: true

            Label{
                text: "Album Name"
                Layout.fillWidth: true
                color: thememanager.text
            }

            Label{
                text: "artist name"
                Layout.fillWidth: true
                color: thememanager.textUnimportant
                font.pixelSize: FontConstants.SUBTEXT
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
}
