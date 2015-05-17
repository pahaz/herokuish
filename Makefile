NAME=herokuish
HARDWARE=$(shell uname -m)
VERSION=0.3.0
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

GOPATH:=${ROOT_DIR}/.go
PATH:=$(PATH):${GOPATH}/bin
export DEBIAN_FRONTEND=noninteractive
export GOPATH
export PATH

build:
	cat buildpacks/*/buildpack* | sed 'N;s/\n/ /' > include/buildpacks.txt
	@docker build -t $(NAME):dev .

deps-add-apt-repository:
	if ! command -v add-apt-repository > /dev/null; then
	    apt-get install software-properties-common -y
	    [[ `lsb_release -sr` == "12.04" ]] && apt-get install python-software-properties -y
	fi

deps-go: deps-add-apt-repository
	add-apt-repository ppa:duh/golang -y
	apt-get update
	apt-get install golang -y
	go version

deps-docker:
	# http://docs.docker.com/installation/ubuntulinux/
	@command -v docker > /dev/null || curl -sSL https://get.docker.io/ubuntu/ | sudo sh
	sleep 2 # give docker a moment i guess
	docker version

runtime-deps:
	apt-get install python-yaml -y  # python yaml parser for herokuish.bash
	apt-get install daemontools -y  # setuidgid (runs another program under a specified account's uid and gid) for include/herokuish.bash

test-deps: runtime-deps deps-go
	mkdir ${ROOT_DIR}/.go || true
	go get -u github.com/progrium/basht/...

test: test-deps
	docker version
	go version
	basht tests/*/tests.sh
	basht buildpacks/*/tests/*/test.sh

.PHONY: build
