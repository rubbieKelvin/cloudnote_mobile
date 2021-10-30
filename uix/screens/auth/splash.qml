import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import "qrc:/uix/components/controls/" as AppControls
import "qrc:/uix/scripts/constants/routes.js" as Routes
import "qrc:/uix/components/containers/" as AppContainers
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants

AppContainers.Page{
    id: root

    AppContainers.ResponsiveLayout{
        id: rl
        anchors.fill: parent
        anchors.margins: 15

        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            ColumnLayout{
                anchors.verticalCenterOffset: -rl.height * .086
                spacing: 0
                anchors.centerIn: parent

                Label{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: "CloudNote."
                    font.pixelSize: 36
                    color: thememanager.text
                }

                Label{
                    Layout.fillWidth: true
                    text: "stuffsbyrubbie"
                    color: thememanager.textUnimportant
                    font.pixelSize: FontConstants.SUBTEXT
                }
            }
        }

        ColumnLayout{
            visible: !col.visible
            Layout.fillWidth: application.portrait

            Item{
                width: parent.width
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                Layout.fillWidth: true

                AppControls.Busy{
                    running: true
                    anchors.centerIn: parent
                }
            }
        }

        ColumnLayout{
            id: col
            visible: false
            opacity: visible ? 1 : 0
            spacing: 12
            Layout.fillWidth: application.portrait
            Layout.preferredWidth: application.landscape ? root.width * .35 : root.width
            Layout.alignment: (application.portrait) ? Qt.AlignLeft | Qt.AlignBottom : Qt.AlignRight | Qt.AlignVCenter

            AppControls.Button{
                text: "Login"
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                foregroundColor: thememanager.accent
                backgroundColor: thememanager.accent15
                onClicked: mainstack.push(Routes.LOGIN)
            }

            AppControls.Button{
                text: "SignUp"
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                foregroundColor: "#fff"
                backgroundColor: thememanager.accent
                onClicked: mainstack.push(Routes.SIGNUP)
            }

            Behavior on opacity {
                NumberAnimation{
                    duration: 300
                }
            }
        }
    }

    Component.onCompleted: {
        // check if a token exists...
        // if it does, check if it's valid
        const data = cxx.read(sm.usercredentialFilename);
        if (data.length===0){
            // no user
            console.debug("no user found")
            col.visible = true
        }else{
            // try reading data
            let data_obj = null;

            try {
                // try to see if the token is still valid by getting user data
                console.debug("checking token validity")
                data_obj = JSON.parse(data);

                api.auth.getUser(data_obj.token, 5).onload((response)=>{
                    if (response.status===200){
                        // valid token
                        console.debug("token is valid")
                        sm.user.email = response.data.email
                        sm.user.first_name = response.data.first_name
                        sm.user.last_name =  response.data.last_name
                        sm.user.isLoggedIn = true
                        mainstack.push(Routes.EXPLORE)
                    }else{
                        col.visible = true
                    }
                }).onerror(() => {
                    // cant verify token
                    // most likely due to internet connection error
                    // at this point all we'll do is continue with the previuos data and pretend its valid
                    console.debug("cant validate token")
                    sm.user.first_name = data_obj.first_name
                    sm.user.last_name = data_obj.last_name
                    sm.user.email = data_obj.email
                    sm.user.isLoggedIn = true
                    mainstack.push(Routes.EXPLORE)
                }).finally(() => {
                    sm.user.token = data_obj.token
                })
            } catch (error) {
                // the data has been corrupted
                console.debug("data has been tampered with. rewriting user-cred file")
                col.visible = true
            }
        }
    }
}
