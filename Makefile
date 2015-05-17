IMAGE_NAME?=herokuish
IMAGE_VERSION?=dev

ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
GOPATH:=${ROOT_DIR}/.go
PATH:=$(PATH):${GOPATH}/bin
export DEBIAN_FRONTEND=noninteractive
export GOPATH
export PATH

build: runtime-deps
	cat buildpacks/*/buildpack* | sed 'N;s/\n/ /' > include/buildpacks.txt
	@docker build -t $(IMAGE_NAME):$(IMAGE_VERSION) .

deps-add-apt-repository:
	command -v add-apt-repository > /dev/null || apt-get install software-properties-common -y
	command -v add-apt-repository > /dev/null || ([ `lsb_release -sr` == "12.04" ] && apt-get install python-software-properties -y)

deps-go: deps-add-apt-repository
	add-apt-repository ppa:duh/golang -y
	apt-get update
	apt-get install golang -y
	go version

deps-docker:
	# http://docs.docker.com/installation/ubuntulinux/
	command -v docker > /dev/null || curl -sSL https://get.docker.io/ubuntu/ | sudo sh
	sleep 2 # give docker a moment i guess
	docker version

runtime-deps:
	python -c "import yaml" || apt-get install python-yaml -y  # python yaml parser for herokuish.bash
	command -v setuidgid > /dev/null || apt-get install daemontools -y  # setuidgid (runs another program under a specified account's uid and gid) for include/herokuish.bash

test-deps: runtime-deps deps-go
	mkdir ${ROOT_DIR}/.go || true
	go get -u github.com/progrium/basht/...

test:
	docker version
	go version
	basht tests/*/tests.sh
	basht buildpacks/*/tests/*/test.sh

.PHONY: build
