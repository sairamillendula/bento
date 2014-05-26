class Admin::ArticlesController < Admin::BaseController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  set_tab :articles
  cache_sweeper :article_sweeper

  def index
    @articles = Article.includes(:author).order(sort_column + " " + sort_direction).page(params[:page]).per(15)
  end

  def show
  end

  def new
    @article = Article.new
    @article.author_id = current_user.id
  end

  def edit
  end

  def create
    @article = Article.new(safe_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to admin_article_url(@article), notice: 'Article was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update_attributes(safe_params)
        format.html { redirect_to admin_article_url(@article), notice: 'Article was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to admin_articles_url, notice: 'Article was successfully deleted.' }
    end
  end

  private

    def set_article
      @article = Article.friendly.find(params[:id])
    end

    def safe_params
      params.require(:article).permit(:content, :visible, :slug, :title, :author_id, :tag_tokens, :meta_tag, :seo_title, :seo_description)
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

    def sort_column
      Article.column_names.include?(params[:sort]) ? params[:sort] : "title"
    end

end
