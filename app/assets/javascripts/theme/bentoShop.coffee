# re-write version of cbpShop
class @BentoShop
  @setup: (container) ->
    $container = $(container)

    console.log 
    
    $('ul.cbp-pggrid > li', $container).each (index, product) ->
      $product = $(product)
      $rotate = $product.find('span.cbp-pgrotate').first()
      $rotate.click -> rotateItem(this, $product)

      # add to cart
      $product.find('.cbp-pgoptcart').first().click ->
        addToCart $(this).data('url') + "&authenticity_token=#{$('meta[name="csrf-token"]').attr('content')}"
        
  rotateItem = (trigger, $product) ->
    $trigger = $(trigger)
    $item = $product.find('div.cbp-pgitem').first()

    if $item.data('open') == 'open'
      $item.data('open', '')
      $trigger.removeClass('cbp-pgrotate-active')
      $item.removeClass('cbp-pgitem-showback')
    else
      $item.data('open', 'open')
      $trigger.addClass('cbp-pgrotate-active')
      $item.addClass('cbp-pgitem-showback')  

  addToCart = (url) ->
    $('body').append($('<form/>', {
      id: 'add-to-cart-form',
      method: 'POST',
      action: url
    }))
    $('#add-to-cart-form').submit()
