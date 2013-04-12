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

	$('#product_supplier_tokens').tokenInput(
		'/suppliers.json'
		theme: 'facebook'
		prePopulate: $('#product_supplier_tokens').data('load')
	)

	$('#product_cross_sell_tokens').tokenInput(
		'/products/search.json'
		theme: 'facebook'
		prePopulate: $('#product_cross_sell_tokens').data('load')
	)
	  