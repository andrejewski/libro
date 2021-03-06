// Generated by CoffeeScript 1.6.3
/*
	CAFormatText
	Signature: String, Callback(Error, Object)
	Description: provides metadata about the given string
	such as word count, task data, formatted HTML of the string,
	and hashtags along with the original string.
	Dependencies: None
	Exports: CAFormatText[Function]
*/


(function() {
  var CAFormatText, exports;

  CAFormatText = function(text, next) {
    var compiledText, ct, hashed, hashtags, head, isTask, isTaskComplete, word, wordCount, words, _i, _len;
    words = text.split(' ');
    head = words[0];
    isTask = isTaskComplete = false;
    if ('[*]' === head) {
      isTask = isTaskComplete = true;
    } else if ('[]' === head) {
      isTask = true;
    }
    if (isTask) {
      words.shift();
    }
    wordCount = words.length;
    ct = words.join(' ');
    ct = ct.replace(/\*\*(.*?)\*\*/g, "<b>$1</b>");
    ct = ct.replace(/__(.*?)__/g, "<u>$1</u>");
    ct = ct.replace(/\*(.*?)\*/g, "<i>$1</i>");
    ct = ct.replace(/--(.*?)--/g, "<del>$1</del>");
    ct = ct.replace(/<<(.*?)>>/g, "<a target='_blank' href='$1'>$1</a>");
    ct = ct.replace(/`(.*?)`/g, "<code>$1</code>");
    hashtags = [];
    words = ct.split(' ');
    hashed = [];
    for (_i = 0, _len = words.length; _i < _len; _i++) {
      word = words[_i];
      if (word.charAt(0) === '#') {
        hashtags.push(word.slice(1));
        hashed.push("<a title='" + word + "' class='hashtag' data-tag='" + word + "'>" + word + "</a>");
      } else {
        hashed.push(word);
      }
    }
    compiledText = hashed.join(' ');
    return next(null, {
      text: text,
      wordCount: wordCount,
      isTask: isTask,
      isTaskComplete: isTaskComplete,
      compiledText: compiledText,
      hashtags: hashtags
    });
  };

  if (typeof exports !== 'undefined') {
    exports = CAFormatText;
  } else {
    this.CAFormatText = CAFormatText;
  }

}).call(this);
