import QtQuick 2.15

Item{
    id: root
    width: 0
    height: 0

    FontLoader{ id: f_regular; source: "qrc:/uix/assets/fonts/Poppins/Poppins-Regular.ttf"}
    FontLoader{ id: f_medium; source: "qrc:/uix/assets/fonts/Poppins/Poppins-Medium.ttf"}
    FontLoader{ id: f_semibold; source: "qrc:/uix/assets/fonts/Poppins/Poppins-SemiBold.ttf"}
    FontLoader{ id: f_bold; source: "qrc:/uix/assets/fonts/Poppins/Poppins-Bold.ttf"}

    readonly property string fontRegular: f_regular.name
    readonly property string fontMedium: f_medium.name
    readonly property string fontSemibold: f_semibold.name
    readonly property string fontBold: f_bold.name
}
