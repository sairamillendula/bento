class Setting < RailsSettings::CachedSettings

  def self.logo
    Picture.find_by(id: self['logo'])
  end
  
end
