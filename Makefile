dc = docker compose
dcexec = $(dc) exec development

build:
	$(dc) build

up:
	$(dc) up -d --build
	$(dc) logs -f

seed:
	$(dc) up -d
	$(dcexec) bundle exec rake db:seed

webpack:
	$(dc) up -d
	$(dcexec) bundle exec rake webpacker:compile

lint:
	$(dc) up -d
	$(dcexec) bundle exec rubocop -A

deploy:
	$(dc) up -d --build
	$(dcexec) bundle exec cap production deploy

shell:
	$(dcexec) sh

down:
	$(dc) down

.PHONY: build up seed webpack lint deploy shell down
