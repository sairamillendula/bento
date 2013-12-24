class AuditTrail < ActiveRecord::Base
  
  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :auditable, polymorphic: true
  belongs_to :user
  

  # SCOPES
  # ------------------------------------------------------------------------------------------------------
  scope :successes, -> { where(success: true) }
  scope :errors, -> { where(success: false) }

end
