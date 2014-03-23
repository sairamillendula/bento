class Setting < ActiveRecord::Base

  store_accessor :options, :logo_id, :abandoned_carts_reminder

  def self.logo
    Picture.find(Setting.first.logo_id) rescue nil
  end

end
