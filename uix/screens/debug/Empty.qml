import QtQuick 2.15
import QtQuick.Controls 2.15
import StuffsByRubbie 0.1
import QtQuick.Layouts 1.3

Page{
    id: root

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 30

        ColumnLayout{
            Layout.fillWidth: true

            Label{
                text: "url"
                font.pixelSize: 15
            }

            TextField{
                id: url_field
                text: "/a/music/audio/17/download/"
                placeholderText: "url"
                Layout.fillWidth: true
            }
        }

        ColumnLayout{
            Layout.fillWidth: true

            Label{
                text: "method"
                font.pixelSize: 15
            }

            TextField{
                id: method_field
                placeholderText: "method"
                Layout.fillWidth: true
                text: "GET"
            }
        }

        ColumnLayout{
            Layout.fillWidth: true

            Label{
                text: "body"
                font.pixelSize: 15
            }

            TextField{
                id: body_field
                placeholderText: "body"
                Layout.fillWidth: true
            }
        }

        ColumnLayout{
            Layout.fillWidth: true

            Label{
                text: "user authtoken"
                font.pixelSize: 15
            }

            Switch{
                id: use_auth_switch
                checked: false
            }
        }

        ColumnLayout{
            Layout.fillWidth: true

            Label{
                text: "save offline"
                font.pixelSize: 15
            }

            Switch{
                id: save_offline_switch
                checked: false
            }
        }

        ColumnLayout{
            Layout.fillWidth: true

            Label{
                text: "retry"
                font.pixelSize: 15
            }

            SpinBox{
                id: retry_spin
                from: 0
                to: 10
            }
        }

        Button{
            text: "click"
            Layout.fillWidth: true

            onClicked: {
                rest.clearBody();

                if (use_auth_switch.checked){
                    rest.setHeader({
                        Authorization: "Token e1b41bac0bfd821e89ea176f923fe629125b6e72"
                    })
                }

                const body = body_field.text.trim();

                if (body.length > 1){
                    // rest.setBody(
                    //     // rest.createJsonBody({
                    //     //     "email": "dev.rubbie@gmail.com",
                    //     //     "password": "admin"
                    //     // })
                        
                    //     rest.createFormDataBody([
                    //         // rest.multiPartText("email", "dev.rubbie@gmail.com"),
                    //         // rest.multiPartText("password", "admin"),
                            
                    //         rest.multiPartFile("audio_file", "file:///home/rubbiekelvin/Projects/CloudNote/backend/.wastebin/15 - All Me.mp3")
                    //     ])
                    // )
                    rest.setBody(
                        rest.createJsonBody(
                            JSON.parse(body)
                        )
                    )
                }
                
                rest.call()
            }
        }

        Item {
            Layout.fillHeight: true
        }

        ProgressBar{
            id: pb
            Layout.preferredHeight: 5
            Layout.fillWidth: true
            from: 0
            to: 1
        }
    }


    RestClient{
        id: rest
        url: url_field.text.trim()
        method: method_field.text.trim()
        retry: retry_spin.value
        saveOffline: save_offline_switch.checked

        onLoaded: {
            console.log("responseBody"+JSON.stringify(body));
        }

        onFinally: {
            console.log("finished");
        }

        onError: {
            console.log("errorBody: "+JSON.stringify(body))
        }

        onDownloadProgress: {
            if (bytesTotal != -1){
                pb.indeterminate = false
                const ratio = bytesReceived/bytesTotal;
                console.log("download: "+bytesReceived+"/"+bytesTotal);
                pb.value = ratio;
            }else{
                pb.indeterminate = true
            }
        }
    }
}
