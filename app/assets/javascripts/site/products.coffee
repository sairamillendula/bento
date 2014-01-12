class @ProductOptionSelector

  @setup: (variants, option_refs) ->
    variant_refs = {}
    for variant in variants
      arr = []
      arr.push option for ref, option of variant.options
      variant_refs[arr] = variant

    for ref, option of option_refs
      $("##{option}").change ->
        variant = (elem.value for elem in $('.option'))
        if variant_refs[variant]
          if variant_refs[variant].in_stock > 0
            $('#price').text("$#{parseFloat(variant_refs[variant].price).toFixed(2)}")
            $('#sale-price').text("$#{parseFloat(variant_refs[variant].reduced_price).toFixed(2)}")
            if variant_refs[variant].reduced_price
              $('#price').addClass('line-through')
              $('#sale-price').show()
            else
              $('#price').removeClass('line-through')
              $('#sale-price').hide()
            $('#add-to-cart').show()
            url = $('#add-to-cart').closest('form').attr('action')
            url = url.replace(/product_id/, 'product_variant_id').replace(/(\=)\d+/, "$1#{variant_refs[variant].id}")
            $('#add-to-cart').closest('form').attr('action', url)
          else
            $('#price').removeClass('line-through').text(I18n.t('out_of_stock'))
            $('#sale-price').hide()
            $('#add-to-cart').hide()  
        else
          $('#price').removeClass('line-through').text(I18n.t('not_available'))
          $('#sale-price').hide()
          $('#add-to-cart').hide()