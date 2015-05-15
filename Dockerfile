FROM heroku/cedar:14
ADD ./. /herokuish
RUN cd /herokuish && make deps
RUN ln -s /herokuish/herokuish.bash /bin/herokuish
RUN /bin/herokuish buildpack install
