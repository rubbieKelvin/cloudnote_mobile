import QtQuick 2.15
import "qrc:/uix/scripts/lib/differ.mjs" as Differ
import "qrc:/uix/scripts/lib/httpclient.mjs" as HttpClient

QtObject{
    id: root
    // readonly property string baseurl: "http://192.168.43.154:8000"
    readonly property string baseurl: "http://localhost:8000"

    readonly property QtObject endpoints: QtObject{
        readonly property string auth_signup: `${baseurl}/a/auth/users/`
        readonly property string auth_user: `${baseurl}/a/auth/users/me/`
        readonly property string auth_login: `${baseurl}/a/auth/token/login/`

        readonly property string music_get_playlist: `${baseurl}/a/music/playlists/`
    }

    readonly property QtObject auth: QtObject{
        function createUser(first_name, last_name, email, password){
            return new HttpClient.JsonRequest(endpoints.auth_signup, {
                method: "POST",
                body: JSON.stringify({
                    first_name,
                    last_name,
                    email,
                    password
                })
            });
        }

        function getUser(token, retries){
            return new HttpClient.JsonRequest(endpoints.auth_user, {
                retry: retries || 0,
                method: "GET",
                headers: {
                    Authorization: `Token ${token}`
                }
            })
        }

        function loginUser(email, password){
            return new HttpClient.JsonRequest(endpoints.auth_login, {
                method: "POST",
                body: JSON.stringify({
                    email: email,
                    password: password
                })
            })
        }
    }

    readonly property QtObject music: QtObject{
        function fetchPlaylist(){
            sm.fetchingStatuses.playlist = true

            return new HttpClient.JsonRequest(endpoints.music_get_playlist, {
                method: "GET",
                headers: {
                    Authorization: `Token ${sm.user.token}`
                }
            }).onload(response => {
                if (response.status === 200){
                    Differ.sortDiffrence(sm.playlistModel, response.data, (item)=>item.id)
                }
            }).finally(() => {
                sm.fetchingStatuses.playlist = false
            })
        }
    }
}
