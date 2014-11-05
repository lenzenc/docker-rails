# Docker Rails
--------------

This is a sample rails project that shows how you can can use Docker within a rails project.

## Setup Docker

[Install Docker](https://docs.docker.com/installation/#installation)

Unless you are on a linux box, then you need to create a linux VM that is used to run your Docker containers on.  Docker provides a tool called boot2docker that is a simple VM manager that can be used to create/provision a base linux VM to be used by Docker.

### Homebrew

If you are on Mac and prefer to install Docker with __*brew*__ then you can run the following commands;

	brew cask install virtualbox
	brew install docker
	brew install boot2docker

Create VM and start it;

	boot2docker init
	boot2docker start
	$(boot2docker shellinit)

`NOTE` - If this is your first time using boot2docker then there will likely be some instructions at the end of boot2docker init/start that talks about setting up environment variables.  These environment variable are basically used to tell Docker what/where the VM is to be used to run Docker containers in.  If you wanted to use Vagrant then you could provision a Vagrant VM and update these (one) variables to point to that VM instead of the generated boot2docker one.

## Development

### Building an Image

The first thing you are going to need to do is "build" a new image for this project, which is done using docker and the supplied Dockerfile in this project.

	docker build -t lenzenc/docker-rails .

If you run the following command after the above finishes you should see a new image created, you can now use that image to create/run a docker container to do development on this project.

	docker images

### Running a Container

Now run a docker container with this image..

	docker run -p 3000:3000 -v $(pwd):/rails -t -i lenzenc/docker-rails /bin/bash

Let's break this down a little...

	-p 3000:3000

Tells docker to port forward any

	-v $(pwd):/rails

Tells the docker container to mount your current project working directory to "/rails" on the running container, this way whenever you make changes to your local files they are automatically updated on the running container.

`NOTE` - Mounting a shared volume is only available if you are using Docker 1.3 or above, if you aren't then you might want to consider using Vagrant with Docker instead.

	lenzenc/docker-rails

Defines which image to use to run a Docker container with...this of course if the new image you built from above.

	/bin/bash

This is the CMD to initially run when starting the Docker container with the given image.

If you open another terminal window and run the following you should see you newly running Docker container.

	docker ps

### Initial Setup

Given this is a new container/image you need to do a little setup before running this sample rails application, once you run these setups you will not need to do this again unless of course you decide to build a new image again or keep running a new container instead of the inital one that you create/run.

	cd /rails
	bundle config path "$HOME/bundler"
	bundle install

### Running this Application

	cd /rails
	rails s	

Run this command and note the IP, it is the IP address of the boot2docker-vm that this new rails application container is running on;

	boot2docker ip

Now in a browser..

	http://192.168.59.103:3000

If successful you should see a HTML page with a tile of "Customer List"

If you modify the rails "view" for this page in "./app/views/customers/index.html.erb" and click refresh you will now see the updated change.  Again the "-v" flag when running the Docker container told it to "share/sync" your project directory on your local box with the "/rails" dir on the container.

## Non Development

This section shows how you can just create a deployable Docker container with this sample application in it, all setup etc and runnable.

### Building an Image

Similar to above you need to create a new Docker image for this project, in this case you need to run;

	docker build -t lenzenc/docker-rails deploy

The only different is that this "build" uses a slightly different Dockerfile that has some of the initial setup done for you and instead of mounting a shared volume it just adds(copies) the entire project direcdtory to the new Docker image.  See the "ADD" line in "./deploy/Dockerfile".