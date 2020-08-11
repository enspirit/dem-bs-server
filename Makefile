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
	rm -rf Gemfile.lock Dockerfile.log Dockerfile.built lib node_modules _esy esy.lock

ps:
	docker-compose ps

Dockerfile.built: Dockerfile
	docker build -t enspirit/dem-bs-server -f Dockerfile . | tee Dockerfile.log
	touch Dockerfile.built

down:
	docker-compose stop dem-bs-server

image: Dockerfile.built

up: image
	docker-compose up -d dem-bs-server

restart:
	docker-compose restart dem-bs-server

logs:
	docker-compose logs -f dem-bs-server

bash:
	docker-compose exec dem-bs-server bash

Dockerfile.pushed: Dockerfile.built
	docker tag enspirit/dem-bs-server $(DOCKER_REGISTRY)/enspirit/dem-bs-server:${TINY}
	docker push $(DOCKER_REGISTRY)/enspirit/dem-bs-server:$(TINY) | tee -a Dockerfile.log
	docker tag enspirit/dem-bs-server $(DOCKER_REGISTRY)/enspirit/dem-bs-server:${MINOR}
	docker push $(DOCKER_REGISTRY)/enspirit/dem-bs-server:$(MINOR) | tee -a Dockerfile.log
	# not used until 1.0
	# docker tag enspirit/dem-bs-server $(DOCKER_REGISTRY)/enspirit/dem-bs-server:${MAJOR}
	# docker push $(DOCKER_REGISTRY)/enspirit/dem-bs-server:$(MAJOR) | tee -a Dockerfile.log
	touch Dockerfile.pushed

push-image: Dockerfile.pushed
