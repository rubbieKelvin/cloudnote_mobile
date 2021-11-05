import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import StuffsByRubbie 0.1
import "qrc:/uix/components/controls/" as AppControls
import "qrc:/uix/scripts/constants/routes.js" as Routes
import "qrc:/uix/components/containers/" as AppContainers
import "qrc:/uix/scripts/constants/fonts.mjs" as FontConstants
import "qrc:/uix/scripts/constants/endpoints.js" as Endpoints

AppContainers.Page{
    id: root

    RestClient{
		id: getUserApi
		url: Endpoints.AUTH_USER
		method: "GET"
		retry: Number(3)

		onFinally: {
			const token = getVariable("token")
			sm.user.token = token || ""
		}

		onLoaded: {
			if (response.status === 200){
				console.debug("token: alright...")
				const body = response.body

                sm.user.email = body.email
                sm.user.first_name = body.first_name
                sm.user.last_name =  body.last_name
                sm.user.isLoggedIn = true
                mainstack.push(Routes.EXPLORE)
			}else{
                col.visible = true
            }
		}

        onError: {
            // cant verify token
			if (isNetworkError(error.errorCode)){
				// due to internet connection error
				// at this point all we'll do is continue with the previuos data and pretend its valid
				console.debug("cant validate token")
				sm.user.first_name = getVariable("first_name")
				sm.user.last_name = getVariable("last_name")
				sm.user.email = getVariable("email")
				sm.user.isLoggedIn = true
				mainstack.push(Routes.EXPLORE)
			}else{
				col.visible = true
			}
        }
    }

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
        // check if the token exists
        // if the token exists, check if it still works
        let data = cxx.read(sm.usercredentialFilename)

		if (data.length===0){
            // no token
            console.debug("no token found")
            col.visible = true

        }else{
            try {
                data = JSON.parse(data)
				
                // vaiables so we can use when the request is complete
                getUserApi.addVariable("token", data.token)
                getUserApi.addVariable("email", data.email)
                getUserApi.addVariable("last_name", data.last_name)
                getUserApi.addVariable("first_name", data.first_name)

				getUserApi.setHeader({Authorization: `Token ${data.token}`})
				getUserApi.call()
            } catch (error) {
                console.debug("token was tampered with -> no user")
                col.visible = true
            }
        }
	}
}
