# bindings.coffee

###
	CAMultiBind
	Signature: (Scopes) -> (Function) -> Empty to Execute
	Description: A simple binding function that binds a function 
	to multiple scopes to be executed at once.
	Dependencies: None
	Exports: CAMultiBind[Function]
###

CAMultiBind = (p1) -> (p2) ->
	scope = func = null
	if typeof p1 == 'function'
		scope 	= p2
		func 	= p1
	else
		scope 	= p1
		func 	= p2
	() ->
		for i,n of scope
			func.call n

###
	CABindGroup
	Signature: (Function) -> ... -> Empty to Execute
	Description: Groups a lot of function call together in
	a nice passable variable, which are called in the order 
	they are included.
	Dependencies: None
	Exports: CABindGroup[Function] 
###

CABindGroup = (func) ->
	funcs = []
	pass = (func) ->
		if typeof func == 'function'
			funcs.push func
			return pass
		else
			for i,n of funcs
				n()
	pass func

###
	CABindChain
	Signature: (Function) -> ... -> Empty to Execute
	Description: CABindGroup that executes sequencial and 
	if any function callback anything but empty execution
	stops and returns the result to the last function.
	Dependencies: None
	Exports: CABindChain[Function] 
###

CABindChain = (func) ->
	funcs = []
	pass = (func) ->
		if typeof func == 'function'
			funcs.push func
			return pass
		else
			next = (i) -> (err) ->
				if err
					funcs[funcs.length - 1] err
				else
					funcs[i] (next i+1)
			funcs[0] (next 1)
	pass func

CABindings = {CAMultiBind, CABindGroup, CABindChain}

if typeof exports != 'undefined'
	exports = CABindings
else
	@CABindings = CABindings
