jQuery ->
  order.setupForm()

	order =
	  setupForm: ->

      if $('#order_billing_address_attributes_bypass_validation').is(':checked')
        $('#billing_address_fields').hide()

      $('#order_billing_address_attributes_bypass_validation').click ->
        $('#billing_address_fields').toggle()

      $('#order_shipping_address_attributes_country').change ->
        selected = $('#order_shipping_address_attributes_country option').filter(':selected').text()
        if selected is "Canada" or selected is "United States"
          $('#shipping_province').show()
        else
          $('#shipping_province').hide()

      $('#order_billing_address_attributes_country').change ->
        selected = $('#order_billing_address_attributes_country option').filter(':selected').text()
        if selected is "Canada" or selected is "United States"
          $('#billing_province').show()
        else
          $('#billing_province').hide()

      # disable submit if termms & conditions not accepted
      setupTermsbox = ->
        if $('#accept-terms-box').is(':checked')
          $('#submit-order').attr('disabled', false)
        else
          $('#submit-order').attr('disabled', true)

      setupTermsbox()

      $('#accept-terms-box').click ->
        setupTermsbox()

      # disable submit button when clicked
      $('#new_order').submit ->
        $('input[type=submit]').attr('disabled', true)
