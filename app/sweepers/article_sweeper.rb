class ArticleSweeper < ActionController::Caching::Sweeper
	observe Article

	def sweep(article)
		expire_page blog_path, controller: "articles", action: :index
		expire_page article_path(article)
		FileUtils.rm_rf "#{page_cache_directory}/articles/page"
	end
	alias_method :after_create, :sweep
	alias_method :after_update, :sweep
	alias_method :after_destroy, :sweep
end