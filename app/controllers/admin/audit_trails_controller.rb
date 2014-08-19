class Admin::AuditTrailsController < Admin::BaseController
  set_tab :audit
  helper_method :sort_column, :sort_direction

  def index
    @audit_trails = AuditTrail.includes(:user).order(sort_column + " " + sort_direction).page(params[:page]).per(30)
  end

  private

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

    def sort_column
      AuditTrail.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

end