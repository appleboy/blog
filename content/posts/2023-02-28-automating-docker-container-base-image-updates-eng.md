---
title: "Automated solution for updating running Docker containers - watchtower"
date: 2023-02-28T14:52:48+08:00
author: appleboy
type: post
slug: automating-docker-container-base-image-updates-eng
share_img: https://i.imgur.com/sPCVa57.png
categories:
  - Golang
  - Watchtower
  - Docker
---

![CI](https://i.imgur.com/XbonwAZ.png)

Nowadays, most of us have containerized our services, and effectively managing and upgrading containers without affecting existing services is a critical issue. Two steps are required in the [CI/CD process](https://zh.wikipedia.org/zh-tw/CI/CD): first, packaging the environment as a Docker image and uploading it to the company's private [Docker registry](https://docs.docker.com/registry/); and second, after the upload is complete, possibly connecting to the machine via SSH, pulling the new image, and restarting the running service via the Graceful Shutdown mechanism. You can learn more about Graceful Shutdown [in this article](https://blog.wu-boy.com/2020/02/what-is-graceful-shutdown-in-golang/). I am going to introduces [Watchtower](https://containrrr.dev/watchtower), a brand new tool that automatically upgrades and updates running containers, allowing for further CD process streamlining. Developers only need to upload the Docker image, and the remote servers can update the running container automatically.

<!--more-->

The infrastructure diagram will become as below:

![CI](https://i.imgur.com/sPCVa57.png)

## What's Watchtower

Watchtower is an application developed in [Go language](https://go.dev) that monitors running Docker containers and observes whether the Docker images used when these containers were initially started have been changed. If Watchtower detects a change in the Docker image, it will automatically restart the container using the new image.

Through Watchtower, developers can easily update the running version of containerized applications by pushing new Docker images to Docker Hub or their own Docker registry. Watchtower will download your new image, gracefully shut down the existing container, and then restart it using the same options used during the initial deployment.

For example, suppose you are running Watchtower and an instance of an image called `ghcr.io/go-training/example53`:

Every few minutes, Watchtower will download the latest `ghcr.io/go-training/example53` image and compare it to the image used to run the "example53" container. If it finds that the image has been changed, it will stop/delete the "example53" container and then restart it using the new image and the same docker run options used when the container was initially started.

## How to use?

Watchtower is packaged as a Docker container itself, so installation is very simple; just pull the `containrrr/watchtower` image. If you're using an ARM-based architecture, pull the appropriate `containrrr/watchtower:armhf-tag` image from Docker Hub.

Since Watchtower's code needs to interact with the Docker API to monitor running containers, the `/var/run/docker.sock` needs to be mounted into the container using the -v flag when running the container.

Use the following command to run the Watchtower container:

```sh
docker run -d \
  --name watchtower \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower
```

If pulling images from a private Docker registry, use the `REPO_USER` and `REPO_PASS` environment variables, or mount the host's Docker configuration file into the container (located at the root of the container filesystem /).

```sh
docker run -d \
  --name watchtower \
  -e REPO_USER=username \
  -e REPO_PASS=password \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower container_to_watch --debug
```

Also, if you have 2FA authentication set up on Docker Hub, providing only your account and password won't be enough. Instead, you can run the docker login command to store the credentials in the `$HOME/.docker/config.json` file, and then mount this configuration file to make it available to the Watchtower container:

```sh
docker run -d \
  --name watchtower \
  -v $HOME/.docker/config.json:/config.json \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower container_to_watch --debug
```

## Example

Here we use the docker-compose method to test the running container.

```yml
version: "3"
services:
  example53:
    image: ghcr.io/go-training/example53:latest
    restart: always
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
    ports:
      - "8080:8080"

  watchtower:
    image: containrrr/watchtower
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: --interval 5
```

After starting, you can see the following log messages:

```sh
example53_1   | [GIN-debug] [WARNING] Creating an Engine instance with the Logger and Recovery middleware already attached.
example53_1   |
example53_1   | [GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
example53_1   |  - using env: export GIN_MODE=release
example53_1   |  - using code: gin.SetMode(gin.ReleaseMode)
example53_1   |
example53_1   | [GIN-debug] GET    /ping                     --> main.main.func1 (3 handlers)
example53_1   | [GIN-debug] GET    /                         --> main.main.func2 (3 handlers)
example53_1   | [GIN-debug] [WARNING] You trusted all proxies, this is NOT safe. We recommend you to set a value.
example53_1   | Please check https://pkg.go.dev/github.com/gin-gonic/gin#readme-don-t-trust-all-proxies for details.
example53_1   | [GIN-debug] Environment variable PORT is undefined. Using port :8080 by default
example53_1   | [GIN-debug] Listening and serving HTTP on :8080
watchtower_1  | time="2023-03-02T01:13:07Z" level=info msg="Watchtower 1.5.3"
watchtower_1  | time="2023-03-02T01:13:07Z" level=info msg="Using no notifications"
watchtower_1  | time="2023-03-02T01:13:07Z" level=info msg="Checking all containers (except explicitly disabled with label)"
watchtower_1  | time="2023-03-02T01:13:07Z" level=info msg="Scheduling first run: 2023-03-02 01:13:12 +0000 UTC"
watchtower_1  | time="2023-03-02T01:13:07Z" level=info msg="Note that the first check will be performed in 4 seconds"
watchtower_1  | time="2023-03-02T01:13:14Z" level=info msg="Session done" Failed=0 Scanned=2 Updated=0 notify=no
watchtower_1  | time="2023-03-02T01:13:19Z" level=info msg="Session done" Failed=0 Scanned=2 Updated=0 notify=no
watchtower_1  | time="2023-03-02T01:13:24Z" level=info msg="Session done" Failed=0 Scanned=2 Updated=0 notify=no
```

You can adjust the `--interval 5` parameter based on the time interval you want to monitor. Here, we set it to 5 seconds. Watchtower monitors all containers on the host by default. If you don't want certain containers to be updated, you can set the `label` in docker-compose file.

```yml
labels:
  - "com.centurylinklabs.watchtower.enable=false"
```

After upgrading, the old containers or image files still exist on the host and take up some space. You can use the `--cleanup` parameter to let Watchtower delete the old image files after using the new ones to restart the containers.

```yml
  watchtower:
    image: containrrr/watchtower
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: --interval 5 --cleanup
```

During the process, if a new image is pulled, you will see an error message below, and Watchtower will send a SIGTERM signal to the container for graceful shutdown.

```sh
watchtower_1  | time="2023-03-02T01:35:15Z" level=info msg="Found new ghcr.io/go-training/example53:latest image (040d01951ee2)"
watchtower_1  | time="2023-03-02T01:35:17Z" level=info msg="Stopping /root_example53_1 (57fc95adf8cd) with SIGTERM"
```

If you want to change the signals, you can use the label. Please modify the `Dockerfile`.

```yml
LABEL com.centurylinklabs.watchtower.stop-signal="SIGHUP"
```

Or add them when starting the container.

```sh
docker run -d --label=com.centurylinklabs.watchtower.stop-signal=SIGHUP someimage
```

## Experience Sharing

Our team can focus on packaging the image and uploading it to the Docker Registry in the CI/CD process in the future. Watchtower monitors all services on the machine, and uploaded images follow the [semver principles](https://semver.org/). This reduces a lot of the work involved in writing shell scripts.
