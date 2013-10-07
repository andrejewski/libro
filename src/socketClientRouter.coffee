# socketClientRouter.coffee

###
	CASocketClientRouter
	Signature: Socket.IO[Object] -> Router class
	Description: listens on all events and calls 
	functions that are registered for those events.
	Dependencies: Socket.IO-client
	Exports: CASocketClientRouter[Object class]
###

class Router
	constructor: (@socket) ->
		@routes = {}
		@listen = true
		@configure()
	configure: ->
		_emit = @socket.$emit
		@socket.$emit = =>
			[ev, fn] = arguments
			((func fn) for func in @routes[ev]) if @listen
			_emit.apply @socket, arguments
	mount: (events, callback) ->
		promises = []
		if typeof event != 'object'
			events = [event]
		for event in events
			@routes[event] = @routes[event] || []
			@routes.push callback
			# return dismount promise
			r = @routes[event]
			index = r.length - 1
			promises.push {
				'func': callback
				dismount: -> r.pop index
				replace: (fn) -> r[index] = fn
			}
		if promises.length == 1
			return promises.pop()
		else
			return promises 

