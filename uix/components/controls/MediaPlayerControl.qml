import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15 as T

import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/scripts/frozen/icon.js" as Icons
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants

ColumnLayout{
    id: root
    spacing: 25
    property var audioData: ({})

    ColumnLayout{
        spacing: 0
        Layout.fillHeight: true
        Layout.fillWidth: true

        T.Label{
            text: audioData.title
            Layout.fillWidth: true
            color: thememanager.text
            font.pixelSize: FontConstants.LARGE
        }

        T.Label{
            text: audioData.artist
            Layout.fillWidth: true
            color: thememanager.placeholder
            Layout.fillHeight: true
            verticalAlignment: Text.AlignTop
        }
    }

    ColumnLayout{
        spacing: 5

        SeekerControl{
            Layout.preferredHeight: 28
            Layout.fillWidth: true
        }

        RowLayout{
            Layout.fillWidth: true

            T.Label{
                text: "00:00"
                Layout.fillWidth: true
                color: thememanager.textUnimportant
                font.pixelSize: FontConstants.SUBTEXT
            }

            T.Label{
                text: "00:00"
                Layout.fillWidth: true
                color: thememanager.textUnimportant
                font.pixelSize: FontConstants.SUBTEXT
                horizontalAlignment: Text.AlignRight
            }
        }
    }

    RowLayout{
        Layout.preferredHeight: 60
        Layout.fillWidth: true
        spacing: 25

        Button{
            height: 35
            width: 35
            backgroundColor: "transparent"
            icon.width: 24
            icon.height: 24
            Layout.fillWidth: true
            foregroundColor: thememanager.accent
            text: "shuffle"
            display: T.AbstractButton.IconOnly
            Layout.preferredHeight: 35
            Layout.preferredWidth: 35
            icon.source: Svg.fromString(Icons.ICON_DARESAY_SHUFFLE_DEFAULT, {
                color: active ? thememanager.accent : thememanager.textUnimportant
            })
            property bool active: true
            onClicked: active = !active
        }

        Item{Layout.fillWidth: true}

        Button{
            height: 35
            width: 35
            backgroundColor: "transparent"
            icon.width: 24
            icon.height: 24
            Layout.fillWidth: true
            foregroundColor: thememanager.accent
            text: "previous"
            display: T.AbstractButton.IconOnly
            icon.source: Svg.fromString(Icons.ICON_DARESAY_SKIPBACK_DEFAULT, {
                color: thememanager.text
            })
            Layout.preferredHeight: 35
            Layout.preferredWidth: 35
        }

        Item{Layout.fillWidth: true}

        Button{
            height: 56
            width: 56
            backgroundColor: "transparent"
            icon.width: 24
            icon.height: 24
            foregroundColor: thememanager.accent
            text: "pause/play"
            display: T.AbstractButton.IconOnly
            icon.source: Svg.fromString(
                (isPlay) ? Icons.ICON_DARESAY_PLAY_DEFAULT : Icons.ICON_DARESAY_PAUSE_DEFAULT,
                {color: thememanager.text}
            )
            Layout.preferredHeight: 56
            Layout.preferredWidth: 56
            borderColor: thememanager.text
            borderWidth: 1
            borderRadius: 28
            property bool isPlay: false
            onClicked: isPlay = !isPlay
        }

        Item{Layout.fillWidth: true}

        Button{
            height: 35
            width: 35
            backgroundColor: "transparent"
            icon.width: 24
            icon.height: 24
            Layout.fillWidth: true
            foregroundColor: thememanager.accent
            text: "next"
            display: T.AbstractButton.IconOnly
            icon.source: Svg.fromString(Icons.ICON_DARESAY_SKIPFORWARD_DEFAULT, {
                color: thememanager.text
            })
            Layout.preferredHeight: 35
            Layout.preferredWidth: 35
        }

        Item{Layout.fillWidth: true}

        Button{
            height: 35
            width: 35
            backgroundColor: "transparent"
            icon.width: 24
            icon.height: 24
            Layout.fillWidth: true
            foregroundColor: thememanager.accent
            text: "repeat"
            display: T.AbstractButton.IconOnly
            Layout.preferredHeight: 35
            Layout.preferredWidth: 35
            icon.source: Svg.fromString(Icons.ICON_DARESAY_REPEAT_DEFAULT, {
                color: active ? thememanager.accent : thememanager.textUnimportant
            })
            property bool active: true
            onClicked: active = !active
        }
    }
}
