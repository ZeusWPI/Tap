# This is for development only
FROM docker.io/ruby:3.3.1-alpine3.18

RUN echo "@alpine/v3.16/main https://dl-cdn.alpinelinux.org/alpine/v3.16/main" >> /etc/apk/repositories \
    && apk update \
    && apk upgrade \
    && apk add \
        build-base shared-mime-info mariadb-dev sqlite-dev tzdata imagemagick \
        nodejs@alpine/v3.16/main yarn@alpine/v3.16/main \
        vimdiff \
    && rm -rfv /var/cache/apk/*

# Diffs in red/green instead of blue/cyan
RUN echo "colorscheme retrobox" >> /root/.vimrc
ENV THOR_MERGE=vimdiff

WORKDIR /tap

COPY Gemfile Gemfile.lock ./
RUN --mount=type=cache,target=vendor/cache bundle install && bundle cache

COPY package.json yarn.lock ./
RUN --mount=type=cache,target=/usr/local/share/.cache/yarn yarn install
RUN mv node_modules /node_modules

EXPOSE 80

COPY --chmod=755 <<EOF /run-development.sh
#!/bin/sh
set -eu

[ -e node_modules ] && rm -rf node_modules
ln -s /node_modules node_modules

bundle exec rake db:migrate
bundle exec rails server -b 0.0.0.0 -p 80

echo "Rails exited, sleeping indefinitely so dev shells don't die."
sleep inf
EOF

COPY --chmod=755 <<EOF /run-test.sh
#!/bin/sh
set -eu

[ -e node_modules ] && rm -rf node_modules
ln -s /node_modules node_modules

bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake
EOF
