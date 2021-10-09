import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

BaseView {
    id: library_screen
    metaTitle: "My Library"
    metaSubtitle: library_stack.currentItem.title

    StackView{
        id: library_stack
        anchors.fill: parent
        initialItem: "qrc:/uix/screens/home/main-views/library-views/All.qml"
    }
}
