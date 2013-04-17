class ProductForm
  constructor: ->
    console.log 'init ProductOption'

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
    # a = []
    # @generateVariants(a)
    # console.log a
    # @generateVariants(arr)
    # console.log arr
    console.log @pushOpt([1,2,4], 6)
    console.log @pushOpt([1,2,4], 7)

    optionName = $(field).closest('tr').find('.option-name').val()

    $('#options_fields tbody .option_values').each (index, optionValueField) ->
      # console.log $(optionValueField).val()

    $('#variants tbody').append $.parseHTML(tmpl("tmpl-product-option", {name: optionValue}))

  removeOption: (value) =>
    # console.log value
    @generateVariants(value)

  generateVariants: (result=[], i=0, temp=[], source=[[1,2,3], [4,5], [6,7]]) =>
    if i < source.length
      for val in source[i]
        temp.push(val)
        if i == source.length - 1
          result.push(temp)
          temp = []
      i++
      @generateVariants(result, i, temp, source)
        

    # for arr, i in source
    #   console.log "loop arr[#{i}]=#{arr}"
    #   for val in arr
    #     console.log val
    # if arr[i] != undefined
    #   console.log "loop arr[#{i}]=#{arr[i]}"
    #   for value in arr[i]
    #     console.log value
    #     i++
    #     @generateVariants(result, i, temp, arr[i])
      # $.each arr[i], (idx, v) =>
      #   console.log v
      #   i++
      #   @generateVariants(result, i, temp, arr[i])

  pushOpt: (source, val) ->
    result = []
    if source.length > 0
      $.each source, (idx, v) ->
        result.push [v, val]
    else
      result.push(val)
    result    
  
  resetOptionIds: ->
    $('#options_fields tbody tr').each (index, tr) ->
      $(tr).attr('id', "option-#{index + 1}")

  

@product_form = new ProductForm()
  
