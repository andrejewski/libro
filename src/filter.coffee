# filter.coffee

###
	CAFilter
	Signature: CAFilter[Constructor]
###

class CAFilter
	constructor: (raw) ->
		@filter = ""
		@toClass raw if raw
	toClass: (raw) ->
		type = typeof raw
		# string
		if type == 'string'
			@fromString raw
		else if type == 'object'
			@fromMongo raw
		else
			throw new Error "#{type} is not a base data type. Only Strings, Urls, or Objects are allowed."
	fromString: (f) ->
		if f.charAt(0) == '/' # url
			# eg: /f?user=002&starred=true
			state = {$or:[]}
			query = f.slice 3
			pairs = query.split '&'
			for pair in pairs
				[prop, value] = pair
				state.$or.push {prop: value}
			@fromMongo state
		else # plain string
			@filter = f
	fromMongo: (object = {}) ->
		statements = []
		for pair in object.$or
			[prop, value] = pair
			statements.push prop+"="+value
		@filter = statements.join("||") || object
	toString: -> @filter
	toUrl: -> "/f?"+@filter.split("||").join("&")
	toMongo: ->
		object = {$or:[]}
		statements = @filter.split "||"
		for statement in statements
			[prop, value] = statement.split "="
			value = true if value == "true"
			value = false if value == "false"
			num = parseInt value, 10
			value = num if typeof num == 'number'
			i = {}
			object.$or.push (i[prop] = value)
		object
	toFunction: ->
		o = @toMongo()
		(x) ->
			bool = false
			for statement in o.$or
				[prop, value] = statement
				if x[prop] == value
					bool = true
			bool
	toConditions: -> @filter.split '||'

# username=kevin||liked=true
# (username=kevin&&liked=true)||username=chris

