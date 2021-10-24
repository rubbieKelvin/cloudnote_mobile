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
        text: "Signup"
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
                    text: qsTr("Hi There!")
                    font.pixelSize: FontConstants.BANNER
                    color: thememanager.text
                }

                Label{
                    text: qsTr("Fill in your details to create an account")
                    font.pixelSize: FontConstants.NORMAL
                    color: thememanager.text
                }
            }

            ColumnLayout{
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                spacing: 15
                Layout.fillHeight: true

                RowLayout{
                    Layout.fillWidth: true
                    spacing: 10

                    AppControls.TextField{
                        id: fname_
                        label: qsTr("First Name")
                        Layout.fillWidth: true
                    }

                    AppControls.TextField{
                        id: lname_
                        label: qsTr("Last Name")
                        Layout.fillWidth: true
                    }
                }

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
                        text: qsTr("Already have an account?")
                    }

                    AppControls.Button{
                        font: no_acc_label.font
                        Layout.preferredWidth: width
                        backgroundColor: "#00000000"
                        foregroundColor: thememanager.link
                        text: qsTr("login here.")
                        onClicked: mainstack.replace(Routes.LOGIN)
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
                text: busy ? "" : "SignUp"
                property bool busy: false

                AppControls.Busy{
                    anchors.centerIn: parent
                    running: parent.busy
                    budColor: parent.foregroundColor
                }

                onClicked: {
                    busy = true
                    const fname = fname_.field.text.trim()
                    const lname = lname_.field.text.trim()
                    const email = email_.field.text.trim()
                    const pword = pword_.field.text
                    
                    api.auth.createUser(fname, lname, email, pword)
                    .onload((response) => {
                        if (response.status===201){
                            // save user state
                            sm.user.setCurrent(
                                fname,
                                lname,
                                email,
                                response.data.token
                            )

                            // go home
                            mainstack.push(Routes.EXPLORE)
                        }else{
                            console.error("error signing user up");
                        }
                    }).onerror(() => {
                                            
                    }).finally(() => {
                        busy = false
                    })
                }
            }
        }
    }
}
