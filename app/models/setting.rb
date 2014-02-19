class Setting < RailsSettings::CachedSettings

  def self.logo
    Picture.find_by(id: self['logo'])
  end

  def abandonned_carts_reminder
  	Setting.abandonned_carts_reminder
  end

end
