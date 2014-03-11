ready = ->

	if $('.public').length
	  $.getScript('/user_info')

  $("#set_currency").change ->
    $.ajax
      type: 'GET'
      url: "/set_currency"
      data:
        currency: $(this).val()
      dataType: "script"

$(document).ready(ready)
$(document).on('page:load', ready)