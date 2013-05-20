class Admin::ArticlesController < Admin::BaseController
  set_tab :articles
  cache_sweeper :article_sweeper

  def index
    @articles = Article.order(sort_column + " " + sort_direction).page(params[:page]).per(15)
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
    @article.author_id = current_user.id
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to admin_article_url(@article), notice: 'Article was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to admin_article_url(@article), notice: 'Article was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to admin_articles_url, notice: 'Article was successfully deleted.' }
    end
  end

private

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def sort_column
    Article.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end

end