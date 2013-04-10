class Admin::ClientsController < Admin::BaseController
  set_tab :clients
  helper_method :sort_column, :sort_direction

  def index
    @clients = User.order(sort_column + " " + sort_direction).page(params[:page]).per(15)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clients }
    end
  end

  def show
    @client = User.includes(:orders).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client }
    end
  end

private

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

end