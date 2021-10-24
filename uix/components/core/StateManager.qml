import QtQuick 2.15
import Qt.labs.settings 1.0
import "qrc:/uix/scripts/constants/routes.js" as Routes

QtObject{
    id: root

    readonly property string settingsFilename: "cloudnote.cfg"
    readonly property string usercredentialFilename: "u-cred.json"

    readonly property QtObject runtime: QtObject{
        readonly property bool debug: true
        readonly property string initialScreen: Routes.AUTHSPLASH // the first screen that shows up when debug=true
    }

    readonly property QtObject navigation: QtObject{
        property string clickedPlaylistResource: ""
    }
    
    readonly property Settings uisettings: Settings{
        category: "ui"
        fileName: root.settingsFilename
        property int theme: 0
    }

    readonly property Settings datasavingsettings: Settings{
        category: "datasaving"
        fileName: root.settingsFilename
        property bool autoDownloadPlaylists: true
    }

    readonly property Settings offlinesyncsettings: Settings{
        category: "offlinesync"
        fileName: root.settingsFilename
    }

    readonly property QtObject user: QtObject{
        property string first_name: ""
        property string last_name: ""
        property string email: ""
        property bool isLoggedIn: false

        function setCurrent(first_name, last_name, email, token){
            const data = {
                first_name,
                last_name,
                email,
                token
            }

            cxx.write(usercredentialFilename, JSON.stringify(data));
        }
    }
}
