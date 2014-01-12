class LineItem < ActiveRecord::Base
	
  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :variant, class_name: 'ProductVariant'
  belongs_to :cart
  belongs_to :order


  # CALLBACKS
  # ------------------------------------------------------------------------------------------------------
  before_save :ensure_valid_quantity
  

  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def subtotal
  	quantity * price
  end

  private

    def ensure_valid_quantity
      self.quantity = 0 if quantity < 0
    end

end