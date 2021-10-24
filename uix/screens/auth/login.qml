import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "qrc:/uix/components/appbars/" as AppBars
import "qrc:/uix/scripts/api/auth.mjs" as AuthApi
import "qrc:/uix/components/containers/" as AppContainers
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants
import "qrc:/uix/components/controls/" as AppControls
import "qrc:/uix/scripts/lib/svg.js" as Svg
import "qrc:/uix/scripts/constants/routes.js" as Routes
import "qrc:/uix/scripts/frozen/icon.js" as Icons

AppContainers.Page {
    id: root
    header: AppBars.AppHeader{
        text: "Login"
    }

    ScrollView{
        anchors.fill: parent
        anchors.margins: 15
        clip: true
        contentWidth: availableWidth

        ColumnLayout{
            width: root.width - 30
            spacing: 50
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

            ColumnLayout{
                spacing: 10

                Label{
                    text: qsTr("Welcome Back")
                    font.pixelSize: FontConstants.BANNER
                    color: thememanager.text
                }

                Label{
                    text: qsTr("Fill in your details to continue")
                    font.pixelSize: FontConstants.NORMAL
                    color: thememanager.text
                }
            }

            ColumnLayout{
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                spacing: 15
                Layout.fillHeight: true

                AppControls.TextField{
                    id: email_
                    label: qsTr("Email Address")
                    Layout.fillWidth: true
                    leftButton.visible: true
                    leftButton.icon.source: Svg.fromString(Icons.ICON_ICONLY_LIGHT_MESSAGE, {
                        color: field.focus ? thememanager.accent : thememanager.text
                    })
                }

                AppControls.TextField{
                    id: pword_
                    property bool textShown: false
                    Layout.fillWidth: true
                    label: "Password"
                    leftButton.visible: true
                    leftButton.icon.source: Svg.fromString(Icons.ICON_ICONLY_LIGHT_LOCK, {
                        color: field.focus ? thememanager.accent : thememanager.text
                    })

                    rightButton.visible: true
                    rightButton.enabled: true
                    rightButton.icon.source: Svg.fromString((textShown) ? Icons.ICON_ICONLY_LIGHT_HIDE : Icons.ICON_ICONLY_LIGHT_SHOW, {
                        color: thememanager.text
                    })

                    field.passwordCharacter: "*"
                    field.echoMode: textShown ? TextInput.Normal : TextInput.Password

                    rightButton.onClicked: {
                        textShown = !textShown
                    }
                }

                RowLayout{
                    spacing: 1
                    Layout.fillWidth: true

                    Label{
                        id: no_acc_label
                        font.pixelSize: FontConstants.NORMAL
                        color: thememanager.text
                        text: qsTr("Dont have an account?")
                    }

                    AppControls.Button{
                        font: no_acc_label.font
                        Layout.preferredWidth: width
                        backgroundColor: "#00000000"
                        foregroundColor: thememanager.link
                        text: qsTr("signup instead")
                        onClicked: mainstack.replace(Routes.SIGNUP)
                    }

                    Item{
                        Layout.fillWidth: true
                    }
                }
            }

            AppControls.Button{
                Layout.preferredHeight: 50
                Layout.fillWidth: true
                backgroundColor: thememanager.accent
                foregroundColor: "white"
                text: busy ? "":"Login"
                property bool busy: false

                AppControls.Busy{
                    running: parent.busy
                    budColor: parent.foregroundColor
                    anchors.centerIn: parent
                }

                onClicked: {
                    busy = true
                    const email = email_.field.text.trim()
                    const pword = pword_.field.text

                    api.auth.loginUser(email, pword).onload(response => {
                        if (response.status == 200){
                            console.debug("user logged in")

                            // save user data
                            sm.user.setCurrent(
                                response.data.user.first_name,
                                response.data.user.last_name,
                                email,
                                response.data.token
                            )

                            // goto home page
                            mainstack.replace(Routes.EXPLORE)
                        }else{
                            console.debug("invalid credentials")
                            // invalid user
                        }
                    }).onerror(() => {
                        console.debug("cant log user in")
                    }).finally(() => {
                        busy = false
                    })

                }
            }
        }
    }
}
