# socketBackbone.coffee

###
	CABackboneSocket
	Description: Make Backbone models happily work with Socket.io
	Dependencies: Backbone, Socket.IO
	Exports: CABackboneSocket, Backbone.Socket
###

root = window || @

CABackboneSocket = Backbone.Socket = Backbone.Model.extend {

	socket: null
	socketDebug: false
	socketEvents: {}
	socketMounts: {}

	ioEnable: ->
		if !@socket
			# smart (dumb) guessing 
			@io = @io || root.io || root.socketIO
			domain = @socketUrl || (@socketDomain + (@urlRoot || '/'))
			@socket = @io.connect domain
		@ioListenAll()
		@

	ioListen: (event, callback) ->
		if @socketDebug
			console.log "io#mount:#{event}", callback
		# update events hash
		@socketEvents[event] = callback
		# remove old listener if any
		@socket.removeListener event, @socketMounts[event]
		# bubble wrap callback & update mounts hash
		if typeof callback == 'string'
			callback = @[callback]
		@socketMounts[event] = (data, next) =>
			if @socketDebug
				console.log 'io#listen:#{ event }', data
			callback.call @, data, next
		# listen on event with mount callback
		@socket.on event, @socketMounts[event]

	ioListenAll: ->
		for event, callback in @socketEvents
			@ioListen event, callback

	ioTrigger: (event, data = {}, next = ->) ->
		if @socketDebug
			console.log 'io#trigger:#{ event }', data
		@socket.emit event, data, next

}

if typeof exports != 'undefined'
	exports = CABackboneSocket
else
	@CABackboneSocket = CABackboneSocket

