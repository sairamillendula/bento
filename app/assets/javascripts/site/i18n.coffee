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
      'incorrect_number': "The card number is incorrect"
      'invalid_number': "The card number is not a valid credit card number"
      'invalid_expiry_month': "The card's expiration month is invalid"
      'invalid_expiry_year': "The card's expiration year is invalid"
      'invalid_cvc': "The card's security code is invalid"
      'expired_card': "The card has expired"
      'incorrect_cvc': "The card's security code is incorrect."
      'incorrect_zip': "The card's zip code failed validation."
      'card_declined': "The card was declined."
      'missing': "There is no card on a customer that is being charged."
      'processing_error': "An error occurred while processing the card."
    'fr':  
      'save': "Save"
      'delete': "Delete"
      'loading': 'Loading...'
      'are_you_sure': 'Are you sure?'
      'are_you_sure_this_cannot_be_undone': 'Are you sure? This is definitive'
      'closed': 'closed'
      'close': 'Close'
      'cancel': 'Cancel'
      'incorrect_number': "The card number is incorrect in French"
      'invalid_number': "The card number is not a valid credit card number"
      'invalid_expiry_month': "The card's expiration month is invalid"
      'invalid_expiry_year': "The card's expiration year is invalid"
      'invalid_cvc': "The card's security code is invalid"
      'expired_card': "The card has expired"
      'incorrect_cvc': "The card's security code is incorrect."
      'incorrect_zip': "The card's zip code failed validation."
      'card_declined': "The card was declined."
      'missing': "There is no card on a customer that is being charged."
      'processing_error': "An error occurred while processing the card."
  @t: (key) ->
    @_locales[CURRENT_LOCALE][key]