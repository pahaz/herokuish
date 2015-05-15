NAME=herokuish
HARDWARE=$(shell uname -m)
VERSION=0.3.0
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

GOPATH:=${ROOT_DIR}/.go
PATH:=$(PATH):${GOPATH}/bin

build:
	cat buildpacks/*/buildpack* | sed 'N;s/\n/ /' > include/buildpacks.txt
	@docker build -t $(NAME):dev .

deps-go:
	#apt-get install python-software-properties -y # 12.04
	#add-apt-repository ppa:duh/golang -y
	#apt-get update
	apt-get install golang -y
	mkdir ${ROOT_DIR}/.go || true

deps-docker:
	# http://docs.docker.com/installation/ubuntulinux/
	@command -v docker > /dev/null || curl -sSL https://get.docker.io/ubuntu/ | sudo sh
	sleep 2 # give docker a moment i guess

runtime-deps:
	apt-get install python-yaml -y  # python yaml parser for herokuish.bash
	apt-get install daemontools -y  # setuidgid (runs another program under a specified account's uid and gid) for include/herokuish.bash

test-deps: runtime-deps deps-go
	go get -u github.com/progrium/basht/...

test: test-deps
	basht tests/*/tests.sh
	basht buildpacks/*/tests/*/test.sh

.PHONY: build
