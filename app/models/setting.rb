class Setting < RailsSettings::CachedSettings
	attr_accessible :var, :logo

  def self.logo
    Picture.find_by_id(self['logo'])
  end
end
