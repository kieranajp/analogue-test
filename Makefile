NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

# Space separated patterns of packages to skip in list, test, format.
IGNORED_PACKAGES := /vendor/

.PHONY: all

all: up deps migrate

up:
	@echo "$(OK_COLOR)==> Creating containers$(NO_COLOR)"
	@docker-compose up -d

deps:
	@echo "$(OK_COLOR)==> Installing dependencies$(NO_COLOR)"
	@docker-compose exec php composer install --no-interaction --ignore-platform-reqs

migrate:
	@echo "$(OK_COLOR)==> Running DB migrations$(NO_COLOR)"
	@docker-compose exec php php artisan migrate
