class @I18n
  @_locales =
    'en':
      'save': "Save"
      'delete': "Delete"
      'loading': 'Loading...'
      'are_you_sure': 'Are you sure?'
      'are_you_sure_this_cannot_be_undone': 'Are you sure? This is definitive'
      'closed': 'closed'
      'close': 'Close'
      'cancel': 'Cancel'

  @t: (key) ->
    @_locales[CURRENT_LOCALE][key]