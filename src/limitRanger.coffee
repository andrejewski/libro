# limitRanger.coffee

###
	CALimitRanger
	Signature: Min[Number], Max[Number], type[String]
		returns Range class
			@get & @set: Number
			@inc: Anonymous
			@dec: Anonymous
	Description: Handles number counter in limits and cycles.
	This is not neccessary but I for one appreciate the sugar.
	Dependencies: None
	Exports: CALimitRanger[Function]
###

class Ranger
	constructor: (@min, @max) ->
		@cur = @min
	get: -> @cur
	set: (v) -> 
		if @min <= v <= @max
			@cur = v

class Looper extends Ranger
	inc: ->
		if @cur++ > max
			@cur = @min
	dec: ->
		if @cur-- < @min
			@cur = @max

class Limiter extends Ranger
	inc: ->
		if @cur++ > @max
			@cur = @max
	dec: ->
		if @cur-- < @min
			@cur = @min

CALimitRanger = (min, max, type) ->
	if !type
		type 	= max
		max 	= min
		min 	= 0
	pick = switch type
		when 'ranger' 	then Ranger
		when 'loop' 	then Looper
		when 'limit' 	then Limiter
		when 'positive' then Positive
		else null
	if pick
		return pick min, max
	else
		throw new Error 'Range Type "'+type+'" not found.'

if typeof exports != 'undefined'
	exports = CALimitRanger
else
	@CALimitRanger = CALimitRanger
