.PHONY: up down build logs clean check

check:
	@command -v docker >/dev/null || { echo "missing: docker"; exit 1; }
	@docker compose version >/dev/null 2>&1 || { echo "missing: docker compose v2 plugin"; exit 1; }
	@test -f .env || { echo "missing: .env (needs CLOUDFLARE_TUNNEL_TOKEN)"; exit 1; }
	@grep -q '^CLOUDFLARE_TUNNEL_TOKEN=.' .env || { echo "missing: CLOUDFLARE_TUNNEL_TOKEN in .env"; exit 1; }
	@docker network inspect proxy >/dev/null 2>&1 || { echo "creating docker network: proxy"; docker network create proxy >/dev/null; }

up: check
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
