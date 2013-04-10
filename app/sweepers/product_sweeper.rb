class ProductSweeper < ActionController::Caching::Sweeper
	observe Product

	def sweep(article)
		expire_page root_url
		expire_page product_path(product)
		FileUtils.rm_rf "#{page_cache_directory}/product/page"
	end
	alias_method :after_create, :sweep
	alias_method :after_update, :sweep 
	alias_method :after_destroy, :sweep 
end