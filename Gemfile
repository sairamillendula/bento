source 'https://rubygems.org'

gem 'rails', '3.2.16'

gem 'pg'
gem 'pg_search'
gem 'activerecord-postgres-hstore'
gem 'sorcery'
gem 'nested_form'
gem 'simple_form'
gem 'jquery-rails', "2.3.0" # important since jquery-ui was removed from the gem
gem 'rails_bootstrap_helper', :git => "https://github.com/hoangnghiem/rails_bootstrap_helper.git"
gem 'tabs_on_rails', "~> 2.1.1"
gem 'friendly_id'
gem 'redcarpet'
gem 'prawn', :git => "git://github.com/prawnpdf/prawn.git"
#gem 'whenever', :require => false
gem 'ransack'
gem 'kaminari-bootstrap'
gem 'paperclip'
gem 'meta-tags', :require => 'meta_tags'
gem 'stripe'
gem 'figaro'
gem 'acts_as_list'
gem 'countries', :git => "https://github.com/hoangnghiem/countries.git"
gem 'famfamfam_flags_rails'
gem 'turbolinks'
gem 'omniauth-stripe-connect'
gem 'rails-settings-cached', "0.2.4"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
  gem 'jquery-fileupload-rails'
end

group :development, :test do
  gem 'faker', '1.0.1'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-nc'
  gem 'rack-mini-profiler'
  gem 'thin'
  gem 'letter_opener'
  gem 'better_errors'
  gem 'quiet_assets'
  gem 'binding_of_caller'
end

group :production do
  gem 'exception_notification'
  gem 'unicorn'
  gem 'therubyracer'
end