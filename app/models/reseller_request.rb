class ResellerRequest < ActiveRecord::Base
	belongs_to :user

  validates_presence_of :business_name, :country, :city, :who_are_you
end