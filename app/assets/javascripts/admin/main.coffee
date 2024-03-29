Util.onReady ->
  $("#q_reset").click ->
    $(".form-search input, .form-search select").val('')

  # token fields
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

  $('.date_picker').datepicker
    format: 'yyyy-mm-dd'

  window.NestedFormEvents.removeFields = (e) ->
    $link = $(e.currentTarget)
    assoc = $link.data('association')
    wrapper = $link.data('wrapper') || '.fields'

    hiddenField = $link.prev('input[type=hidden]')
    hiddenField.val('1')

    field = $link.closest(wrapper)
    field.hide()

    field
      .trigger({ type: 'nested:fieldRemoved', field: field })
      .trigger({ type: 'nested:fieldRemoved:' + assoc, field: field })
    return false
