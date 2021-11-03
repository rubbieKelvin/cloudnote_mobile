import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

BaseView {
    id: library_screen
    metaTitle: "My Library"
    metaSubtitle: (library_stack.currentItem || {title: ''}).title

    StackView{
        id: library_stack
        anchors.fill: parent

        onVisibleChanged: {
            if (visible) {
                if (sm.navigation.clickedPlaylistResource===0){
                    library_stack.push("qrc:/uix/screens/home/main-views/library-views/All.qml")
                }else{
                    library_stack.push("qrc:/uix/screens/home/main-views/library-views/One.qml")
                }
            }
        }
    }
}
