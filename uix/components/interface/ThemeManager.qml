import QtQuick 2.15
import "qrc:/uix/scripts/constants/color.mjs" as ColorConstants

QtObject {
    id: root
    property int theme: sm.uisettings.theme
    readonly property bool isdarkmode: theme !== 0

    readonly property string background: ColorConstants.BACKGROUND[theme]
    readonly property string text: ColorConstants.TEXT_NORMAL[theme]
    readonly property string textUnimportant: ColorConstants.TEXT_UNIMPORTANT[theme]
    readonly property string accent: ColorConstants.ACCENT[theme]
    readonly property string accent15: ColorConstants.ACCENT15[theme]
    readonly property string link: ColorConstants.LINK[theme]
    readonly property string stroke: ColorConstants.STROKE[theme]
    readonly property string placeholder: ColorConstants.PLACEHOLDER[theme]
    readonly property string handles: ColorConstants.PLACEHOLDER[theme]
    readonly property string shadow: ColorConstants.SHADOW[theme]
    readonly property string red: ColorConstants.RED[theme]
}
