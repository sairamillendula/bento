class NewProductForm
  constructor: ->

  setup: ->
    @resetOptionIds()

    window.nestedFormEvents.insertFields = (content, assoc, link) =>
      if assoc == 'options'
        $field = $('#options_fields tbody').append(content)
        $field.find('.option_values:visible').tagsInput
          'defaultText': ''
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
      if @isValid()
        @generateVariants() 
      else
        @resetVariants()  

    # Add product option handle
    $(document).on 'nested:fieldAdded:options', (event) =>
      @resetOptionIds()
      $('#options_fields .remove_nested_fields').show()

      if $('#options_fields').find('tbody tr:visible').length == 3
        $('#add_product_option').hide()
      else
        $('#add_product_option').show()

    $('#product_auto_generate_variants').click ->
      if $(this).is(':checked')
        $('#select-variants').hide()
      else
        $('#select-variants').show()

    $('.option_values').tagsInput
      'defaultText': ''
      'onAddTag': @addOption
      'onRemoveTag': @removeOption    

  addOption: (field, optionValue) =>
    if @isValid()
      @generateVariants() 
    else
      @resetVariants()  

  removeOption: (value) =>
    if @isValid()
      @generateVariants() 
    else
      @resetVariants()  

  isValid: ->
    for optionValue in $('.option_values')
      if !($(optionValue).val())
        return false
    return true

  resetVariants: ->
    $('#select-variants').hide()
    $('#auto-create').hide()

  generateVariants: ->
    variants = []
    if $('#option-1').length > 0
      option1 = $.map $("#option-1 .option_values").val().split(','), (n, i) -> return {name: "<span class=\"option-1\">#{n}</span>", value: n}
      variants = @pushOpt(option1, [])

    if $('#option-2').length > 0
      option2 = $.map $("#option-2 .option_values").val().split(','), (n, i) -> return {name: "<span class=\"option-2\">#{n}</span>", value: n}
      variants = @pushOpt(variants, option2) 

    if $('#option-3').length > 0
      option3 = $.map $("#option-3 .option_values").val().split(','), (n, i) -> return {name: "<span class=\"option-3\">#{n}</span>", value: n}
      variants = @pushOpt(variants, option3)
    
    $('#auto-create').show()
    $('#variant-count').text(variants.length)

    if variants.length > 100
      $('#product_auto_generate_variants').attr('checked', 'checked')
      $('#product_auto_generate_variants').attr('disabled', true)
      $('#select-variants').hide()
      $('#too-many-variants').show()
    else
      $('#too-many-variants').hide()
      $('#product_auto_generate_variants').attr('disabled', false)
      if $('#product_auto_generate_variants').is(':checked')
        $('#select-variants').hide()
      else
        $('#select-variants').show()

    $('#table-variants tbody').empty()
    for variant, idx in variants
      name = $.map variant, (n, i) -> return n.name
      $('#table-variants tbody').append $.parseHTML(tmpl("tmpl-product-option", {name: name.join(' / '), variants: variant, idx: idx + 1}))

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

@new_product_form = new NewProductForm()
  
class EditProductForm
  constructor: ->

  setup: ->

    window.nestedFormEvents.insertFields = (content, assoc, link) =>
      if assoc == 'variants'
        return $('#table-variants tbody').append(content)
      else if assoc == 'options'
        return $('#table-options tbody').append(content)
      else
        return $(content).insertBefore(link)

    $(document).on 'nested:fieldAdded:options', (event) =>
      if $('#table-options').find('tbody tr:visible').length == 3
        $('#add_product_option').hide()
      else
        $('#add_product_option').show()    

    $(document).on 'nested:fieldRemoved:options', (event) =>
      if $('#table-options').find('tbody tr:visible').length == 3
        $('#add_product_option').hide()
      else
        $('#add_product_option').show()    

    $(document).on 'click', '.close-modal', (e) ->
      $('#edit-option-modal').modal('hide')
      return false

    $(document).on 'hidden', '#edit-option-modal', (e) ->
      $.get $('.close-modal').attr('href'), (html) ->
        $('#edit-option-modal').replaceWith(html)

@edit_product_form = new EditProductForm()

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
            $('#add-to-cart').show()
            url = $('#add-to-cart').closest('form').attr('action')
            url = url.replace(/product_id/, 'product_variant_id').replace(/(\=)\d+/, "$1#{variant_refs[variant].id}")
            $('#add-to-cart').closest('form').attr('action', url)
          else
            $('#price').text('Out of stock')
            $('#add-to-cart').hide()  
        else
          $('#price').text('Not available')
          $('#add-to-cart').hide()

class @ProductUploader
  @setup: ->
    Holder.add_theme("bright", { background: "#eee", foreground: "#aaa", size: 60}).run()

    $('ul.pictures').on('click', '.modalable', Helpers.modalableHandler)

    $pictures_container = $('#pictures-container')
    $('#fileupload').fileupload
      filesContainer: $pictures_container
      previewMaxWidth : 200
      previewMaxHeight : 150
      acceptFileTypes: /(.|\/)(gif|jpe?g|png)$/i
      maxFileSize: 5242880 #5M
      autoUpload: true

    $.getJSON $('#fileupload').prop('action'), (files) ->
      fu = $('#fileupload').data('blueimpFileupload')
      fu._adjustMaxNumberOfFiles(-files.length)
      template = fu._renderDownload(files).appendTo($pictures_container)

      fu._reflow = fu._transition && template.length && template[0].offsetWidth
      template.addClass('in')
      $('#loading').remove()

    $("ul.pictures").sortable
      items: "li.picture"
      placeholder: "alert",
      forcePlaceholderSize: true,
      update: ->
        $.post($(this).data('update-url'), $(this).sortable('serialize'))
