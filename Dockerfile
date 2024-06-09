FROM ruby:3.3.2-slim

ENV RAILS_ENV=production

RUN apt update && apt install -y git libpq-dev build-essential gpg curl

WORKDIR /app

COPY ./Gemfile ./Gemfile.lock /app/

RUN gem install bundler
RUN bundle config set without 'development test'
RUN bundle install

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install -y yarn

COPY ./package.json ./yarn.lock /app/
RUN yarn install

COPY . /app

RUN SECRET_KEY_BASE="dummy_secret_key_base" bundle exec rails assets:precompile

CMD bundle exec rails s -b 0.0.0.0
