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

COPY ./ ./

# Run rails in development mode
ENV RAILS_ENV development

EXPOSE 80

CMD sh docker-start.sh
