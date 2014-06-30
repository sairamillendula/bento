class CollectionSweeper < ActionController::Caching::Sweeper
	observe Collection

	def sweep(collection)
		expire_page collection_path(collection)
		FileUtils.rm_rf "#{page_cache_directory}/collections/page"
	end
	alias_method :after_create, :sweep
	alias_method :after_update, :sweep
	alias_method :after_destroy, :sweep
end