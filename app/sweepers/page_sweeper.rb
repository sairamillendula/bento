class PageSweeper < ActionController::Caching::Sweeper
	observe Page

	def sweep(page)
		expire_page page_path(page)
		FileUtils.rm_rf "#{page_cache_directory}/page"
	end
	alias_method :after_create, :sweep
	alias_method :after_update, :sweep
	alias_method :after_destroy, :sweep
end