@Collection = {}
@Collection.Show =
	init: ->
	  $('#collection-products').on "hover", ".product", (e) ->
	    action = $(this).find('.remove')
	    if e.type == "mouseenter"
	      action.show()
	    else
	      action.hide()

jQuery ->
	$('#collection-products').sortable
    axis: 'y'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))