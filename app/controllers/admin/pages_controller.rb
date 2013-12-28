class Admin::PagesController < Admin::BaseController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  set_tab :pages
  cache_sweeper :page_sweeper
  helper_method :sort_column, :sort_direction

  def index
    @pages = Page.order('name')
  end
  
  def new
    @page = Page.new
  end

  def create
    @page = Page.new(safe_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to admin_page_path(@page) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @page.update_attributes(safe_params)
        format.html { redirect_to admin_page_url(@page), notice: 'Page was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @page.destroy

    respond_to do |format|
      format.html { redirect_to admin_pages_url, notice: 'Page was successfully deleted.' }
    end
  end

  private
    
    def set_page
      @page = Page.friendly.find(params[:id])
    end

    def safe_params
      params.require(:page).permit(:name, :slug, :content, :visible, :klass, :meta_tag, :seo_title, :seo_description)
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def sort_column
      Page.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

end
