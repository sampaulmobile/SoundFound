source 'https://rubygems.org'

# Use ruby v2
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0.0'

# Use sqlite3 as the database for Active Record
group :development do
  gem 'sqlite3'
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end

group :assets do
  gem 'jquery-ui-rails'
end

# Use unicorn as the app server
gem 'unicorn'

# Sidekiq + web interface
gem 'sidekiq', require: 'sidekiq/web'
gem 'sinatra', require: false
gem 'slim'

# For handling inline CSS in mailers
gem 'roadie'

# User authentication/etc.
gem 'devise'

# ActiveAdmin for admin page
gem 'activeadmin', github: 'gregbell/active_admin'

# Soundcloud
gem 'soundcloud'

# Bootstrap
gem 'bootstrap-sass', '2.1'

# Pagination
gem 'will_paginate', '~> 3.0.4'
gem 'kaminari'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

