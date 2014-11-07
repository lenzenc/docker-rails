# Docker Rails

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

## Building an Image

The first thing you are going to need to do is "build" a new image for this project, which is done using docker and the supplied Dockerfile in this project.

	docker build -t lenzenc/docker-rails .

If you run the following command after the above finishes you should see a new image created, you can now use that image to create/run a docker container to do development on this project.

	docker images

For a little extra information about how Docker built this image see the Dockerfile which is Dockers build file for images, this one includes some comments about what each step is doing.

`NOTE` - "lenzenc" can be replaced with any value, this is basically a namespace like value.

## Running a Docker Container

From the Docker image you just created you can now run a container which will be running this sample application.  This just runs the container and is not setup for development, see below for instructions on how to use this new image for development purposes.  This is an example of how you might run this application in a CI, QA, Prod, etc environment or just wanted to clone the application and test it out.

	docker run -p 3000:3000 -t -d lenzenc/docker-rails

Let's break this down a little...

	-p 3000:3000

Tells docker to port forward any request from port 3000 or the VM the Docker container is running on to the Docker container itself.

	-t

It just a flag to tell Docker which image tag to run.

	-d

Tells Docker to run this container in a daemon.

	lenzenc/docker-rails

Is the tag name of the Docker image to run in a new container.

Run this following command to see that the container is running;

	docker ps

Note the "CONTAINER ID" value which can be used to stop/start this container, see below.

### Try It Out!

Now that the Docker container is running let's use a browser test out this sample rails application.

First you need to get the IP address of the VM that this Docker container is running on, do to so run;

	boot2docker ip

This will likely come back with an IP address of "192.168.59.103".

Now in a browser..

	http://192.168.59.103:3000

If successful you should see a HTML page with a tile of "Customer List"

Again, if you are on a Mac or Windows then you will be running a VM on your local box via boot2docker, if you are already on a linux box then you just use "localhost" because the Docker containers are running on your local box rather than on a separate VM.

### Stopping

To stop the container run;

	docker stop <<CONTAINER ID>>

Again the "CONTAINER ID" can be gotten from running __*docker ps*__.

## Development

Now that you've built and run a Docker container using this sample rails application you can now try out how you might use it to do development.

Let's start a new Docker container, this time with the following command;

	docker run -p 3000:3000 -v $(pwd):/rails -t -i lenzenc/docker-rails /bin/bash

There are a couple differences here...

	-v $(pwd):/rails

The "-v" flag tells Docker to mount the current directory, in this case "." or $(pwd) to the directory of */rails* on the container.

	-i

The "-i" flag just tells Docker to put the container in interactive mode

	/bin/bash

Overrides the *CMD /start.sh* in the Dockerfile, which starts the rails application and instead runs *bash*.

### Try It Out!

Now that you are running the container you can startup the rails application;

	./start.sh

Like above you can use a browser test out this sample rails application.

	http://192.168.59.103:3000

If successful you should see a HTML page with a tile of "Customer List"	

Now anytime you make changes to this sample application on your local box the container will automatically be sync'ed with the changes.  Give that a try, make a change the the following file;

	./app/views/customers/index.html.erb

Refresh your browser.....you should now see your changes.