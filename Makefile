dc = docker compose
dcexec = $(dc) exec development

build:
	$(dc) build

up:
	$(dc) up -d --build
	$(dc) logs -f

restart:
	$(dc) restart

logs:
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
	$(dc) down -t1

.PHONY: build up restart logs seed webpack lint deploy shell down
