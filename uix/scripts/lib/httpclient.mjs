export let LOG_RESPONSE = true

export class JsonRequest{
    constructor (url, options){
        // our url
        // const _url = new URL(url)
        // this.url = _url

        // // set query params
        // Object.entries(options.params || {}).forEach(function (kv){
        // 	_url.searchParams.set(kv[0], kv[1])
        // })
        this.url = url
        this._finally_func = () => {}
		
        // request method
        this.method = options.method || "GET"
        this.body = options.body || null
        this.responseType = options.responseType || "json"
        this.headers = options.headers || {}

        // default content-type
        if (this.headers['Content-Type'] === undefined){
            this.headers['Content-Type'] = 'application/json'
        }

        // our retry mec...
        this.retry = options.retry || 0
        this.tries = 0 // number of tries already made

        this.xhr = this.createXhr()

    }

    createXhr(oldxhr){
        // create xhr
        const _xhr = new XMLHttpRequest()
        // this.xhr = _xhr
        _xhr.open(this.method, this.url)
        _xhr.responseType = this.responseType
        _xhr.withCredentials = true

        // set headers
        Object.entries(this.headers).forEach((kv) => {
            _xhr.setRequestHeader(kv[0], kv[1]);
        })

        // calls the server
        _xhr.send(this.body)

        // try reconnecting events
        if (oldxhr){
            _xhr.onload = oldxhr.onload
            _xhr.onerror = oldxhr.onerror
        }

        return _xhr
    }

    abort(){
        this.xhr.abort()
    }

    onerror(func){
        // sets the error functions
        const self = this
        this.xhr.onerror = function(){
			if (self.tries < self.retry){
				self.tries += 1
                console.debug(`retrying: (${self.tries}/${self.retry})`)
				// self.xhr.send(self.body)
                
                const _xhr = self.createXhr(self.xhr)
                self.xhr = _xhr

			}else{
				// reset retries and call error_func
				self.tries = 0
				func()
                self._finally_func(null)
			}
		}
        return this
    }

    onload(func){
        // set the load functions
		const self = this
        this.xhr.onload = () => {
			// form response
			const response = {}
	
			response.method = self.method
			response.status = self.xhr.status
			response.data = self.xhr.response
			response.type = self.xhr.responseType
			response.headers = self.xhr
				.getAllResponseHeaders()
				.split('\r\n')
				.reduce((result, current) => {
					let kv = current.split(': ')
					result[kv[0]] = kv[1];
					return result;
				}, {});
	
			// call load function
			self.log(response)
			func(response)
			// reset the number of tries. just incase it has meen tampered with
			self.tries = 0
            self._finally_func(response)
		}
        return this
    }

    finally(func){
        // function to be called once after the client has stopped working
        // regardless of success or faliure
        this._finally_func = func
    }

	log(response){
		if (LOG_RESPONSE){
            let res = "\nRESPONSE ======================\n"
			Object.entries(response).forEach(function(kv){
                let value = kv[1]

				if (typeof value == "object"){
					value = JSON.stringify(value)
				}
                res+=`	${kv[0]}: ${value}\n`
			})
            console.log(res + "END-RESPONSE ===================\n")
		}
	}
}
