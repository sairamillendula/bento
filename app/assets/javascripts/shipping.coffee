class Shipping
  constructor: ->

  setup: ->
    $("#rates").on 'change', '.criteria', ->
      if $(this).val() == 'weight-based'
        $(this).closest('.rate').find('.unit').text('kg')
      else
        $(this).closest('.rate').find('.unit').text('$')

@shipping = new Shipping()