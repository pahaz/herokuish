FROM heroku/cedar:14
ADD ./. /herokuish
RUN apt-get update && cd /herokuish && make runtime-deps
RUN /herokuish/herokuish.bash buildpack install \
        && ln -s /herokuish/herokuish.bash /bin/herokuish \
	&& ln -s /herokuish/herokuish.bash /build \
	&& ln -s /herokuish/herokuish.bash /start \
	&& ln -s /herokuish/herokuish.bash /exec
