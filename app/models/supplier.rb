class Supplier < ActiveRecord::Base
  has_and_belongs_to_many :products

  attr_accessible :name
  
  validates_presence_of :name
  validates_uniqueness_of :name

  def to_param
  	name
  end

  def self.tokens(query)
	  suppliers = where("name like ?", "%#{query}%")
	  if suppliers.empty?
	    [{id: "<<<#{query}>>>", name: "New: \"#{query}\""}]
	  else
	    suppliers
	  end
	end

	def self.ids_from_tokens(tokens)
	  tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
	  tokens.split(',')
	end
end