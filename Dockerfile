# -*- sh -*-
# This defines the base image to start from, you could very easily just do a base ubuntu image but
# then you would have to install ruby and all the other components this takes that much more time to
# build a new image, this way you speed up the Docker build process.
# In addition you could have a company standard image for all rails project in this case.
# Images are stored in a public GitHub like registery for Docker at https://github.com/docker/docker-registry.
# You could also host your own registery with the provided registery source code at;
# https://github.com/docker/docker-registry
FROM lenzenc/ruby:2.1.3

# create a "rails" user
# the Rails application will live in the /rails directory
RUN adduser --disabled-password --home=/rails --gecos "" rails

# copy the this rails sample application project structure to a directory on the image at /rails
ADD . /rails

# Make sure we have rights on the rails folder
RUN chown rails -R /rails

# copy and execute the setup script
# this will run bundler, setup the database, etc.
ADD docker/scripts/setup.sh /setup.sh
RUN su rails -c /setup.sh

# copy the start script
ADD docker/scripts/start.sh /start.sh

# Exposes port 3000 from the container running this image to the containers hosting VM.
EXPOSE 3000

# Says that the container running this image will run as the rails user.
USER rails

CMD /start.sh