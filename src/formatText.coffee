# format.coffee

###
	CAFormatText
	Signature: String, Callback(Error, Object)
	Description: provides metadata about the given string
	such as word count, task data, formatted HTML of the string,
	and hashtags along with the original string.
	Dependencies: None
	Exports: CAFormatText[Function]
###

CAFormatText = (text, next) ->
	words = text.split ' '
	
	# Task Formatting
	head = words[0]
	isTask = isTaskComplete = false
	if '[*]' == head
		isTask = isTaskComplete = true
	else if '[]' == head
		isTask = true
	if isTask
		words.shift()
	wordCount = words.length
	ct = words.join ' '

	# Text Formatting
	ct = ct.replace /\*\*(.*?)\*\*/g, "<b>$1</b>"
	ct = ct.replace /__(.*?)__/g, "<u>$1</u>"
	ct = ct.replace /\*(.*?)\*/g, "<i>$1</i>"
	ct = ct.replace /--(.*?)--/g, "<del>$1</del>"
	ct = ct.replace /<<(.*?)>>/g, "<a target='_blank' href='$1'>$1</a>"
	ct = ct.replace /`(.*?)`/g, "<code>$1</code>"

	# manual hashtag
	hashtags = []
	words = ct.split ' '
	hashed = []
	for word in words
		if word.charAt(0) == '#'
			hashtags.push (word.slice 1)
			hashed.push "<a title='"+word+"' class='hashtag' data-tag='"+word+"'>"+word+"</a>"
		else
			hashed.push word
	compiledText = hashed.join ' '

	next null, {text, wordCount, isTask, isTaskComplete, compiledText, hashtags}

if typeof exports != 'undefined'
	exports = CAFormatText
else
	@CAFormatText = CAFormatText
