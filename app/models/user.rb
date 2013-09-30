class User < ActiveRecord::Base
  authenticates_with_sorcery!

  include PgSearch
  multisearchable :against => [:first_name, :last_name, :email]
  pg_search_scope :search_by_keyword, 
                  :against => [:first_name, :last_name, :email],
                  :using => {
                    :tsearch => {
                      :prefix => true # match any characters
                    }
                  },
                  :ignoring => :accents

  # ASSOCIATIONS
  # ==================================================
  has_many :orders, :dependent => :destroy, foreign_key: 'client_id'
  has_many :posts
  has_one  :reseller_request
  accepts_nested_attributes_for :reseller_request, :reject_if => lambda {|rr| rr[:location].blank?}, :allow_destroy => true
  has_many :reviews, class_name: "ProductReview"
  has_many :addresses, :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :addresses

  # SCOPES
  # ==================================================
  scope :admin, where(admin: true)
  scope :active, where(active: true)
  scope :inactive, where(active: false)
  scope :exclude_users, lambda {|user_ids| where("id NOT IN (?)", user_ids)}
  scope :normal, where(admin: false)
  scope :active_resellers, where(reseller: true)
  scope :resellers, joins(:reseller_request)
  scope :today, where("created_at BETWEEN '#{DateTime.now.beginning_of_day}' AND '#{DateTime.now.end_of_day}'")
  scope :weekly, where(created_at: Time.now.beginning_of_week..Time.now.end_of_week)
  scope :monthly, where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)

  # ATTRIBUTES
  # ==================================================
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :localization,
                  :addresses_attributes, :reseller_request_attributes

  # attributes that only admin type users can be assigned
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :localization,
                  :addresses_attributes, :active, :admin, :reseller,
                  :reseller_request_attributes, :as => :manager

  # VALIDATIONS
  # ==================================================
  validates_confirmation_of :password
  validates_presence_of :password, on: :create
  validates_presence_of :email, :first_name, :last_name
  validates_uniqueness_of :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
  validates_length_of :password, minimum: 6, if: :password
  validates_confirmation_of :password, if: :password
  
  before_create :format_fields

  # INSTANCE METHODS
  # ==================================================
  def admin?
   admin == true  
  end

  def full_name
    "#{first_name} #{last_name}"
  end
  
  def email_helper
    "#{full_name} <#{email}>"
  end

  def self.to_csv(options = {})
    headers = %w{Email FirstName LastName}
    header_indexes = Hash[headers.map.with_index{|*x| x}]

    CSV.generate(options) do |csv|
      csv << headers
      all.each do |client|
        data = {}
        data["Email"] = client.email
        data["FirstName"] = client.first_name
        data["LastName"] = client.last_name

        row = []
        header_indexes.each do |field, index|
          row << data[field] || ''
        end
        csv << row
      end
    end
  end

  private

    def format_fields
      self.email = email.downcase
      self.first_name = first_name.titleize
      self.last_name = last_name.titleize
    end

end