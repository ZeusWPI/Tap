# [Tap](https://zeus.ugent.be/tap)
[![Code Climate](https://codeclimate.com/github/ZeusWPI/Tap/badges/gpa.svg)](https://codeclimate.com/github/ZeusWPI/Tap) [![Travis CI](https://travis-ci.org/ZeusWPI/Tap.svg)](https://travis-ci.org/ZeusWPI/Tap) [![Coverage Status](https://coveralls.io/repos/ZeusWPI/Tap/badge.svg?branch=master&service=github)](https://coveralls.io/github/ZeusWPI/Tap?branch=master)

:beer: Yes. We have to drink. But we also have to pay. This is the drinking part.

## Development setup

To provide a consistent experience on every system, docker and docker-compose is used during development and production.

### Using Docker *(recommended)*

1. Install [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/)
2. Enable Docker Buildkit for faster docker builds and caching
    #### Unix or WSL
    ```sh
    export COMPOSE_DOCKER_CLI_BUILD=1
    export DOCKER_BUILDKIT=1
    ```

    #### PowerShell
    ```powershell
    $Env:DOCKER_BUILDKIT = 1
    $Env:COMPOSE_DOCKER_CLI_BUILD = 1
    ```

    > These commands must be run on everytime you open a new shell or must be added to your shell profile script.

3. Start the development server
    ```sh
    docker-compose up -d
    ```

    This will start a development server on http://localhost:3000
4. Seed the database.
    ```sh
    docker-compose run --rm development "bundle exec rake db:seed"
    ```

    > The development setup uses an SQLite 3 database, which can be found under `/db/development.sqlite3`

### Directly on your system

1. Make sure Ruby version 2.4.0 is installed by running `rbenv version`. If it isn't, install by running `rbenv install`
2. Run `bundle update` and `bundle install`
3. Migrate the db using `bundle exec rake db:migrate`
4. Seed the db using `bundle exec rake db:seed`
5. Start Tap by running `bundle exec rails s`

## Wat als de delayed job kapot is waardoor er geen transacties van tap naar tab gaan?

```
sudo -u tap RAILS_ENV=production /home/tap/production/current/bin/delayed_job start
```
