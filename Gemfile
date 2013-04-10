source 'https://rubygems.org'

gem 'rails', '3.2.13'

gem 'mysql2'
gem 'capistrano'
gem 'sorcery'
gem 'nested_form'
gem 'simple_form'
gem 'country_select'
gem 'jquery-rails'
gem 'rails_bootstrap_helper', :git => "https://github.com/hoangnghiem/rails_bootstrap_helper.git"
gem 'tabs_on_rails', "~> 2.1.1"
gem 'friendly_id'
gem 'redcarpet'
#gem 'prawn', :git => "git://github.com/prawnpdf/prawn.git"
gem 'whenever', :require => false
gem 'ransack'
gem 'kaminari-bootstrap'
gem "paperclip"


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
  gem 'jquery-fileupload-rails', :git => "git://github.com/tors/jquery-fileupload-rails.git"
end

group :development, :test do
  gem 'faker', '1.0.1'
  gem 'hirb'
end

group :development do
  gem 'rack-mini-profiler'
  gem 'thin'
  gem 'letter_opener'
  gem 'better_errors'
  gem 'quiet_assets'
end

group :production, :staging do
  gem 'exception_notification'
  gem 'unicorn'
end