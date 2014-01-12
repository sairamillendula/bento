class BillingAddress < Address
  
  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessor :also_shipping_address


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :full_name, :address1, :city, :postal_code, :country, unless: Proc.new{ |a| a.bypass_validation} 
  

  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def also_shipping_address
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(@also_shipping_address)
  end
  
end