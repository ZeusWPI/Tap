dc = docker compose
dcexec = $(dc) exec development

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

shell:
	$(dcexec) sh

down:
	$(dc) down

.PHONY: up seed webpack lint shell down
