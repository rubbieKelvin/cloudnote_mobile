class JsonResponse{
	constructor (){
		this.method = "GET"
		this.data = {}
		this.status = 0
		this.type = ""
		this.headers = {}
	}
}

class JsonRequest{
	constructor (url, options){
		// our url
		const _url = new URL(url)
		this.url = _url
		
		// set query params
		Object.entries(options.params || {}).forEach(function (kv){
			_url.searchParams.set(kv[0], kv[1])
		})

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
		
		// create xhr
		const _xhr = new XMLHttpRequest()
		this.xhr = _xhr
		this.xhr.open(this.method, this.url)
		this.xhr.responseType = this.responseType
		this.xhr.withCredentials = true
		
		// set headers
		Object.entries(this.headers).forEach(function(kv){
			_xhr.setRequestHeader(kv[0], kv[1]);
		})

		// default event functions
		this.onerror_func = function(){}
		this.onload_func = function(){}

		// calls the server
		this.xhr.send(this.body)
	}

	abort(){
		this.xhr.abort()
	}

	__onload(){
		// form response
		const response = new JsonResponse()
		response.method = this.method
		response.status = this.xhr.status
		response.data = this.xhr.response
		response.type = this.xhr.responseType
		response.headers = this.xhr
			.getAllResponseHeaders()
			.split('\r\n')
			.reduce(function(result, current){
				let kv = current.split(': ')
				result[kv[0]] = kv[1];
				return result;
			}, {});

		// call load function
		this.onload_func(response)

		// reset the number of tries. just incase it has meen tampered with
		this.tries = 0
	}

	__onerror(){
		if (this.tries < this.retry){
			this.tries += 1
			this.xhr.send(this.body)
		}else{
			// reset retries and call error_func
			this.tries = 0
			this.onerror_func()
		}
	}

	onerror(func){
		// sets the error functions
		this.onerror_func = func
		this.xhr.onerror = this.__onerror
		return this
	}

	onload(func){
		// set the load functions
		this.onload_func = func
		this.xhr.onload = this.__onload
		return this
	}
}

const request = new JsonRequest("https://google.com/search", {
	params: {
		q: "hello, world!"
	}
})

console.log(request)
