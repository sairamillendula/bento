$ ->
  $('#order_shipping_address_attributes_country').change ->
    provinces = $('#order_shipping_address_attributes_province').html()
    current_shipping_country = $('#order_shipping_address_attributes_country :selected').text().replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    current_shipping_province = $('#order_shipping_address_attributes_province :selected').val()

    shipping_options = $(provinces).filter("optgroup[label=#{current_shipping_country}]").html()

    if shipping_options
      $('#order_shipping_address_attributes_province').html(shipping_options)
      $('#order_shipping_address_attributes_province').val(current_shipping_province)

    if $(this).val() != ''
      if $(this).val() in ['CA', 'US']
        $('#shipping_province').show()
      else
        $('#shipping_province').hide()
    else
      $('#order_shipping_address_attributes_address1').val('')
      $('#order_shipping_address_attributes_address2').val('')
      $('#order_shipping_address_attributes_postal_code').val('')
      $('#order_shipping_address_attributes_city').val('')
      $('#order_shipping_address_attributes_country').val('')
      $('#order_shipping_address_attributes_province').val('')
      $('#shipping_province').hide()

  $('#order_billing_address_attributes_country').change ->
    provinces = $('#order_billing_address_attributes_province').html()
    current_billing_country = $('#order_billing_address_attributes_country :selected').text().replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    current_billing_province = $('#order_billing_address_attributes_province :selected').val()

    billing_options = $(provinces).filter("optgroup[label=#{current_billing_country}]").html()

    if billing_options
      $('#order_billing_address_attributes_province').html(billing_options)
      $('#order_billing_address_attributes_province').val(current_billing_province)

    if $(this).val() != ''
      if $(this).val() in ['CA', 'US']
        $('#billing_province').show()
      else
        $('#billing_province').hide()
    else
      $('#order_billing_address_attributes_address1').val('')
      $('#order_billing_address_attributes_address2').val('')
      $('#order_billing_address_attributes_postal_code').val('')
      $('#order_billing_address_attributes_city').val('')
      $('#order_billing_address_attributes_country').val('')
      $('#order_billing_address_attributes_province').val('')
      $('#billing_province').hide()
