class @Order
  @setup: (shipping_methods) ->
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))

    $('.cc-number').payment('formatCardNumber');
    $('.cc-cvc').payment('formatCardCVC');

    $('.cc-number').keyup ->
      $(this).next().remove()
      cardType = $.payment.cardType($(this).val())
      switch cardType
        when "visa"
          $(this).after('<span class="card visa">Visa</span>')
        when "mastercard"
          $(this).after('<span class="card mastercard">Master Card</span>')
        when "discover"
          $(this).after('<span class="card discover">Discover</span>')
        when "amex"
          $(this).after('<span class="card amex">American Express</span>')

    if CURRENT_LOCALE == 'fr'
      accounting.settings.currency.thousand = "."
      accounting.settings.currency.decimal = ","
      accounting.settings.currency.format = "%v %s"
    else
      accounting.settings.currency.format = "%s%v"

    $('#new_order').submit ->
      $('input[type=submit]').attr('disabled', true)
      processCard()
      return false

    mappings = []
    mappings[shipping_method.id] = shipping_method.price for shipping_method in shipping_methods
    $('#shipping_rate').change ->
      shipping_price = mappings[$(this).val()]
      $('#shipping').data('value', shipping_price)
      if shipping_price > 0
        $('#shipping-row').css('display', '')
      else
        $('#shipping-row').css('display', 'none')
      calculateOrder()

  processCard = ->
    card =
      name: $('#card_holder').val()
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, handleStripeResponse)

  handleStripeResponse = (status, response) ->
    if status == 200
      $('#order_stripe_card_token').val(response.id)
      $('#new_order')[0].submit()
    else
      $('#stripe_error').text(I18n.t(response.error.code))
      $('input[type=submit]').attr('disabled', false)

  calculateOrder = ->
    subtotal = parseFloat($('#subtotal').data('value')) || 0
    tax = parseFloat($('#tax').data('value')) || 0
    discount = parseFloat($('#discount').data('value')) || 0
    shipping = parseFloat($('#shipping').data('value')) || 0
    total = subtotal + tax + shipping - discount
    $('#shipping').text accounting.formatMoney(shipping)
    $('#total').text accounting.formatMoney(total)
