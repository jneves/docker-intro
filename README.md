# POP

## Introduction to docker

### João Neves - joao@wegotpop.com
### June 2017

---

# Objectives for today

* Understand what docker does, its advantages and disadvantages.
* Install docker
* Run a command on a docker container
* Customise a docker container
* Debugging a running docker container
* Introduction to docker_compose
* Start/restart stop a set of containers

---

# Docker

* Containers
* Union file-system

## Docker vs Hardware Servers

* Less requirements
* Faster start of another container
* Easier to replicate/scale

## Docker vs Virtualization

* Only runs linux apps
* No overhead to isolate another OS
* App vs Computer
* Faster start of another container

---

# Install docker

* Mac - https://docs.docker.com/docker-for-mac/install/#download-docker-for-mac
* Linux - https://docs.docker.com/engine/installation/
* Windows - https://docs.docker.com/docker-for-windows/install/#download-docker-for-windows

---

# Running a command on a docker container

For running a docker container you need:

* Docker installed
* A docker image

Try this now: `docker run hello-world`

If you want, you can run a command instead of the default one:

`docker run debian:jessie bash -c "echo Hello World"`

This runs `echo Hello World` on a bash shell on Debian Jessie image. Can you change it to output something else?

---

# Customising things

## Running an nginx server with static content I

`docker run --rm --name some-nginx -v /Users/joao/Sites:/usr/share/nginx/html:ro -d nginx`

See if it's running with `docker ps`:

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
af5d79b14a76        nginx               "nginx -g 'daemon ..."   18 hours ago        Up 18 hours         80/tcp                 some-nginx
```

Important things to note:
 * ID - you'll need this for all operations
 * PORTS - which ports are available, and which ports are they mapped to (ex: 0.0.0.0:8080->80/tcp)

---

# Customising things

## Running an nginx server with static content II

Try to access with http://localhost/ .

See if there's anything in the logs with `docker logs <id>`.

Stop it with `docker stop <id>`.

---

# Customising things

## Running an nginx server with static content III

`docker run --rm --name some-nginx -v /Users/joao/Sites:/usr/share/nginx/html:ro -d -p 8080:80 nginx`

Try to access with http://localhost:8080/ .

See if there's anything in the logs with `docker logs <id>`.

---

# Debugging

## docker ps

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
af5d79b14a76        nginx               "nginx -g 'daemon ..."   18 hours ago        Up 18 hours         80/tcp                 some-nginx
```

Important things to note:
 * ID - you'll need this for all operations
 * IMAGE - image used for the container
 * COMMAND - the process that is running - if this process dies, so does the container
 * CREATED - when the container was created
 * STATUS - is it up or down? for how long? a failure to restart will constantly show seconds here
 * PORTS - which ports are available, and which ports are they mapped to (ex: 0.0.0.0:8080->80/tcp)
 * NAME - container name

Looking for a disappeared container? Use `docker ps -a` (all).

---

# Debugging

## docker logs

We've already seen `docker logs <id>`.

But you can see what's happening in realtime with `docker logs -f <id>`.

## Inspect the container

`docker exec -it <id> /bin/bash`

This gives you a shell inside the container, with this you can inspect what's going on inside. Some containers don't have bash, in those cases try:

`docker exec -it <id> /bin/sh`

---

# You can build your own docker container

1. Write your own Dockerfile.
2. Build the docker container.
3. Run it.

## Let's do a web server with a custom static page.

```
# Use an official nginx runtime as a base image
FROM nginx:latest

# Set the working directory to the static page dir
WORKDIR /usr/share/nginx/html

# Copy the current directory contents into the container at /usr/share/nginx/html
ADD . /usr/share/nginx/html

# Make port 80 available to the world outside this container
EXPOSE 80

# Run nginx when the container launches
CMD /usr/sbin/nginx -g 'daemon off;'
```

---

# Build container

`docker build -t tutorialsite .`

Note the images being built in layers!

# Run the container

`docker run --rm -p 4000:80 tutorialsite`

Now go to http://localhost:4000/

---

# But when you want to launch multiple configurations...

there is `docker-compose`

You setup a configuration file like:
```
web:
  image: tutorialsite
  ports:
    - "4000:80"
```

Run:

`docker-compose -f tutorial.cfg up -d`

and check if it's working and respoding at http://localhost:4000/

`docker-compose -f tutorial.cfg down`

to cleanup

---

# You can even use it to avoid creating images

```
web:
  image: nginx
  volumes:
   - .:/usr/share/nginx/html
  ports:
   - "4000:80"
  command: ['/usr/sbin/nginx', '-g', 'daemon off;']
```

Run:

`docker-compose -f tutorial1.cfg up -d`

and check if it's working and respoding at http://localhost:4000/

`docker-compose -f tutorial1.cfg down`

to cleanup

---

# Or for multiple services

```
web:
  image: nginx
  volumes:
   - .:/usr/share/nginx/html
  ports:
   - "4000:80"
  command: ['/usr/sbin/nginx', '-g', 'daemon off;']
web1:
  image: nginx
  volumes:
   - .:/usr/share/nginx/html
  ports:
   - "4004:80"
  command: ['/usr/sbin/nginx', '-g', 'daemon off;']
```

Run:

`docker-compose -f tutorial2.cfg up -d`

and check if it's working and respoding at http://localhost:4000/ and http://localhost:4004/

`docker-compose -f tutorial2.cfg down`

to cleanup

---

# More resources

Docker documentation: https://docs.docker.com/get-started/

Docker Hub: https://hub.docker.com/ (the default registry)

---

# That's all folks!

## Questions? Comments?
