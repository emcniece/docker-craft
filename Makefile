# Creates a base image for emcniece/nginx-cache-purge-craft

NAMESPACE := emcniece
PROJECT := docker-craft
PLATFORM := linux
ARCH := amd64
DOCKER_IMAGE := $(NAMESPACE)/$(PROJECT)

VERSION := $(shell cat VERSION)
PHP_VERSION := $(shell cat PHP_VERSION)
FPM_ARCH := $(shell cat FPM_ARCH)

IMAGE_VERSION := $(DOCKER_IMAGE):$(VERSION)
IMAGE_FULL_TAG:= $(DOCKER_IMAGE):$(VERSION)-$(PHP_VERSION)-$(FPM_ARCH)

all: help

help:
	@echo "---"
	@echo "IMAGE: $(DOCKER_IMAGE)"
	@echo "VERSION: $(VERSION)"
	@echo "---"
	@echo "make image - compile Docker image"
	@echo "make run-debug - run container with tail"
	@echo "make docker - push to Docker repository"
	@echo "make release - push to latest tag Docker repository"

image:
	docker build -t $(DOCKER_IMAGE):$(VERSION) \
		-f ./$(PHP_VERSION)/$(FPM_ARCH)/Dockerfile .

run-debug:
	docker run -d $(DOCKER_IMAGE):$(VERSION) tail -f /dev/null

run:
	docker run -d $(DOCKER_IMAGE):$(VERSION)

tag-php:
	docker tag $(DOCKER_IMAGE):$(VERSION) $(IMAGE_FULL_TAG)

docker:
	@echo "Pushing $(DOCKER_IMAGE):$(VERSION)"
	docker push $(DOCKER_IMAGE):$(VERSION)

release: docker
	@echo "Pushing $(DOCKER_IMAGE):latest"
	docker tag $(DOCKER_IMAGE):$(VERSION) $(DOCKER_IMAGE):latest
	docker tag $(DOCKER_IMAGE):$(VERSION) $(IMAGE_FULL_TAG)
	docker push $(DOCKER_IMAGE):latest
	docker push $(IMAGE_FULL_TAG)

clean:
	docker rmi $(DOCKER_IMAGE):$(VERSION)
	docker rmi $(DOCKER_IMAGE):latest
