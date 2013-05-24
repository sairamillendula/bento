ready = ->

	if $('.public').length
	  $.getScript('/application/users')

$(document).ready(ready)
$(document).on('page:load', ready)