SHELL ?= /bin/bash

build:
	@docker build --build-arg USERID="$(shell id -u)" \
			--build-arg GROUPID="$(shell id -g)" \
			--build-arg USERNAME="$(shell whoami)" \
			-f Dockerfile -t local/dev-env:latest .

run:
	@docker run --name dev -itd -v $(shell echo $(HOME))/dev:/home/$(shell whoami) local/dev-env:latest

cleanup:
	@docker stop dev
	@docker rm dev
