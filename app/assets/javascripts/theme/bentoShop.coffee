# re-write version of cbpShop
class @BentoShop
  @setup: (container) ->
    $container = $(container)

    $('ul.pggrid > li', $container).each (index, product) ->
      $product = $(product)
      $rotate = $product.find('span.rotate').first()
      $rotate.click -> rotateItem(this, $product)

      # add to cart
      $product.find('.opt-cart').first().click ->
        addToCart $(this).data('url') + "&authenticity_token=#{$('meta[name="csrf-token"]').attr('content')}"

      $product.find('.opt-fav span').click ->
        window.open($(this).data('url'), '_blank')

      $product.find('.opt-tooltip span').click ->
        $this = $(this)
        $('.item-flip img').attr('src', $this.data('image-url'))
        $placeholder = $this.closest('.opt-tooltip').prev()
        $placeholder.attr('data-color', $this.data('color'))
        $placeholder.text($this.text())
        $product.find('.opt-cart').first().attr('data-url', $this.data('add-to-cart'))
        
        
  rotateItem = (trigger, $product) ->
    $trigger = $(trigger)
    $item = $product.find('div.item').first()

    if $item.data('open') == 'open'
      $item.data('open', '')
      $trigger.removeClass('rotate-active')
      $item.removeClass('item-showback')
    else
      $item.data('open', 'open')
      $trigger.addClass('rotate-active')
      $item.addClass('item-showback')  

  addToCart = (url) ->
    $('body').append($('<form/>', {
      id: 'add-to-cart-form',
      method: 'POST',
      action: url
    }))
    $('#add-to-cart-form').submit()
