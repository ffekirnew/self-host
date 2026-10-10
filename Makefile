.phony: up down build logs clean

up:
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
