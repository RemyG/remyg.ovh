---
title: Learning Docker
date: 2017-09-10T20:00:0+00:00
author: RemyG
layout: rg-post
categories: Development
tags:
  - docker
---

## What is Docker?

From the official [Docker website](https://www.docker.com/what-docker):

> Docker is the world’s leading software container platform. Developers use Docker to eliminate "works on my machine" problems when collaborating on code with co-workers. Operators use Docker to run and manage apps side-by-side in isolated containers to get better compute density. Enterprises use Docker to build agile software delivery pipelines to ship new features faster, more securely and with confidence for both Linux, Windows Server, and Linux-on-mainframe apps.

<!--more-->

Docker allows you to run any application in a **Container**, which can be compared to a very lightweight VM, because it doesn't include a guest OS, and uses the host OS and the Docker layer. A good representation of the difference between a Container and a Virtual Machine can be found [here](https://www.docker.com/what-container#comparing).

A Docker container runs an instance of a Docker **image**, which is a set of layers that describe how the container will behave. An image is built from a Dockerfile, which contains the set of layers (or instructions).

A simple Dockerfile can look like this:
```
FROM alpine
CMD ["echo", "hello world"]
```

When run, this will instantiate an Alpine (very lightweight Linux distribution) container, and run the command ```echo hello world``` on it.

## Installing Docker

Docker comes in 2 editions: EE (Enterprise Edition) and CE (Community Edition)

It's really easy to install Docker CE on a Linux OS. You can find the instructions [on the official website](https://docs.docker.com/engine/installation/), but there is an even easier way:

    curl -sSL https://get.docker.com | sh

That's it. They've created an installation script that will handle everything for you. Of course you can check the script by going to [https://get.docker.com](https://get.docker.com), but you can see it's pretty straightforward.
The script is compatible with the following distributions:
```
centos
fedora
debian
ubuntu
raspbian
```

## Interactive Docker tutorials

There are several online interactive tutorials to start working with Docker. These are some I've tried:
* http://training.play-with-docker.com/
* https://www.katacoda.com/courses/docker

These tutorials will guide you through your first steps on Docker, like:
* running your first container
* developing and deploying a web application
* deploying a multi-service application in Docker Swarm (a swarm is a group of multiple slave nodes that are orchestrated by a master node, which handles scaling, multi-host networking,...)
* working with ```docker-compose``` (a tool for defining and running multi-container applications)

## Basic commands


### Running an existing image

We will start with running an existing image: ```hello-world```.

```
docker run hello-world
```

This command will try to find the image ```hello-world``` locally. If not found, Docker will retrieve (pull) it from the Docker Hub, then create a new container to run the image.


### Building a new image

To build your own Docker image, you need to start by creating a Dockerfile. Just create a new file named ```Dockerfile```, with the following content:
```
FROM alpine
CMD ["echo", "hello world"]
```

This means that our image will be based on the ```alpine``` image, and it's first instruction will be to run the command ```echo hello world```.

To build this image, go to the directory where the Dockerfile is situated, and run:
```
docker build .
```

This will build the image, and assign an ID to it. If you want to see the list of your local image, run:
```
docker image ls
```

This will produce an output like:
```
REPOSITORY           TAG             IMAGE ID            CREATED             SIZE
<none>               <none>          88a7f54c5478        9 minutes ago       3.97MB
```

As you can see, our image has been built and assigned an ID, but it's not very easy to remember and use. You can assign a name and a tag to your image:
```
docker build . -t my-hello-world:0.1
```

Now, listing your images will produce:
```
REPOSITORY           TAG             IMAGE ID            CREATED             SIZE
my-hello-world       0.1             88a7f54c5478        11 minutes ago      3.97MB
```

And you can run your local image with:
```
docker run my-hello-world
```

### Working with containers

After running an image (which creates a container), you can list your active containers with:
```
docker container ls
```
or
```
docker ps
```

If you've only launched the example image, nothing will appear, because the container shuts down immediately after the execution. You can display all the containers that have been instantiated with the option ```-a```. You can now see the history of your containers:
```
CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS                      PORTS                 NAMES
a4cdb876df53        my-hello-world:0.1             "echo 'hello world'"     2 minutes ago       Exited (0) 2 minutes ago                          blissful_murdock
5f2e1d383f74        my-hello-world                 "echo 'hello world'"     2 minutes ago       Exited (0) 2 minutes ago                          compassionate_davinci
b4e9eceae360        hello-world                    "/hello"                 12 minutes ago      Exited (0) 12 minutes ago                         suspicious_hermann
```

To stop a running container named ```blissful_murdock```:
```
docker stop blissful_murdock
```
To remove a stopped container:
```
docker rm blissful_murdock
```

## My next steps

I've described the basics of Docker. The next step I've taken is to host my Jekyll blog on an Nginx container, hosted on a RaspberryPi. This will be the subject of a following post.

I also intend to start working on Java development with Docker, and will probably write on that as well.

![](http://www.commitstrip.com/wp-content/uploads/2016/06/Strip-Discussion-Docker-english650final-1.jpg)
