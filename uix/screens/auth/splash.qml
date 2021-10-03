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
        }
    }
}
