# frozen_string_literal: true

source "https://rubygems.org"

gem "csv"
gem "observer"

# Dotenv for .env file variables
gem "dotenv-rails"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.1.0"

# Use Puma as the app server
gem "puma"

# Boot large ruby/rails apps faster
gem "bootsnap"
gem "listen"

# Sass
gem "sassc-rails"

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker"

# Not sure why
gem "net-imap", require: false
gem "net-pop", require: false
gem "net-smtp", require: false

# Bulma
gem "bulma-rails"
gem "font-awesome-sass"

# Add nested forms support
gem "vanilla_nested"

# Charts
gem "chartkick"

# Friendly ids
# Will replace endpoints like /users/:id with /users/:username
gem "friendly_id"

# Paginate stuff
gem "will_paginate"
gem "will_paginate-bulma"

# Paperclip for easy file attachment
# Using the kt fork as, paperclip is deprecated
gem "kt-paperclip"

# Use devise for users and admins
gem "devise"
gem "omniauth-rails_csrf_protection"
gem "omniauth-zeuswpi"

# Use cancancan for authorization
gem "cancancan"

# Default avatar for users
gem "identicon", "0.0.5"

# Run stuff in the background
gem "daemons"
gem "delayed_job"
gem "delayed_job_active_record"

# Needed for deployment somehow
gem "bcrypt_pbkdf"
gem "ed25519"

# Ruby debugger
gem "byebug"

gem "httparty"

# windows support (linux timezone directory is used in the project)
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw]

# Sentry
gem "sentry-rails"
gem "sentry-ruby"
gem "stackprof"

# Production dependencies
group :production do
  gem "mysql2"
end

# Test dependencies
group :test do
  gem "rspec-rails"
  gem "webmock"
end

# Development dependencies
group :development do
  # Use sqlite3 as the database for Active Record
  gem "sqlite3"

  # Annotates Rails/ActiveRecord Models, routes, fixtures, and others based on the database schema.
  gem "annotate"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"

  # Deployment
  gem "capistrano"
  gem "capistrano-asdf"
  gem "capistrano-passenger"
  gem "capistrano-rails"

  # Linting
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-rspec"
end

# Development/Test shared dependencies
group :development, :test do
  gem "factory_bot"
  gem "factory_bot_rails"
  gem "faker"
  gem "rails-controller-testing"
  gem "tqdm"
end

# Documentation dependencies
group :doc do
  gem "sdoc"
end
