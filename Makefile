#####################
### Configuration ###
#####################

# Use Docker BuildKit to speedup builds
export DOCKER_BUILDKIT := 1

# Use Docker BuildKit in docker-compose
export COMPOSE_DOCKER_CLI_BUILD := 1

################
### Commands ###
################

# Shortcut for running the `development` container with docker-compose
RUN_DEV := docker-compose run --rm development

# Start the development server
dev:
	docker-compose up --build
.PHONY: dev

# Seed the development database
dev-seed:
	$(RUN_DEV) bundle exec rake db:seed
.PHONY: dev-seed

# Lint the codebase
lint:
	$(RUN_DEV) bundle exec rubocop -A
.PHONY: lint

# Build the production docker image
build:
	export TARGET=production
	docker build . -t tap:latest
.PHONY: build
