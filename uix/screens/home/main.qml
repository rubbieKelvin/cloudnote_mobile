import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import "qrc:/uix/components/appbars/" as AppBars
import "qrc:/uix/components/controls/" as AppControls
import "qrc:/uix/components/containers/" as AppContainers
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants
import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/scripts/frozen/icon.js" as Icons
import "qrc:/uix/screens/home/main-views" as HomeViews


AppContainers.Page{
    id: root
    header: AppContainers.ResponsiveLayout{
        columnSpacing: 5
        rowSpacing: 18

        RowLayout{
            spacing: 5
            Layout.leftMargin: 18
            Layout.rightMargin: 18
            Layout.topMargin: application.portrait ? 0 : 18
            Layout.fillWidth: false

            AppControls.Button{
                id: virtual_back_btn
                display: AbstractButton.IconOnly
                icon.source: Svg.fromString(Icons.ICON_COOLICONS_ARROW_CHEVRON_LEFT, {
                    color: thememanager.text
                })
                icon.width: 28
                icon.height: 28
                width: 40
                height: 40
                borderRadius: 20
                Layout.preferredWidth: width
                Layout.preferredHeight: height
                backgroundColor: "transparent"
                visible: false

                function evaluateVisible(){
                    visible = (metaHistory.length>0) && (metaHistory[metaHistory.length-1].view !== homeview)
                }

                onClicked: goBack()
            }

            ColumnLayout{
                spacing: 0
                Layout.fillWidth: true
                Layout.fillHeight: true

                Label{
                    color: thememanager.text
                    font.pixelSize: FontConstants.XLARGE
                    text: metaTitle
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    verticalAlignment: Text.AlignVCenter
                }

                Label{
                    color: thememanager.textUnimportant
                    font.pixelSize: FontConstants.SUBTEXT
                    verticalAlignment: Text.AlignTop
                    text: metaSubTitle
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    visible: metaSubTitle.length > 0
                }
            }
        }

        AppControls.SearchField{
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.topMargin: application.portrait ? 0 : 10
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            visible: metaShowSearch
        }
    }

    function handleBackPressed(event){
        event.accepted = !goBack()
    }

    function goBack(){
        /** this is triggered when a back button is clicked.
         */
        if (metaHistory.length == 0){
            return false    // just close
        }
        
        const o = metaHistory.pop()

        /*if we are on the first page and then we want to go back,
        just quit*/
        if (homeview.currentIndex===0 && o.target===0 && o.view===homeview) return false

        if (o.target === null){
            o.view.pop()
        }else if (typeof o.target === "number"){
            o.view.currentIndex = o.target
        }else{
            o.view.push(o.target)
        }
        
        virtual_back_btn.evaluateVisible()
        return true
    }


    function addThrowBack(view, target){
        /** thow backs are target that a view
        can go back to when the back button is clicked.
        before  we add a new pair, we need to check if the pair exists in the past.
        if it exists, we remove it
         */
        let edited = false // has an object been deleted in the history
        
        // check for repetition
        for (let i=0; i<metaHistory.length; i+=1){
            let view_target_pair = metaHistory[i]
            if (view_target_pair) {
                if (view_target_pair.view === view && view_target_pair.target === target) {
                    metaHistory[i] = null
                    edited = true
                    break
                }
            }
        }

        // remove redundant view_target_pair
        if (edited){
            metaHistory = metaHistory.filter(function(n){return Boolean(n)})
        }
        // push
        metaHistory.push({
            view: view,
            target: target
        })

        virtual_back_btn.evaluateVisible()
    }

    property string metaTitle: (homeview.children[homeview.currentIndex] || {metaTitle : "<No-Title>"}).metaTitle || "<No-Title>"
    property string metaSubTitle: (homeview.children[homeview.currentIndex] || {metaSubtitle : ""}).metaSubtitle || ""
    property var metaHistory: [
        /*
        this list should contain a dictionary with the following keys
            view: Qml_StackView | Qml_StackLayout | Qml_SwipeView
            target: Qml_Page | number
            
        the view is the Widget we want to perform a reverse on.
        the target is the previous item/index we were before we got to were we are
        */
    ]
    property bool metaShowSearch: (homeview.children[homeview.currentIndex] || {metaUsesSearchBar : false}).metaUsesSearchBar || false // show the sesrchbar

    StackLayout{
        id: homeview
        anchors.fill: parent

        HomeViews.Explore{
            enabled: homeview.currentIndex === 0
            onSetHistory: addThrowBack(view, target)
        }

        HomeViews.Library{
            enabled: homeview.currentIndex === 1
            onSetHistory: addThrowBack(view, target)
        }

        HomeViews.Profile{
            enabled: homeview.currentIndex === 2
            onSetHistory: addThrowBack(view, target)
        }

        onCurrentIndexChanged: {
            navbar.currentIndex = currentIndex
            if (currentIndex !== 0) {
                /**
                 If the last page at the history list is not from homeview,
                 we should remove the page. because if i switch a page in library,
                 and i move directly to another page, going back will close the page we're are not seeing.
                */
                if (metaHistory.length>0 && metaHistory[metaHistory.length-1].view !== homeview){
                    const o = metaHistory.pop()

                    if (o.target === null){
                        o.view.pop()
                    }else if (typeof o.target === "number"){
                        o.view.currentIndex = o.target
                    }else{
                        // we're most likley not pushing anything since we're going back
                        // o.view.push(o.target)
                    }
                }

                // now we can add a throw back
                addThrowBack(homeview, 0)
            }
        }
    }


    footer: ColumnLayout{
        spacing: 0

        Rectangle{
            height: 1
            Layout.fillWidth: true
            color: thememanager.stroke
        }

        AppControls.MediaPlayerWidget{
            Layout.fillWidth: true
        }

        Rectangle{
            height: 1
            Layout.fillWidth: true
            color: thememanager.stroke
        }

        AppBars.NavBar{
            id: navbar
            width: parent.width
            Layout.fillWidth: true
            Layout.preferredHeight: 76

            onClicked: {
                if (homeview.currentIndex === index) return
                homeview.currentIndex = index
            }
        }
    }
}
