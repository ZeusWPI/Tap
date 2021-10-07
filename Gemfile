source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1'

# Use Puma as the app server
gem 'puma', '~> 5.5.0'

# Boot large ruby/rails apps faster
gem 'bootsnap', '~> 1.9'
gem 'listen', '~> 3.7'

# The speed of a single-page web application without having to write any JavaScript.
gem 'turbo-rails', '~> 0.8.1'

# Sass
gem 'sassc-rails', '~> 2.1'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'

# Bulma
gem 'bulma-rails', '~> 0.9.1'
gem 'font-awesome-sass', '~> 5.15'

# Add nested forms support
gem 'vanilla_nested', '~> 1.4'

# Charts
gem 'chartkick', '~> 4.0'

# Friendly ids
# Will replace endpoints like /users/:id with /users/:username
gem 'friendly_id', '~> 5.4'

# Paginate stuff
gem 'will_paginate', '~> 3.3'
gem 'will_paginate-bulma', '~> 1.0'

# Paperclip for easy file attachment
# Using the kt fork as, paperclip is deprecated
gem 'kt-paperclip', '~> 7.0'

# Use devise for users and admins
gem 'devise', '~> 4.8'
gem 'omniauth-oauth2', '1.3.1'

# Use cancancan for authorization
gem 'cancancan', '~> 3.3'

# Default avatar for users
gem 'identicon', '0.0.5'

# Run stuff in the background
gem 'daemons', '~> 1.4'
gem 'delayed_job', '~> 4.1'
gem 'delayed_job_active_record'

# Needed for deployment somehow
gem 'bcrypt_pbkdf'
gem "ed25519"

# Ruby debugger
gem 'byebug'

gem 'httparty', '~> 0.20.0'

# windows support (linux timezone directory is used in the project)
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

# Production dependencies
group :production do
  gem 'mysql2', '~> 0.5.3'
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
  gem 'sqlite3', '~> 1.4'

  # Annotates Rails/ActiveRecord Models, routes, fixtures, and others based on the database schema.
  gem 'annotate', '~> 3.1'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 3.0'

  # Deployment
  gem 'capistrano', '~> 3.16'
  gem 'capistrano-rails', '~> 1.6'
  gem 'capistrano-rvm', '~> 0.1.2'
  gem 'capistrano-rbenv', '~> 2.2'
  gem 'capistrano-passenger', '~> 0.2.1'

  # Linting
  gem 'rubocop', '~> 1.22'
end

# Development/Test shared dependencies
group :development, :test do
  gem 'factory_bot', '~> 6.2'
  gem 'faker', '~> 2.19'
  gem 'tqdm', '~> 0.3.0'
end

# Documentation dependencies
group :doc do
  gem 'sdoc', '~> 2.2'
end
