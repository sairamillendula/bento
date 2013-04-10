class BillingAddress < Address

  validates_presence_of :address1, :city, :postal_code, :country, :if => Proc.new{ |a| a.bypass_validation == '0'}

end