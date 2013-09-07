# masterInterval.coffee

###
	CAMasterInterval
	Signature:
		Number[Time in Milliseconds]
		returns class CAMasterInterval:
			@and: 	Function(, Scope[Object])
			@start: Anonomous
			@stop: 	Anonomous
	Description: keeps a global timer that can be easily shared 
	between functions that need to be executed separately, yet
	also at the same time. No need for multiple timers.
	Dependencies: None
	Exports: CAMasterInterval[Function]
###

bind = (func, scope) -> () ->
	func.call scope

CAMasterInterval = (time) ->
	masterInterval = {
		functions: []
		interval: null
		start: ->
			@stop()
			func = =>
				for func in @functions
					func()
			@interval = setInterval func, time
			@
		stop: ->
			clearInterval @interval if @interval
			@
		add: (func, scope) ->
			if scope
				func = bind func, scope
			@functions.push func
			@
	}
	masterInterval.start()

if typeof exports != 'undefined'
	exports = CAMasterInterval
else
	@CAMasterInterval = CAMasterInterval
