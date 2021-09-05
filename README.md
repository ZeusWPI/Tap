# [Tap](https://zeus.ugent.be/tap)
[![Code Climate](https://codeclimate.com/github/ZeusWPI/Tap/badges/gpa.svg)](https://codeclimate.com/github/ZeusWPI/Tap) [![Travis CI](https://travis-ci.org/ZeusWPI/Tap.svg)](https://travis-ci.org/ZeusWPI/Tap) [![Coverage Status](https://coveralls.io/repos/ZeusWPI/Tap/badge.svg?branch=master&service=github)](https://coveralls.io/github/ZeusWPI/Tap?branch=master)

:beer: Yes. We have to drink. But we also have to pay. This is the drinking part.

## Development

To provide a consistent experience on every system, docker and docker-compose is used during development and production.

### Using Docker and Make *(recommended)*

#### Linux/Unix

1. Install [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/)
2. Start the development server
    ```sh
    make dev
    ```

    > This will start a development server on http://localhost:3000
3. Seed the database.
    ```sh
    make dev-seed
    ```

    > The development setup uses an SQLite 3 database, which can be found under `/db/development.sqlite3`

#### Windows

1. Install [WSL (Windows Subsystem for Linux)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
2. Follow the instructions for Linux/Unix above

### Directly on your system

1. Make sure the correct Ruby version is installed by running `rbenv version`. If it isn't, install by running `rbenv install`
2. Run `bundle update` and `bundle install`
3. Migrate the db using `bundle exec rake db:migrate`
4. Seed the db using `bundle exec rake db:seed`
5. Start Tap by running `bundle exec rails s`

## Production

You can generate a production docker image using:

```sh
make build
```

> The image will be tagged under `tap:latest`

## FAQ

<details>
  <summary>Can I use Tap for development without setting up Tab?</summary>
  Tap does not sync with Tab when in development mode. The user's balance is mocked by €12.34 instead.
</details>

<details>
  <summary>How do I login as the "Koelkast" user?</summary>
  In development, you can login as Koelkast using the link: https://localhost:3000/sign_in?token=token
</details>

<details>
  <summary>I get a "mismatching_redirect_uri" error when trying to login</summary>
  The Zeus authentication provider has a pre-configured list of hosts that are allowed to use the login. http://localhost:3000 is on this list and should be used for development.
</details>

<details>
  <summary>Docker image build is stuck on "Fetching gems..." or another command</summary>
  If you are connected to the **`eduroam`** network, Docker build will not have access to the internet. This is because eduroam and docker use the same IP range, which causes conflicts. To solve this you can [reconfigure Docker to use a different IP range](https://support.skyformation.com/hc/en-us/articles/360009195759-How-To-Change-the-Docker-IP-address-space). A recommended range can be `172.31.248.0/21` which is rarely used by other networks.
</details>
