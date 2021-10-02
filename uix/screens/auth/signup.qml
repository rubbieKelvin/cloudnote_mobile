import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "qrc:/uix/scripts/api/auth.mjs" as AuthApi
import "qrc:/uix/components/containers/" as AppContainers
import "qrc:/uix/scripts/constants/color.mjs" as ColorConstants

AppContainers.Page {
    id: root

    ColumnLayout {
        anchors.centerIn: parent

        Label{
            text: "Signup"
        }

        TextField {
            id: first_name_field
            placeholderText: "first name"
        }

        TextField {
            id: last_name_field
            placeholderText: "last name"
        }

        TextField {
            id: email_field
            placeholderText: "email"
        }

        TextField {
            id: password_field
            placeholderText: "password"
        }

        Button{
            onClicked: {
                thememanager.theme = (thememanager.theme===ColorConstants.DARK) ? ColorConstants.LIGHT : ColorConstants.DARK
            }
        }

        Button{
            text: "submit"
            onClicked: AuthApi.signup(
                first_name_field.text.trim(),
                last_name_field.text.trim(),
                email_field.text.trim(),
                password_field.text
            )
        }
    }
}
