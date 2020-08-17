################################################################################
#### Config variables
###

# Load them from an optional .env file
-include .env

# Specify which docker tag is to be used
VERSION := $(or ${VERSION},${VERSION},latest)
DOCKER_REGISTRY := $(or ${DOCKER_REGISTRY},${DOCKER_REGISTRY},docker.io)

TINY = ${VERSION}
MINOR = $(shell echo '${TINY}' | cut -f'1-2' -d'.')
# not used until 1.0
# MAJOR = $(shell echo '${MINOR}' | cut -f'1-2' -d'.')

### global

clean:
	rm -rf Gemfile.lock Dockerfile.*.log Dockerfile.*.built lib node_modules _esy esy.lock

ps:
	docker-compose ps

Dockerfile.base.built: Dockerfile.base
	docker build -t yguyot/dem-server:esyrunbase -f Dockerfile.base . | tee Dockerfile.base.log
	touch Dockerfile.base.built

Dockerfile.dev.built: Dockerfile.dev
	docker build -t enspirit/dem-server:dev -f Dockerfile.dev . | tee Dockerfile.dev.log
	touch Dockerfile.dev.built

Dockerfile.built: Dockerfile
	docker build -t enspirit/dem-server -f Dockerfile . | tee Dockerfile.log
	touch Dockerfile.built

down:
	docker-compose stop dem-server dem-server.dev

base.image: Dockerfile.base.built

Dockerfile.base.pushed: Dockerfile.base.built
	docker tag yguyot/dem-server:esyrunbase $(DOCKER_REGISTRY)/yguyot/dem-server:esyrunbase
	docker push $(DOCKER_REGISTRY)/yguyot/dem-server:esyrunbase | tee -a Dockerfile.base.log

base.push: Dockerfile.base.pushed

dev.image: Dockerfile.dev.built

image: Dockerfile.built

up:
	docker-compose up -d dem-server

dev.up:
	docker-compose up -d dem-server.dev

dev:
	docker run -v ~/dem-bs-server/bin:/home/opam/bin -it enspirit/dem-server:dev

restart:
	docker-compose restart dem-server

dev.restart:
	docker-compose restart dem-server.dev

logs:
	docker-compose logs -f dem-server

dev.logs:
	docker-compose logs -f dem-server.dev

bash:
	docker-compose exec dem-server bash
