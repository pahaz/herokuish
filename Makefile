NAME=herokuish
HARDWARE=$(shell uname -m)
VERSION=0.3.0

build:
	cat buildpacks/*/buildpack* | sed 'N;s/\n/ /' > include/buildpacks.txt
	docker build -t $(NAME):dev .

deps-go:
	apt-get install python-software-properties -y # 12.04
	add-apt-repository ppa:duh/golang -y
	apt-get update
	apt-get install golang -y

deps-docker:
	# http://docs.docker.com/installation/ubuntulinux/
	@command -v docker > /dev/null || curl -sSL https://get.docker.io/ubuntu/ | sudo sh
	sleep 2 # give docker a moment i guess

deps:
	docker pull heroku/cedar:14
	go get -u github.com/progrium/basht/...
	apt-get install python-yaml  # required for herokuish.bash

test:
	basht tests/*/tests.sh
	basht buildpacks/*/tests/*/test.sh

.PHONY: build
