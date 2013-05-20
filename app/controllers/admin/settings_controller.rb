class Admin::SettingsController < Admin::BaseController
  
  def edit
    set_tab :settings
  end

  def current
    set_tab :current

    @settings = Setting.all
    @settings.inspect
    a = {}
    @settings = @settings.each {|s| a[s.key] = s.value}
    @settings = a
  end
  
  def update
    if file = params[:setting].delete(:logo)
      logo = Picture.new
      logo.upload = file
      logo.save
      Setting.logo.destroy if Setting.logo
      Setting['logo'] = logo.id
    end

    params[:setting].each do |k, v|
      Setting[k] = v
    end

    redirect_to admin_dashboard_path, notice: 'Settings were successfully saved.'
  end

end