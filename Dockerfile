FROM heroku/cedar:14
ADD ./. /herokuish
RUN ln -s /herokuish/herokuish.bash /bin/herokuish
RUN /bin/herokuish buildpack install
