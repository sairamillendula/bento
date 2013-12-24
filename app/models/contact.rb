class Contact
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  

  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessor :name, :email, :content
  

  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :name, :content, :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_length_of :content, maximum: 500
  

  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
end