# socketRouter.coffee

###
	CASocketRouter
	Signature: IO[instanceof Socket.IO]
	Description: An upgrade for Socket.IO that mimics the
	`app.router` middleware of Express/Connect to allow more
	modularity of Socket.IO.
	Dependencies: Socket.IO [Node.js]
	Exports: CASocketRouter[Function]
###

###
CASocketRouter = (io) ->
	io.routes = []
	io.mount = (event, callback = ->) ->
		io.routes[event] = callback
	io.router = (debug = false) ->
		io.sockets.on 'connection', (socket) ->
			for event, callback in io.routes
				name = 'io/'+event
				socket.on event, (data, done) ->
					(console.time name) if debug
					next = (error, data) ->
						(console.timeEnd name) if debug
						done {error, data}
					callback.call socket, data, next, io.sockets
###

CASocketRouter = (io) ->
	return CASocketRouter if !io
	io.routes = []
	io.mount = (head) ->
		if typeof head == 'object'
			for event, callback of head
				io.mount event, callback
			return
		route = Array::slice.call arguments, 0
		if route.length == 2
			route.unshift '*'
		io.routes.push route
	io.space = (namespace) -> (eventOrHead, callback) ->
		if typeof eventOrHead == 'object'
			for event, callback of eventOrHead
				io.mount namespace, event, callback
			return
		io.mount namespace, eventOrHead, callback
	io.build = ->
		io.spaces = []
		for route in io.routes
			# assign tuples
			[namespace, event, callback] = route
			# wrap callback
			res = (socket, callback) -> (req, done) ->
				next = (error, data) ->
					done {error, data}
				callback.call socket, req, next, io.sockets
			# namespace
			if namespace != '*'
				On = (io.of namespace).on
			else
				On = io.sockets.on
			# push premade functions
			io.spaces.push (io) ->
				On 'connection', (socket) ->
					socket.on event, (res socket, callback)
	io.router = ->
		if !io._routerStarted
			io.build()
			(func io) for func in io.spaces
			io._routerStarted = true

module.exports = CASocketRouter
