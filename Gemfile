source 'https://rubygems.org'

# Needed for deployment somehow
gem 'bcrypt_pbkdf'
gem "ed25519"

gem 'byebug'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.11.1'

# Assets
gem 'sass-rails', '~> 4.0.3'
gem 'bootstrap-sass', ">= 3.4.1"
gem 'bootstrap-switch-rails', '3.3.3'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails', '4.1.0'
# Haml for templating!
gem "haml-rails", "~> 1.0"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '2.5.3'

# Friendly ids!
gem 'friendly_id', '~> 5.1.0'

group :doc do
  gem 'sdoc', '~> 0.4.0'
end

group :production do
  gem 'mysql2', '~> 0.4.10' # Database
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'rspec-rails'
  gem 'coveralls', require: false
  gem 'webmock'
end

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
end

group :development, :test do
  gem 'factory_girl_rails', '4.6.0'
  gem 'faker', '1.4.2'
end

# Airbrake
gem 'airbrake', '~> 4'

# Paginate stuff
gem 'will_paginate',           '3.0.7'
gem 'bootstrap-will_paginate', '0.0.10'

# Paperclip for easy file attachment
gem 'paperclip', '>= 5.2.0'

# Use devise for users and admins
gem "devise", ">= 4.6.0"
gem 'omniauth-oauth2', '1.3.1'

# Use cancancan for authorization
gem 'cancancan', '1.13.1'

# Default avatar for users
gem 'identicon', '0.0.5'

# Run stuff in the background
gem 'daemons', '1.2.3'
gem 'delayed_job', '~> 4.0'
gem 'delayed_job_active_record'

gem 'httparty', '0.13.7'

# windows support (linux timezone directory is used in the project)
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
