source 'https://rubygems.org'

gem 'rails', '4.1.4'

# Use mysql as the database for Active Record
gem 'mysql2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use HAML for templates
gem 'haml-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# JS Locales
gem "i18n-js"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'foundation-rails', '5.0.2.0'

# mail custom styles
gem "actionmailer_inline_css"

# Gem for generating charts, based on Google Charts or Highcharts
gem "chartkick", "~> 1.2.1"

# Client for rest web services, connect to otrs api to validate data
gem "rest-client", "~> 1.6.7"

gem 'google-analytics-rails'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :test, :development do
  gem 'rspec-rails', '~> 3'
  gem 'factory_girl_rails', '~> 4.3.0'
  gem "fakeweb", "~> 1.3"
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
end

group :development do
  gem 'capistrano', '~> 2.15.4'
  gem 'rvm-capistrano'
  gem 'rename'
  gem 'spring'
  gem 'quiet_assets'
  gem 'transpec'
  gem 'railroady'

  # These are for code smells detection
  gem 'flog', require: false
  gem 'flay', require: false
  gem 'reek', require: false
end

group :test do
  gem "faker", "~> 1.2"
  gem "capybara"
  gem "database_cleaner", "~> 1.0.1"
  gem "launchy", "~> 2.3.0"
  gem "selenium-webdriver"
  gem 'simplecov', :require => false
  gem 'vcr', '~> 2.9.2'
  gem 'webmock', '~> 1.18.0', :require => false
end

gem 'dotenv-rails'
gem 'dotenv-deployment'
gem 'rails_config', '~> 0.4.2'

# authentication
gem 'devise'

# pagination
gem 'kaminari'

# gem for language recognition based on browser header Accept-Language property
gem 'http_accept_language'

# gem for browser detection
gem "browser"

# puma web server
gem "puma"
