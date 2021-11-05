import QtQuick 2.15
import Qt.labs.settings 1.0
import "qrc:/uix/scripts/constants/routes.js" as Routes

QtObject{
    id: root


    // VARIABLES
    readonly property string settingsFilename: "cloudnote.cfg"
    readonly property string usercredentialFilename: "u-cred.json"


    // LIST MODELS
	property ListModel playlistModel: ListModel{}

	function newModel(name){
		const res = Qt.createQmlObject(
			"import QtQuick 2.15; import QtQuick.Controls 2.15; ListModel{}",
			root,
			name || "dynamic-snippet-model")
		return res
    }


    // SETTINGS
	property Settings uisettings: Settings{
        category: "ui"
        fileName: root.settingsFilename
        property int theme: 0
    }

	property Settings datasavingsettings: Settings{
        category: "datasaving"
        fileName: root.settingsFilename
        property bool autoDownloadPlaylists: true
    }

	property Settings offlinesyncsettings: Settings{
        category: "offlinesync"
        fileName: root.settingsFilename
    }


    // OBJETCS
    property QtObject fetchingStatuses: QtObject{
        property bool playlist: false
    }

    property QtObject runtime: QtObject{
        readonly property bool debug: true
        readonly property string initialScreen: Routes.AUTHSPLASH // the first screen that shows up when debug=true
    }

    property QtObject navigation: QtObject{
        property int clickedPlaylistResource: 0
    }

    property QtObject user: QtObject{
        property string first_name: ""
        property string last_name: ""
        property string email: ""
        property bool isLoggedIn: false
        property string token: ''

        function setCurrent(first_name, last_name, email, token){
            const data = {
                first_name,
                last_name,
                email,
                token
            }

			user.first_name = first_name
			user.last_name = last_name
			user.email = email
            user.token = token
            cxx.write(usercredentialFilename, JSON.stringify(data));
        }

		function clear(){
			user.first_name = ""
			user.last_name = ""
			user.email = ""
			user.token = ""
			cxx.write(usercredentialFilename, "{}");
		}

		onTokenChanged: {
			downloadmanager.setAuthToken(token)
		}
    }

    property QtObject audioPlayer: QtObject{
        property int currentlyPlaying: -1
        // this should be set when a song from a playlist is played
        property var currentPlayListData: null
        property string audioPath: ""
        property bool downloadingCurrent: false
    }

	readonly property list<Connections> conns: [
		Connections{
			target: downloadmanager
			function onDownloadStarted(client){

			}
		}
	]
}
