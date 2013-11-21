$ ->
  previousTimeout = null

  $form = $('#global-search')
  $input = $form.find('input')

  data = ->
    out = {}
    out[$input.attr('name')] = $input.val()
    out
  search = -> $.get($form.attr('action'), data()).done searchDone
  searchDone = (response) ->
    content = $(response).find('#content')
    $('#content').replaceWith(content)

  $input.keyup ->
    if previousTimeout
      clearTimeout previousTimeout
    previousTimeout = setTimeout search, 100
