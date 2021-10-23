import QtQuick 2.15
import StuffsByRubbie 0.1
import QtQuick.Controls 2.15 as T

T.Page {
    id: root
    background: Rectangle {
        color: thememanager.background
    }

    property string statusbarColor: thememanager.background
    property int statusbarTheme: thememanager.isdarkmode ? StatusBar.Dark : StatusBar.Light

    function handleBackPressed(event){
        if (mainstack.depth > 1){
            mainstack.pop()
        }else{
            event.accepted = true
        }
    }
}
