class ProductForm
  constructor: ->

  setup: ->
    @resetOptionIds()

    window.nestedFormEvents.insertFields = (content, assoc, link) =>
      if assoc == 'options'
        $field = $('#options_fields tbody').append(content)
        $field.find('.option_values:visible').tagsInput
          'onAddTag': @addOption
          'onRemoveTag': @removeOption
        return $field
      else
        return $(content).insertBefore(link)

    # toggle multiple options checkbox click
    $('#product_has_options').click ->
      if $(this).is(':checked')
        $('#options-container').show()
      else
        $('#options-container').hide()

    # Remove product option handle
    $(document).on 'nested:fieldRemoved:options', (event) =>
      event.field.remove() # completely remove from dom
      if $('#options_fields').find('tbody tr:visible').length == 3
        $('#add_product_option').hide()
      else
        if $('#options_fields').find('tbody tr:visible').length == 1
          $('#options_fields .remove_nested_fields').hide()
        else
          $('#options_fields .remove_nested_fields').show()
        $('#add_product_option').show()

      @resetOptionIds()  

    # Add product option handle
    $(document).on 'nested:fieldAdded:options', (event) =>
      $('#options_fields .remove_nested_fields').show()

      if $('#options_fields').find('tbody tr:visible').length == 3
        $('#add_product_option').hide()
      else
        $('#add_product_option').show()

      @resetOptionIds()

    $('.option_values').tagsInput
      'onAddTag': @addOption
      'onRemoveTag': @removeOption    

  addOption: (field, optionValue) =>
    variants = @generateVariants()
    $('#table-variants tbody').empty()
    for variant in variants
      $('#table-variants tbody').append $.parseHTML(tmpl("tmpl-product-option", {name: variant.join(' / ')}))

  removeOption: (value) =>
    variants = @generateVariants()
    $('#table-variants tbody').empty()
    for variant in variants
      $('#table-variants tbody').append $.parseHTML(tmpl("tmpl-product-option", {name: variant.join(' / ')}))

  generateVariants: ->
    variants = []
    if $('#option-1').length > 0
      option1 = $.map $("#option-1 .option_values").val().split(','), (n, i) -> return "<span class=\"option-1\">#{n}</span>"
      variants = @pushOpt(option1, [])

    if $('#option-2').length > 0
      option2 = $.map $("#option-2 .option_values").val().split(','), (n, i) -> return "<span class=\"option-2\">#{n}</span>"
      variants = @pushOpt(variants, option2) 

    if $('#option-3').length > 0
      option3 = $.map $("#option-3 .option_values").val().split(','), (n, i) -> return "<span class=\"option-3\">#{n}</span>"
      variants = @pushOpt(variants, option3)   

    return variants

  pushOpt: (arr1, arr2) ->
    result = []
    for v1 in arr1
      if arr2.length > 0
        for v2 in arr2
          if v1 instanceof Array
            tmp = v1.slice()
            tmp.push(v2)
            result.push(tmp)
          else
            result.push([v1, v2])
      else
        result.push([v1])      
    return result    
    
  
  resetOptionIds: ->
    $('#options_fields tbody tr').each (index, tr) ->
      $(tr).attr('id', "option-#{index + 1}")

  

@product_form = new ProductForm()
  
