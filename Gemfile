source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.1'

# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'debase'
  gem 'ruby-debug-ide'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


gem 'discordrb', git: 'https://github.com/shardlab/discordrb.git', branch: "main"
gem 'google-api-client', require: ['google/apis/customsearch_v1', 'google/apis/youtube_v3', 'google/apis/translate_v2']
gem 'require_all'
gem 'redd', git: 'https://github.com/avinashbot/redd.git'
gem 'rufus-scheduler'
gem 'faye-websocket'
gem 'rest-client'
gem 'mini_racer'
gem 'mtg_sdk'
gem 'dotenv'
gem 'pg'
gem 'net-ssh'
gem 'net-scp'
gem 'rake'
gem "octokit", "~> 4.0"
gem 'steam-api'
gem 'nokogiri'
gem 'kovid', github: "siaw23/kovid"
gem "sinatra", "~> 2.0"
gem "haml", "~> 5.1"
gem "cowsay", "~> 0.3.0"

group :test do
  gem 'test-unit-rr', require: false
  gem 'simplecov', '< 0.18', require: false
end
gem "foreman", "~> 0.87.2"

gem "dotenv-rails", "~> 2.7", require: 'dotenv/rails-now'

gem "view_component", require: "view_component/engine"

gem "omniauth", "~> 2.0"
gem "omniauth-discord", "~> 1.0"

gem "omniauth-rails_csrf_protection", "~> 1.0"
gem 'bootstrap', '~> 5.0.0.beta1'
gem "tailwindcss-rails", "~> 0.3.3"
