# herokuish [![Circle CI](https://circleci.com/gh/pahaz/herokuish.png?style=shield)](https://circleci.com/gh/pahaz/herokuish)

This is a fork of https://github.com/gliderlabs/herokuish project. 
The key difference of the project is the absence of the Go language in the core logic.

## HowTo Use this project

	# 1. Build your docker image
	
	export IMAGE_NAME=myherokuish
	export STACK_URL=https://github.com/pahaz/herokuish.git
	(git clone ${STACK_URL} /tmp/buildstep && cd /tmp/buildstep && sudo make && cd -)
	
	# Now you have a `myherokuish:dev` docker image
	
	# 2. Build you project source
	
	export SOURCE=/tmp/buildstep/buildpacks/buildpack-python/tests/python-flask
	export CACHE=/tmp
	export BUILD_IMAGE_NAME=myherokuish__flask
	docker run -e "DOCKER_BUILD=1" -e "PORT=5000" -p "5000" -d herokuish:dev /build
	BUILD_ID=$(docker run -e "DOCKER_BUILD=1" -v "${SOURCE}:/tmp/app" -v "${CACHE}:/tmp/cache" -it ${IMAGE_NAME} /build)
	docker commit ${BUILD_ID} ${BUILD_IMAGE_NAME}
	
	# 3. Run built image
	
	docker run -e "PORT=5000" -p "5000" -d ${BUILD_IMAGE_NAME} /start
	
	# Now you have a built runned container
	docker ps  # see result

## License

BSD
