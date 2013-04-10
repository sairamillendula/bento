jQuery ->

	if $('.public').length
	  $.getScript('/application/users')

	$('#article_tag_tokens').tokenInput(
		'/tags.json'
		theme: 'facebook'
		prePopulate: $('#article_tag_tokens').data('load')
	)

	$('#product_category_tokens').tokenInput(
		'/categories.json'
		theme: 'facebook'
		prePopulate: $('#product_category_tokens').data('load')
	)
	  