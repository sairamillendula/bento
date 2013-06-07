ready = ->

	if $('.public').length
	  $.getScript('/user_info')

$(document).ready(ready)
$(document).on('page:load', ready)