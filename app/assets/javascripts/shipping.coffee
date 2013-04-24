class Shipping
  constructor: ->

  setup: ->
    $("#rates").on 'change', '.criteria', ->
      if $(this).val() == 'price-based'
        $(this).closest('.rate').find('.unit').text('$')
      else
        $(this).closest('.rate').find('.unit').text('kg')

@shipping = new Shipping()    