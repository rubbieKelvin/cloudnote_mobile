import QtQuick 2.15
import "qrc:/uix/scripts/lib/httpclient.mjs" as HttpClient

QtObject{
    id: root
    readonly property string baseurl: "http://localhost:8000"

    readonly property QtObject endpoints: QtObject{
        readonly property string auth_signup: `${baseurl}/a/auth/users/`
        readonly property string auth_user: `${baseurl}/a/auth/users/me/`
        readonly property string auth_login: `${baseurl}/a/auth/token/login/`
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

        function getUser(token){
            return new HttpClient.JsonRequest(endpoints.auth_user, {
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
}
