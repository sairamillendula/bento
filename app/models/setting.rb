class Setting < RailsSettings::CachedSettings

  def self.logo
    Picture.find_by_id(self['logo'])
  end
  
end
