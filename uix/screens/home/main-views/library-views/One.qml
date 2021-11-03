import QtQuick 2.15
import StuffsByRubbie 0.1
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.15

import "qrc:/uix/scripts/lib/differ.mjs" as Differ
import "qrc:/uix/components/controls" as AppControls
import "qrc:/uix/components/delegates" as AppDelegates
import "qrc:/uix/scripts/constants/routes.js" as Routes
import "qrc:/uix/scripts/constants/endpoints.js" as Endpoints

Base {
    id: root
    title: "playlist name"
    property int playlistID: 0

    ProgressBar{
        height: 2
        width: parent.width
        opacity: getPlaylistApi.loading ? 1 : 0
        indeterminate: opacity==1
    }

    AppControls.PullToRefresh{
        id: list_view
        y: 2
        clip: true
		model: ListModel{
			id: audio_model
		}

        delegate: AppDelegates.PlayListItemDelegate{
            width: list_view.width
            bottomStroke.visible: index !== (list_view.count-1)
			isAutoPlaylist: false

            onClicked: {
				const audioData = getPlaylistApi.getVariable("body")
				sm.audioPlayer.currentPlayListData = audioData
                sm.audioPlayer.currentlyPlaying = index
                mainstack.push(Routes.NOW_PLAYING)
            }

            Component.onCompleted: {
                const modelData = audio_model.get(index)
                title.text = modelData.title
                descr.text = modelData.artist
				imageSource = modelData.coverArt ? downloadmanager.cleanurl(modelData.coverArt) : ""
            }
        }
        anchors.fill: parent
        anchors.topMargin: 20
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        anchors.bottomMargin: 5
        footer: Item {height: 15}

        onTriggered: {

        }
    }

    RestClient{
        id: getPlaylistApi
        method: "get"
		retry: Number(10)
		saveOffline: true
		property bool loading: false

        function doGetPlaylistContent(){
			loading = true
			url = Endpoints._MUSIC_PLAYLIST_ONE(playlistID)
			setHeader({Authorization: `Token ${sm.user.token}`})
			call()
        }

		Component.onCompleted: {
            playlistID = sm.navigation.clickedPlaylistResource
            // reset clicked playlist
			sm.navigation.clickedPlaylistResource=0
            doGetPlaylistContent()
        }

        onLoaded: {
			const body = response.body
			addVariable("body", body)
			root.title = `${body.name} - ${body.audios.length} songs`
            if (response.status === 200){
				Differ.sortDiffrence(audio_model, body.audios, item=>item.id, true);
            }
        }

		onFinally: {
			loading = false
		}
    }

}
