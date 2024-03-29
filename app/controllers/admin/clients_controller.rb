class Admin::ClientsController < Admin::BaseController
  set_tab :clients
  helper_method :sort_column, :sort_direction

  def index
    @clients = User.includes(:orders).order(sort_column + " " + sort_direction).page(params[:page]).per(15)
  end

  def show
    @client = User.includes(:orders).find(params[:id])
  end

  def export
    @clients = User.order('created_at DESC')

    respond_to do |format|
      format.csv { 
        content = @clients.to_csv
        content = content.encode("UTF-8")
        send_data content, filename: "#{t 'clients.title'}.csv", type: 'text/csv; charset=utf-8; header=present'
      }
    end
  end

  private

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

end