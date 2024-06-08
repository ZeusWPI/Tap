# [Tap](https://zeus.ugent.be/tap)
[![Code Climate](https://codeclimate.com/github/ZeusWPI/Tap/badges/gpa.svg)](https://codeclimate.com/github/ZeusWPI/Tap) [![Ruby](https://github.com/ZeusWPI/Tap/actions/workflows/ruby.yml/badge.svg)](https://github.com/ZeusWPI/Tap/actions/workflows/ruby.yml) 

🍺 Yes. We have to drink. But we also have to pay. This is the drinking part.

## Development

To provide a consistent experience on every system, docker and docker-compose is used during development and production.

1. Install the prerequisites: ruby `$(cat .ruby-version)`, preferably using [asdf](https://asdf-vm.com/), and some system libraries depending on your OS (e.g. imagemagick)
2. Install the ruby dependencies: `bin/bundle`
3. Start up the database, sidekiq and rails server by running `bin/dev`
4. Set up some database data using `rails db:setup`
5. Browse to http://localhost:3000

In case you want to start the webserver in your IDE, just run `docker-compose up -d` and start Sidekiq manually (`bundle exec sidekiq`)

## Deploying

_Locally_, run `bundle exec cap production deploy`

## FAQ

<details>
  <summary>Can I use Tap for development without setting up Tab?</summary>
  Tap does not sync with Tab when in development mode. The user's balance is mocked by Ƶ12.34 instead.
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

<details>
  <summary>There are no transactions going from Tap to Tab</summary>
  Sidekiq might not be running. Check the dashboard on https://tap.zeus.gent/sidekiq.

  You can start by redeploying the application, or by turning the deployment on the server off & on (inside the `/home/tap/production/current` directory):

  ```bash
  podman-compose -f docker-compose.prod.yml -p tap down
  podman-compose -f docker-compose.prod.yml -p tap up -d
  ```
</details>
