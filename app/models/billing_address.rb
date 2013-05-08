class BillingAddress < Address

  validates_presence_of :address1, :city, :postal_code, :country, :unless => Proc.new{ |a| a.bypass_validation}
  attr_accessor :also_shipping_address

  attr_accessible :also_shipping_address

  def also_shipping_address
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(@also_shipping_address)
  end
end