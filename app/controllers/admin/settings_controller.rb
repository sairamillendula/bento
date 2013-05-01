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
    params[:setting].each do |k, v|
      Setting[k] = v
    end
    # params.each do |key, value|
    #   s = Setting.where(:key => key).first
    #   if s.present?
    #     s.value = value
    #     s.save!
    #   end
    # end
    redirect_to admin_dashboard_path, notice: 'Settings were successfully saved.'
  end

end