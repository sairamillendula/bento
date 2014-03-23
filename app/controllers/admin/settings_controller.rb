class Admin::SettingsController < Admin::BaseController

  def show
    set_tab :settings
    @setting = Setting.first_or_create
  end

# TODO remove if unsed
  # def current
  #   set_tab :current

  #   @settings = Setting.first
  #   @settings.inspect
  #   a = {}
  #   @settings = @settings.each {|s| a[s.key] = s.value}
  #   @settings = a
  # end

  def update
     @settings = Setting.first_or_create
    if params[:setting]
      if file = params[:setting].delete(:logo)
        logo = Picture.new
        logo.upload = file
        logo.save
        if Setting.logo
         picture = Picture.find_by_id(Setting.logo)
         if picture.present?
          picture.delete
        end
      end
    @settings.logo_id = logo.id
    end
    @settings.update(safe_params)
  end

    redirect_to admin_settings_path, notice: 'Settings were successfully saved.'
  end

  def remove_logo
    logo = Picture.find_by_id(Setting.first.logo_id)
    logo.delete if logo

    redirect_to admin_settings_path, notice: 'Settings were successfully saved.'
  end

  private

    def safe_params
      params.require(:setting).permit(:logo, :abandoned_carts_reminder)
    end

end