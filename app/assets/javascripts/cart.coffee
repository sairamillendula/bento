class @Cart
  @checkout: (addresses) ->
    $('#also_shipping_address').click ->
      $('#shipping_address_fields').toggle()
      $('#same-address').toggle()

    $('#cart_shipping_address_attributes_country').change ->
      selected = $('#cart_shipping_address_attributes_country option').filter(':selected').val()
      if selected in ['CA', 'US']  
        $('#shipping_province').show()
      else
        $('#shipping_province').hide()

    $('#cart_billing_address_attributes_country').change ->
      selected = $('#cart_billing_address_attributes_country option').filter(':selected').val()
      if selected in ['CA', 'US']
        $('#billing_province').show()
      else
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
