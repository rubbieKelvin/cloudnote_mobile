import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.3
import "qrc:/uix/components/controls/" as AppControls

Rectangle {
    id: root
    height: 60
    radius: 4
    visible: opacity != 0
    width: Math.min(application.width, application.height) * .8
    color: thememanager.background
    layer.enabled: true
    layer.effect: DropShadow{
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 0
        color: thememanager.shadow
        radius: 8
        spread: 0
    }
    
    property Component snackContent

    ColumnLayout{
        Loader{
            sourceComponent: snackContent
        }

        ProgressBar{

        }
    }


    Behavior on x {
        NumberAnimation{
            duration: 300
        }
    }

    Behavior on opacity {
        NumberAnimation{
            duration: 300
        }
    }
}
