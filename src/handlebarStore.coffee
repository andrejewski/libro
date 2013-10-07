# handlebarStore.coffee

###
	CAHandlebarStore
	Signature: (Object of HandlebarStore classes)
	Description: Fetches and renders handlebars templates in a
	variety of ways using jQuery or Socket.io.
	Dependencies: Handlebars, (jQuery or Socket.io)
	Exports: CAHandlebarStore[Object]
###

class HandlebarStore
	constructor: (@directory = '/', @store = {})->
	get: (name) -> @store[name]
	set: (name, template) ->
		@store[name] = Handlebars.compile template
	getJSONObject: -> @store
	setJSONObject: (json) ->
		for name, template in json
			@set name, template

class jQueryAJAXStore extends HandlebarStore
	vet: (name) ->
		return @store[name] if @store[name]
		$.get @directory+name+'.hbs', (template) =>
			@set name, template
	vetJSONObject: (path) ->
		$.getJSON @directory+path, @setJSONObject

# directory not needed at all
class jQueryHTMLStore extends HandlebarStore
	vet: (name) ->
		return @store[name] if @store[name]
		@set name, $('#'+name+'-template').html()
	vetJSONObject: (name) ->
		@setJSONObject JSON.parse $('#'+name).html()

# supply a Socket.io instance as directory
class SocketioStore extends HandlebarStore
	vet: (name) ->
		return @store[name] if @store[name]
		directory.emit 'template', {name}, (data) =>
			@set name, data.template || data
	vetJSONObject: ->
		directory.emit 'template', {name: 'all'}, (data) =>
			@setJSONObject data.templates || data.json || data 
	
CAHandlebarStore = {
	HandlebarStore
	jQueryHTMLStore
	jQueryAJAXStore
	SocketioStore
}

if typeof exports != 'undefined'
	exports = CAHandlebarStore
else
	@CAHandlebarStore = CAHandlebarStore
