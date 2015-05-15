NAME=herokuish
HARDWARE=$(shell uname -m)
VERSION=0.3.0

build:
	cat buildpacks/*/buildpack* | sed 'N;s/\n/ /' > include/buildpacks.txt
	docker build -t $(NAME):dev .

go:
	apt-get install python-software-properties -y # 12.04
	add-apt-repository ppa:duh/golang -y
	apt-get update
	apt-get install golang -y

docker:
	# http://docs.docker.com/installation/ubuntulinux/
	@command -v docker > /dev/null || curl -sSL https://get.docker.io/ubuntu/ | sudo sh
	sleep 2 # give docker a moment i guess

deps: go docker
	docker pull heroku/cedar:14
	go get -u github.com/progrium/basht/...

test:
	$(GOPATH)/bin/basht tests/*/tests.sh

circleci:
	docker version
	rm ~/.gitconfig
	mv Dockerfile.dev Dockerfile

release: build
	# DEPRECATED: !!!
	rm -rf release && mkdir release
	tar -zcf release/$(NAME)_$(VERSION)_linux_$(HARDWARE).tgz -C build/linux $(NAME)
	tar -zcf release/$(NAME)_$(VERSION)_darwin_$(HARDWARE).tgz -C build/darwin $(NAME)
	gh-release create gliderlabs/$(NAME) $(VERSION) \
		$(shell git rev-parse --abbrev-ref HEAD) v$(VERSION)

.PHONY: build
