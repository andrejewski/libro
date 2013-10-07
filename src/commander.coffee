# commander.coffee

###
	CACommandCenter
	Signature: Function[Class] ->
		add: (name[String], func[Function])
		exec: name[String]
	Description: A simple object class that stores and can
	be called to execute functions. Good for user-input commands
	as if has a fail-safe for non-existent functions.
	Dependencies: None
	Exports: CACommandCenter
###

class Commander 
	constructor: (@commands) ->
	add: (name, func) -> @commands[name] = func
	exec: (name) ->
		func = @commands[name]
		func() if func
		!!func
	test: (name) -> !!@commands[name]

if typeof exports != 'undefined'
	exports = Commander
else
	@CACommandCenter = Commander