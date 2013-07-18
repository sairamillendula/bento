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
      'out_of_stock' : 'Out of stock'
      'not_available' : 'Not available'
      'fetching_more_products' : 'Fetching more products...'
    'fr':  
      'save': "Sauvegarder"
      'delete': "Supprimer"
      'loading': 'Chargement...'
      'are_you_sure': 'Êtes-vous sûr?'
      'are_you_sure_this_cannot_be_undone': 'Êtes-vous sûr? Cette action ne peut être annulée'
      'closed': 'fermé'
      'close': 'Fermer'
      'cancel': 'Annuler'
      'incorrect_number': "Le numéro de carte est incorrect"
      'invalid_number': "Le numéro de carte n'est pas valide"
      'invalid_expiry_month': "Le mois de la date d'expiration n'est pas valide"
      'invalid_expiry_year': "L'année de la date d'expiration n'est pas valide"
      'invalid_cvc': "Le code de sécurité n'est pas valide"
      'expired_card': "Cette carte a expirée"
      'incorrect_cvc': "Le code de sécurité est incorrect"
      'incorrect_zip': "The card's zip code failed validation."
      'card_declined': "La carte a été déclinée"
      'missing': "Il n'y a pas de carte attachée à ce client"
      'processing_error': "Une erreur est survenue"
      'out_of_stock' : 'Stock épuisé'
      'not_available' : 'Non disponible'
      'fetching_more_products' : 'Et bien plus encore...'
  @t: (key) ->
    @_locales[CURRENT_LOCALE][key]