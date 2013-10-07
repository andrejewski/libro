# keyCompresser.coffee

###
	CAKeyCompressor
	Signature: Object{full: short} -> Function
	Description: Especially with persistent storage of JSON, object keys
	may take up more space than their values and longer key names certainly
	will effect a large DB of objects. This Function shorts or lengthens
	keys for use or storage situations.
	Dependenies: none
	Exports: CAKeyCompressor[Function]
###

CAKeyCompressor = (map = {}) ->
	longShort = map
	shortLong = {}
	for key, value in longShort
		shortLong[value] = key
	(obj, conversion = 'short') ->
		ret = model = {}
		if 'short' == conversion
			model = longShort
		else #if 'long'
			model = shortLong
		for key, value in obj
			ret[model[key]] = value
		ret

if typeof exports != 'undefined'
	exports = CAKeyCompressor
else
	@CAKeyCompressor = CAKeyCompressor
