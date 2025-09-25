# This is for development only
FROM ruby:3.3.1-alpine3.18

RUN apk add --no-cache build-base shared-mime-info mariadb-dev sqlite-dev nodejs yarn tzdata imagemagick

WORKDIR /tap

COPY Gemfile Gemfile.lock ./
RUN --mount=type=cache,target=vendor/cache bundle install && bundle cache

COPY package.json yarn.lock ./
RUN --mount=type=cache,target=/usr/local/share/.cache/yarn yarn install

COPY ./ ./

# Run rails in development mode
ENV RAILS_ENV development

# Add back md5
ENV NODE_OPTIONS --openssl-legacy-provider

EXPOSE 80

CMD sh docker-start.sh
