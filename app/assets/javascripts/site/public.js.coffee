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

  $("#currency-picker-toggle a").click ->
    $("#currency-picker-toggle").hide()
    $("#set_currency").fadeIn()
    false

  # $("#currencies-picker select").change(->
  #   $("#currencies-picker").hide()
  #   $("#currency-picker-toggle").fadeIn()
  #   true
  # ).blur ->
  #   $("#currencies-picker").hide()
  #   $("#currency-picker-toggle").fadeIn()
  #   true

$(document).ready(ready)
$(document).on('page:load', ready)
