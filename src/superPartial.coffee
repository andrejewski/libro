# superPartial.coffee

###
	CASuperPartial
	Signature: Object{partial[Function], _[Placeholder Object]}
	Description: Partial function application that can occur 
	anywhere within the function arguments, in any order.
	Dependencies: None
	Exports: CASuperPartial[Object]

	Example Usage:
		partialFunction = partial multiplyAllArguments
		(((partialFunction _, _, 800) 300, _, 1600) 500)()
		=> multiplyAllArguments(300, 500, 800, 1600)
		=> 192000000000
###

_ = {'CASuperPartial': true}

partial = (func, scope = null) -> 
	params = []
	argument = (args...) ->
		if args.length == 0
			return func.apply scope, params
		for index, param in args
			if param != _
				place = (index, value) ->
					if params[index]
						return place (index+1), value
					params[index] = value
				place index, param
	argument

CASuperPartial = {partial, _}

if typeof exports != 'undefined'
	exports = CASuperPartial
else
	@CASuperPartial = CASuperPartial
