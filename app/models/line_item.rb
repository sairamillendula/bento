class LineItem < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :variant, class_name: 'ProductVariant'
  belongs_to :cart, counter_cache: true
  belongs_to :order


  # CALLBACKS
  # ------------------------------------------------------------------------------------------------------
  before_save :ensure_valid_quantity
  validate :min_quantity, on: :create

  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def subtotal
  	quantity * price
  end

  def summary
    "#{quantity} * #{variant.product.name} (#{price})"
  end

  protected

  def min_quantity
    errors.add(:quantity, 'Wrong quantity') if quantity % variant.min_quantity_for_reseller_order != 0
  end

  private

    def ensure_valid_quantity
      self.quantity = 0 if quantity < 0
    end

end