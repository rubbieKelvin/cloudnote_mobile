import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/uix/components/containers/" as AppContainers
import StuffsByRubbie 0.1

AppContainers.Page{
    id: root

    Button{
        text: "click"
        anchors.centerIn: parent

        onClicked: {
            // rest.setHeader({
            //     Authorization: "Token e1b41bac0bfd821e89ea176f923fe629125b6e72"
            // })
            rest.setBody(
                // rest.createJsonBody({
                //     "email": "dev.rubbie@gmail.com",
                //     "password": "admin"
                // })
                
                rest.createFormDataBody([
                    // rest.multiPartText("email", "dev.rubbie@gmail.com"),
                    // rest.multiPartText("password", "admin"),
                    
                    rest.multiPartFile("audio_file", "file:///home/rubbiekelvin/Projects/CloudNote/backend/.wastebin/15 - All Me.mp3")
                ])
            )
            rest.call()
        }
    }

    RestClient{
        id: rest
        url: "/a/music/metaData/"
        method: "post"

        onLoaded: {
            console.log("responseBody"+JSON.stringify(body));
        }

        onFinally: {
            console.log("finished");
        }

        onError: {
            console.log("errorBody: "+JSON.stringify(body))
        }
    }
}
