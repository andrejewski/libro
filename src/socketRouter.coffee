# socketRouter.coffee

###
	CASocketRouter
	Signature: IO[instanceof Socket.IO]
	Description: An extension for Socket.IO that mimics the
	`app.router` middleware of Express/Connect to allow more
	modularity of Socket.IO.
	Dependencies: Socket.IO [Node.js]
	Exports: CASocketRouter[Function]
###

module.exports = (io) ->
	if io
		CASocketRouter io
	else
		CASocketRouter

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

