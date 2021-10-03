import QtQuick 2.15
import QtQuick.Layouts 1.3

 GridLayout{
    id: root
    property int portraitLayout: GridLayout.TopToBottom
    property int landscapeLayout: GridLayout.LeftToRight
    flow: application.height>application.width ? portraitLayout : landscapeLayout
}