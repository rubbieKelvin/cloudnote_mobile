import {ENDPOINT_SIGNUP} from "../constants/network.mjs"
import {JsonRequest} from "../lib/httpclient.mjs"

export function signup(first_name, last_name, email, password) {
    const req = new JsonRequest(ENDPOINT_SIGNUP, {
        method: "POST",
        body: JSON.stringify({
            first_name: first_name,
            last_name: last_name,
            email: email,
            password: password
        })
    }).onload(function(response){

    })
    
}
