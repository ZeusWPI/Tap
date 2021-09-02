#!/bin/bash

# Run the database migrations
bundle exec rake db:migrate

# Start the production server
bundle exec rails server -b 0.0.0.0 -p 80
