class @Cart
  @checkout: (addresses) ->
    provinces = $('#cart_billing_address_attributes_province').html()
    current_billing_country = $('#cart_billing_address_attributes_country :selected').text().replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    current_billing_province = $('#cart_billing_address_attributes_province :selected').val()
    current_shipping_country = $('#cart_shipping_address_attributes_country :selected').text().replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    current_shipping_province = $('#cart_shipping_address_attributes_province :selected').val()

    billing_options = $(provinces).filter("optgroup[label=#{current_billing_country}]").html()
    shipping_options = $(provinces).filter("optgroup[label=#{current_shipping_country}]").html()

    if billing_options
      $('#cart_billing_address_attributes_province').html(billing_options)
      $('#cart_billing_address_attributes_province').val(current_billing_province)

    if shipping_options
      $('#cart_shipping_address_attributes_province').html(shipping_options)
      $('#cart_shipping_address_attributes_province').val(current_shipping_province)

    $('#also_shipping_address').click ->
      $('#shipping_address_fields').toggle()
      $('#same-address').toggle()

    $('#cart_shipping_address_attributes_country').change ->
      country = $('#cart_shipping_address_attributes_country :selected').text()
      escaped_country = country.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
      options = $(provinces).filter("optgroup[label=#{escaped_country}]").html()
      if options
        $('#cart_shipping_address_attributes_province').html(options)
        $('#shipping_province').show()
      else
        $('#cart_shipping_address_attributes_province').empty()
        $('#shipping_province').hide()

    $('#cart_billing_address_attributes_country').change ->
      country = $('#cart_billing_address_attributes_country :selected').text()
      escaped_country = country.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
      options = $(provinces).filter("optgroup[label=#{escaped_country}]").html()
      if options
        $('#cart_billing_address_attributes_province').html(options)
        $('#billing_province').show()
      else
        $('#cart_billing_address_attributes_province').empty()
        $('#billing_province').hide()

    if addresses
      address_mapping = []
      address_mapping[address.display_name] = address for address in addresses

      $('#billing_address').change ->
        if $(this).val() != ''
          adr = address_mapping[$(this).val()]
          $('#cart_billing_address_attributes_address1').val(adr.address1)
          $('#cart_billing_address_attributes_address2').val(adr.address2)
          $('#cart_billing_address_attributes_postal_code').val(adr.postal_code)
          $('#cart_billing_address_attributes_city').val(adr.city)
          $('#cart_billing_address_attributes_country').val(adr.country)
          $('#cart_billing_address_attributes_province').val(adr.province)
          if adr.country in ['CA', 'US']
            $('#billing_province').show()
          else
            $('#billing_province').hide()

        else
          $('#cart_billing_address_attributes_address1').val('')
          $('#cart_billing_address_attributes_address2').val('')
          $('#cart_billing_address_attributes_postal_code').val('')
          $('#cart_billing_address_attributes_city').val('')
          $('#cart_billing_address_attributes_country').val('')
          $('#cart_billing_address_attributes_province').val('')
          $('#billing_province').hide()

      $('#shipping_address').change ->
        if $(this).val() != ''
          adr = address_mapping[$(this).val()]
          $('#cart_shipping_address_attributes_address1').val(adr.address1)
          $('#cart_shipping_address_attributes_address2').val(adr.address2)
          $('#cart_shipping_address_attributes_postal_code').val(adr.postal_code)
          $('#cart_shipping_address_attributes_city').val(adr.city)
          $('#cart_shipping_address_attributes_country').val(adr.country)
          $('#cart_shipping_address_attributes_province').val(adr.province)
          if adr.country in ['CA', 'US']
            $('#shipping_province').show()
          else
            $('#shipping_province').hide()
        else
          $('#cart_shipping_address_attributes_address1').val('')
          $('#cart_shipping_address_attributes_address2').val('')
          $('#cart_shipping_address_attributes_postal_code').val('')
          $('#cart_shipping_address_attributes_city').val('')
          $('#cart_shipping_address_attributes_country').val('')
          $('#cart_shipping_address_attributes_province').val('')
          $('#shipping_province').hide()
