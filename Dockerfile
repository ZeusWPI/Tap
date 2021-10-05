##################
### Base image ###
##################
FROM ruby:3.0.2-alpine as base

# Install the required packages for building
# Delete APK cache at the end (for smaller production images)
RUN apk update && \
    apk add --virtual build-dependencies build-base && \
    apk add shared-mime-info mariadb-dev sqlite-dev nodejs tzdata imagemagick && \
    rm -rf /var/cache/apk/*

# Create a working directory
WORKDIR /tap

# Copy the gemfile to the working directory
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

# Install dependencies
# Use BuildKit cache for caching dependencies
RUN --mount=type=cache,target=vendor/cache bundle install

# Copy all of the .gem files needed to run the application into the vendor/cache directory.
# In the future, when running [bundle install(1)][bundle-install], use the gems in the cache in preference to the ones on rubygems.org
RUN bundle cache

########################
### Production image ###
########################
FROM base as production

# Copy the sourcecode
COPY . .

# Run rails in production mode
ENV RAILS_ENV production

# Expose port 80
# This is the main port for the application
EXPOSE 80

# Pre-compile assets
RUN rake assets:precompile

# Docker Entrypoint
# Will be started when the container is started
ENTRYPOINT sh docker-start.sh

#########################
### Development image ###
#########################
FROM base as development

# Copy the sourcecode
COPY . .

# Run rails in production mode
ENV RAILS_ENV development

# Expose port 80
# This is the main port for the application
EXPOSE 80

# Docker Entrypoint
# Will be started when the container is started
CMD sh docker-start.sh
