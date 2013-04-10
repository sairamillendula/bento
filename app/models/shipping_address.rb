class ShippingAddress < Address

  validates_presence_of :address1, :city, :postal_code, :country

end