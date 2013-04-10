class ArticlesController < ApplicationController
  before_filter(only: [:index, :show]) { @page_caching = true }
  caches_page :index, :show
  set_tab :blog

  def index
    if params[:tag]
      @tag = Tag.find_by_name(params[:tag])
      @articles = @tag.articles.public.order('created_at DESC').page(params[:page]).per(10)
    else
      @articles = Article.public.order('created_at DESC').page(params[:page]).per(10)
    end
  end

	def show
    @article = Article.find(params[:slug])
    
    if !@article.public?
      raise ActionController::RoutingError.new('Not Found')
    elsif request.path != "/blog/#{@article.slug}"
      redirect_to "/blog/#{@article.slug}", status: :moved_permanently
    end
  end

end