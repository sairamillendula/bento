class ShippingAddress < Address

  validates_presence_of :full_name, :address1, :city, :postal_code, :country, :unless => Proc.new{ |a| a.bypass_validation}

end