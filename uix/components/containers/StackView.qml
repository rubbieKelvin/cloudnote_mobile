import QtQuick 2.15
import QtQuick.Controls 2.15 as T

T.StackView {
    id: root

    function handleBackPressed(event){
        const page = currentItem

        if (page.handleBackPressed !== null || page.handleBackPressed !== undefined){
            page.handleBackPressed(event)
        }else{
            event.accepted = true
        }
    }

    onCurrentItemChanged: {
        const page = currentItem

        if (page != null || page != undefined){

            if (page.statusbarColor !== null || page.statusbarColor !== undefined){
                statusbar.color = page.statusbarColor
            }

            if (page.statusbarTheme !== null || page.statusbarTheme !== undefined){
                statusbar.theme = page.statusbarTheme
            }
        }
    }

    Connections{
        target: sm.uisettings
        function onThemeChanged(){
            const page = root.currentItem

            if (page != null || page != undefined){

                if (page.statusbarColor !== null || page.statusbarColor !== undefined){
                    statusbar.color = page.statusbarColor
                }

                if (page.statusbarTheme !== null || page.statusbarTheme !== undefined){
                    statusbar.theme = page.statusbarTheme
                }
            }
        }
    }
}
