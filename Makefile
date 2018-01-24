NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

.PHONY: all

all: up deps migrate

force: rebuild deps migrate

rebuild:
	@echo "$(OK_COLOR)==> Rebuilding containers$(NO_COLOR)"
	@docker-compose up -d --build

up:
	@echo "$(OK_COLOR)==> Starting containers$(NO_COLOR)"
	@docker-compose up -d

deps:
	@echo "$(OK_COLOR)==> Installing dependencies$(NO_COLOR)"
	@docker-compose exec php composer install --no-interaction --ignore-platform-reqs

migrate:
	@echo "$(OK_COLOR)==> Running DB migrations$(NO_COLOR)"
	@docker-compose exec php php artisan migrate
