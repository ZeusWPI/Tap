source 'https://rubygems.org'

# Needed for deployment somehow
gem 'bcrypt_pbkdf'
gem "ed25519"

# Ruby debugger
gem 'byebug'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2'

# Boot large ruby/rails apps faster
gem 'bootsnap', '~> 1.7'
gem 'listen', '~> 3.7'

# Sass
gem 'sass-rails', '~> 5.0'

# For compressing JS
gem 'uglifier', '~> 4.2'

# Bulma
gem 'bulma-rails', '~> 0.9.1'
gem 'font-awesome-sass', '~> 5.15'

# Add nested forms support
gem 'vanilla_nested', '~> 1.2'

# Charts
gem 'chartkick', '~> 3.4'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5.2'

# Friendly ids!
gem 'friendly_id', '~> 5.1.0'

# Airbrake
gem 'airbrake', '~> 10.0'

# Paginate stuff
gem 'will_paginate', '~> 3.3'
gem 'will_paginate-bulma', '~> 1.0'

# Paperclip for easy file attachment
gem 'paperclip', '~> 6.1'

# Use devise for users and admins
gem 'devise', '~> 4.8'
gem 'omniauth-oauth2', '~> 1.3.1'

# Use cancancan for authorization
gem 'cancancan', '~> 3.3'

# Default avatar for users
gem 'identicon', '0.0.5'

# Run stuff in the background
gem 'daemons', '1.2.3'
gem 'delayed_job', '~> 4.0'
gem 'delayed_job_active_record'

gem 'httparty', '~> 0.20.0'

# windows support (linux timezone directory is used in the project)
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

# Production dependencies
group :production do
  gem 'mysql2', '~> 0.4.10' # Database
end

# Test dependencies
group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'rspec-rails'
  gem 'coveralls', require: false
  gem 'webmock'
end

# Development dependencies
group :development do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '1.3.11'

  gem 'annotate'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '1.6.2'

  # Deployment
  gem 'capistrano', '~> 3.4'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rvm'
  gem 'capistrano-rbenv'
  gem 'capistrano-passenger'

  # Linting
  gem 'rubocop', '~> 1.12'
end

# Development/Test shared dependencies
group :development, :test do
  gem 'factory_girl_rails', '4.6.0'
  gem 'faker', '1.4.2'
end

# Documentation dependencies
group :doc do
  gem 'sdoc', '~> 0.4.0'
end
