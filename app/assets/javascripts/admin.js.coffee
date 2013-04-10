jQuery ->
  $("#q_reset").click ->
    $(".form-search input, .form-search select").val('')
  
  # for reference only
  # toggle admin sale price visibility
  $("#product_on_sale_true").click ->
    $("#product_sale_price_field").show()

  $("#product_on_sale_false").click ->
    $("#product_sale_price_field").hide()