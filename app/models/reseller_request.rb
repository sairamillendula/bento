class ResellerRequest < ActiveRecord::Base
	belongs_to :user

  attr_accessible :country, :business_name, :city, :who_are_you, :user_id
  attr_accessible :country, :business_name, :city, :who_are_you, :user_id, :approved, as: :manager

  validates_presence_of :business_name, :country, :city, :who_are_you, :user_id
end