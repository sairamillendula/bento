class Admin::PagesController < Admin::BaseController
  set_tab :pages
  cache_sweeper :page_sweeper
  helper_method :sort_column, :sort_direction

  def index
    @pages = Page.all
  end
  
  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to admin_page_path(@page) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to admin_page_url(@page), notice: 'Page was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

private

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def sort_column
    Page.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

end