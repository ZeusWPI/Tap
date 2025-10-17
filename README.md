# [Tap](https://zeus.ugent.be/tap)
[![Code Climate](https://codeclimate.com/github/ZeusWPI/Tap/badges/gpa.svg)](https://codeclimate.com/github/ZeusWPI/Tap) [![Ruby](https://github.com/ZeusWPI/Tap/actions/workflows/ruby.yml/badge.svg)](https://github.com/ZeusWPI/Tap/actions/workflows/ruby.yml) 

🍺 Yes. We have to drink. But we also have to pay. This is the drinking part.

## Development

To provide a consistent experience on every system, docker and docker-compose is used during development and production.

### Using Docker and Make *(recommended)*

#### Linux/Unix

1. Install [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) (if not already included).
2. Start the development server
    ```sh
    make up
    ```
    > This will start a development server on http://localhost:3000.
    > Cancelling this command will leave tap running in the background.
    > You can stop it using `make down`.
3. Seed the database.
    ```sh
    make seed
    ```
    > The development setup uses a SQLite 3 database, which can be found under `/db/development.sqlite3`.

See the `Makefile` for all commands.

#### Windows

1. Install [WSL (Windows Subsystem for Linux)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
2. Follow the instructions for Linux/Unix above

### Directly on your system

> If you have nix with flakes, run `nix develop`.
> Note: the tool versions in nix are not entirely correct.

1. Install gems: `bundle install`
2. Migrate the db using `bundle exec rails db:migrate`
3. Seed the db using `bundle exec rails db:seed`
4. Run `rake webpacker:compile`
5. Start Tap by running `bundle exec rails s`

## Deploy to production

1. Make sure your user has access to tap@tap.zeus.gent.
2. Uncomment the `- "${HOME}/.ssh:/root/.ssh:ro"` line in `docker-compose.yml`.
3. Run `make deploy`.

## FAQ

<details>
  <summary>Can I use Tap for development without setting up Tab?</summary>
  Tap does not sync with Tab when in development mode. The user's balance is mocked by Ƶ12.34 instead.
</details>

<details>
  <summary>How do I login as the "Koelkast" user?</summary>
  In development, you can login as Koelkast using the link: http://localhost:3000/sign_in?token=token
</details>

<details>
  <summary>I get a "mismatching_redirect_uri" error when trying to login</summary>
  The Zeus authentication provider has a pre-configured list of hosts that are allowed to use the login. http://localhost:3000 is on this list and should be used for development.
</details>

<details>
  <summary>Docker image build is stuck on "Fetching gems..." or another command</summary>
  If you are connected to the **`eduroam`** network, Docker build will not have access to the internet. This is because eduroam and docker use the same IP range, which causes conflicts. To solve this you can [reconfigure Docker to use a different IP range](https://support.skyformation.com/hc/en-us/articles/360009195759-How-To-Change-the-Docker-IP-address-space). A recommended range can be `172.31.248.0/21` which is rarely used by other networks.
</details>

<details>
  <summary>There are no transactions going from Tap to Tab</summary>
  The delay job may not be running. You can start it using:

  ```sh
  sudo -u tap RAILS_ENV=production /home/tap/production/current/bin/delayed_job start
  ```
</details>
