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
    > Canceling this command will leave tap running in the background.
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

> [!TIP]
> If you have nix with flakes, run `nix develop`.

1. Install gems: `bundle install`
1. Install npm packages: `npm i`
2. Initialize and migrate the db: `bundle exec rails db:migrate`
3. Seed the db: `bundle exec rails db:seed`
5. Start Tap: `./bin/dev` (or run `npm run build:js`, then `bundle exec rails s`)

#### Tests

Run `bundle exec rake`\
or if that doesn't work try `bundle exec rspec`?

#### Linter (rubocop)

- Run `bundle exec rubocop` to lint
- To autocorrect most offenses
  - safely : `bundle exec rubocop -a`
  - unsafely : `bundle exec rubocop -A`

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
  The delayed job may have failed.
  If `podman exec -it systemd-tap ps` doesn't have `{ruby} delayed_job`, view the logs to see how it crashed.
  Restarting the container also restarts the `delayed_job`.
</details>

## Licensing

This software is distributed under the terms of the MIT.
A copy of this license can be found in the [LICENSE](LICENSE) file.

Copyright © 2014-2025 Zeus WPI <bestuur@zeus.gent>
