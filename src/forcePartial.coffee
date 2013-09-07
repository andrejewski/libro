# forcePartial.coffee

###
	CAForcePartial
	Signature: Function(, Scope[Object]) ->
	Description: Transforms any function in a 
	function that can have partial applied 
	arguments similar to Haskell functions.
	Dependencies: None
	Exports: CAForcePartial[Function]
###

CAForcePartial = (func, scope = null) ->
	args = []
	lenf = func.length
	next = () ->
		if arguments.length == 0
			# force execution for optional parameters
			# that you don't want to supply.
			func.apply scope, args
		else
			args = args.concat arguments
			if args.length == lenf
				# provided function signature is filled
				# so it should be executed.
				func.apply scope, args
			else
				next
	next

if typeof exports != 'undefined'
	exports = CAForcePartial
else
	@CASuperPartial = CAForcePartial