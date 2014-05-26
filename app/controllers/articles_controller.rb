class ArticlesController < ApplicationController
  before_filter(only: [:index, :show]) { @page_caching = true }
  caches_page :index, :show
  set_tab :blog

  def index
    if params[:tag]
      @tag = Tag.find_by_name!(params[:tag])
      @articles = @tag.articles.visibles.order('created_at DESC').page(params[:page]).per(10)
    else
      @articles = Article.visibles.order('created_at DESC').page(params[:page]).per(10)
    end

    rescue ActiveRecord::RecordNotFound
    redirect_to blog_url, flash: { error: "Record not found." }
  end

	def show
    @article = Article.friendly.includes(:tags).find(params[:slug])
    @page_title       = "#{@article.seo_title.present? ? @article.seo_title : @article.title} | #{t 'theme.site_name'}"
    @page_description = @article.seo_description

    if !@article.visible?
      raise ActionController::RoutingError.new('Not Found')
    elsif request.path != "/blog/#{@article.slug}"
      redirect_to "/blog/#{@article.slug}", status: :moved_permanently
    end
  end

end