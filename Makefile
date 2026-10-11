.PHONY: up down build logs clean bootstrap

bootstrap:
	@./bootstrap.sh

up: bootstrap
	docker compose up -d

down:
	docker compose down

build:
	docker compose build

logs:
	docker compose logs -f

clean:
	docker compose down --volumes --remove-orphans
	rm -rf jellyfin/data
