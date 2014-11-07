# -*- sh -*-
FROM lenzenc/ruby:2.1.3

RUN apt-get update
RUN apt-get -qy install nodejs

# create a "rails" user
# the Rails application will live in the /rails directory
RUN adduser --disabled-password --home=/rails --gecos "" rails

# copy the Rails app
ADD . /rails

# Make sure we have rights on the rails folder
RUN chown rails -R /rails

# copy and execute the setup script
# this will run bundler, setup the database, etc.
ADD docker/scripts/setup.sh /setup.sh
RUN su rails -c /setup.sh

# copy the start script
ADD docker/scripts/start.sh /start.sh

EXPOSE 3000
USER rails
CMD /start.sh