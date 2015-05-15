FROM heroku/cedar:14
ADD ./. /herokuish
RUN ln -s /herokuish/herokuish.bash /bin/herokuish
ENV TRACE=1
RUN /bin/herokuish buildpack install
