require 'money'
require 'money/bank/google_currency'
Money.default_currency = Money::Currency.new(ENV['STRIPE_CURRENCY'].upcase)
Money::Bank::GoogleCurrency.ttl_in_seconds = 86400
Money.default_bank = Money::Bank::GoogleCurrency.new