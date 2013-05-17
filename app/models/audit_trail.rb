class AuditTrail < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
  belongs_to :user
  
  scope :successes, where(success: true)
  scope :errors, where(success: false)

  attr_accessible :auditable_id, :auditable_type, :message, :success, :user_id

end