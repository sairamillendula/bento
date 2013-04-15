class ArticlesController < ApplicationController
  before_filter(only: [:index, :show]) { @page_caching = true }
  caches_page :index, :show
  set_tab :blog

  def index
    if params[:tag]
      @tag = Tag.find_by_name(params[:tag])
      @articles = @tag.articles.visibles.order('created_at DESC').page(params[:page]).per(10)
    else
      @articles = Article.visibles.order('created_at DESC').page(params[:page]).per(10)
    end
  end

	def show
    @article = Article.includes(:meta_tag, :tags).find(params[:slug])
    @page_title       = "#{@article.meta_tag && @article.meta_tag.title.present? ? @article.meta_tag.title : @article.title} | #{t 'site_name'}"
    @page_description = @article.try(:meta_tag.description)
    
    if !@article.visible?
      raise ActionController::RoutingError.new('Not Found')
    elsif request.path != "/blog/#{@article.slug}"
      redirect_to "/blog/#{@article.slug}", status: :moved_permanently
    end
  end

end