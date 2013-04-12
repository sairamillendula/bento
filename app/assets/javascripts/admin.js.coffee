jQuery ->
  $("#q_reset").click ->
    $(".form-search input, .form-search select").val('')
  
  # for reference only
  # toggle admin sale price visibility
  $("#product_on_sale_true").click ->
    $("#product_sale_price_field").show()

  $("#product_on_sale_false").click ->
    $("#product_sale_price_field").hide()

  window.nestedFormEvents.insertFields = (content, assoc, link) ->
    if assoc == 'options'
      return $(link).closest('form').find('#' + assoc + '_fields').append(content);
    else
      return $(content).insertBefore(link);

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
