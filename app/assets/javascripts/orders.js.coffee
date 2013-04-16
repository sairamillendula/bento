jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
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

      
      # disable submit button when clicked
      $('#new_order').submit ->
        $('input[type=submit]').attr('disabled', true)
        if $('#card_number').length
          order.processCard()
          false
        else
          true
  
      processCard: ->
        card =
          number: $('#card_number').val()
          cvc: $('#card_code').val()
          expMonth: $('#card_month').val()
          expYear: $('#card_year').val()
        Stripe.createToken(card, order.handleStripeResponse)
      
      handleStripeResponse: (status, response) ->
        if status == 200
          $('#order_stripe_card_token').val(response.id)
          $('#new_order')[0].submit()
        else
          $('#stripe_error').text(response.error.message)
          $('input[type=submit]').attr('disabled', false)