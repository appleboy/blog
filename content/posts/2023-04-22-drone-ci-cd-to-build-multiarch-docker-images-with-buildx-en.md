---
title: "Compiling multi-architecture images with Docker BuildKit using Drone CI/CD"
date: 2023-04-22T14:50:40+08:00
author: appleboy
type: post
slug: drone-ci-cd-to-build-multiarch-docker-images-with-buildx-en
share_img: https://i.imgur.com/ySw4F8j.png
categories:
  - Drone CI/CD
  - Docker
  - Docker BuildKit
---


![cover](https://i.imgur.com/ySw4F8j.png)

In 2020, Docker announced [support for multi-architecture images][1], and later, [Docker BuildKit][2] officially supported [multi-architecture images][22]. This article introduces how to use [Drone CI/CD][3] with [Docker BuildKit][2] to compile multi-architecture images, and this feature is free and does not require a paid Docker Hub account. However, the [Drone Docker Plugin][4] provided by Drone CI/CD does not currently support multi-architecture images, so you need to write your own Drone Pipeline to achieve our goal. The official website has also proposed this proposal: '[Support cross-arch Docker builds within Docker using QEMU][5]' to achieve this goal, using QEMU. The key point is to use Docker BuildKit to complete it under the environment where the Host supports [Qemu][6].

[1]:https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/
[2]:https://docs.docker.com/develop/develop-images/build_enhancements/
[3]:https://www.drone.io/
[4]:https://plugins.drone.io/plugins/docker
[5]:https://github.com/drone/proposal/issues/5
[6]:https://www.qemu.org/
[22]:https://docs.docker.com/build/building/multi-platform/

<!--more-->

## What's Qemu?

[QEMU][6] (Quick Emulator) is an emulator that can simulate different CPU architectures such as x86, ARM, MIPS, PowerPC, and more. This allows running images of ARM architecture on an x86 host. QEMU also supports multi-architecture image compilation with Docker BuildKit. Therefore, we can use Docker BuildKit to compile multi-architecture images on an x86 host.

The primary purpose of QEMU is to provide virtualization between different environments. It can run multiple different virtual machines on a single host, with each virtual machine running different operating systems and applications. It can also be used as a tool for software development and testing since it can simulate different environments, allowing developers to test on different operating systems and hardware.

Another feature of QEMU is that it can run on various platforms, including Linux, Windows, and Mac OS. It provides a command-line interface and a graphical user interface, making it easy to use and set up.

## How QEMU Works

The operation of QEMU can be summarized in three steps:

### Hardware Simulation

QEMU simulates virtual hardware such as the virtual Central Processing Unit (CPU), memory, network card, display card, etc. It creates a virtual machine by simulating these hardware components.

### Code Execution

When the virtual machine runs, QEMU reads the code and translates it into native code that can be executed on the host. This process is called Dynamic Binary Translation or Just-in-time Compilation.

### Interaction between Host and Virtual Machine

QEMU allows communication between the virtual machine and the host, including network communication and storage access. It also provides some features such as snapshot, replay, streaming transmission, etc., to manage and monitor virtual machines.

Overall, QEMU realizes virtualization by simulating virtual hardware, translating code, and interacting with the host. This makes it possible to run multiple different virtual machines on a single host, while providing a convenient way to develop and test.

## GitHub Actions Support Qemu

If you are using GitHub Actions to build Docker images, Docker provides related Actions for quick use, such as [docker/build-push-action][7]. This Action can help you quickly build Docker images and support multi-architecture images without requiring a paid Docker Hub account.

```yaml
name: ci

on:
  push:
    branches:
      - 'main'

jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
      -
        name: Set up QEMU
        uses: docker/setup-qemu-action@v2
      -
        name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      -
        name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      -
        name: Build and push
        uses: docker/build-push-action@v4
        with:
          push: true
          tags: user/app:latest
```

As can be seen from the above code, you need to use docker/setup-qemu-action to set up Qemu, then use docker/setup-buildx-action to set up Docker Buildx, and finally use docker/build-push-action to build the image.

[7]:https://github.com/docker/build-push-action

## Use Drone CI/CD

If you are using Drone CI/CD to build Docker images, the Drone official website also provides related plugins that can be used quickly, such as [plugins/docker][4]. This plugin can help you quickly build Docker images, but the official website does not provide support for multi-architecture images, so we need to implement it ourselves. However, as can be seen from [this comment][12], there is an open-source project called [thegeeklab/drone-docker-buildx][8] that can be used directly. This project is based on [docker/buildx][5], so it can be used directly. The relevant usage documentation [can be found here][9].

[8]:https://github.com/thegeeklab/drone-docker-buildx
[9]:https://drone-plugin-index.geekdocs.de/plugins/drone-docker-buildx/
[12]:https://github.com/drone/proposal/issues/5#issuecomment-1103353383

Please note that you must open [privileged permission][10] before using it, otherwise an error will occur.

[10]:https://docs.drone.io/pipeline/docker/syntax/steps/#privileged-mode

```diff
steps:
  - name: backend
    image: golang
+   privileged: true
    commands:
    - go build
    - go test
    - go run main.go -http=:3000
```

Also, before running Docker build, you need to run this command on the host to install all the platforms you want to support (please run it on the Runner machine):

```sh
docker run --privileged --rm tonistiigi/binfmt --install arm64,arm,aarch64
```

Please mark the project as Trusted in the Drone CI project setting page.

![cover](https://i.imgur.com/636iFsj.png)

Then, you can use docker BuildKit to compile multi-architecture images in .drone.yml:

```yaml
kind: pipeline
name: default

steps:
  - name: docker
    image: thegeeklab/drone-docker-buildx:23
    privileged: true
    settings:
      username: octocat
      password: secure
      repo: octocat/example
      tags: latest
      platforms:
        - linux/amd64
        - linux/arm64
```

Usually, we can use the auto_tag parameter directly, so we don't have to manually modify the version number every time, for example:

```diff
steps:
  - name: docker
    image: thegeeklab/drone-docker-buildx:23
    privileged: true
    settings:
      username: octocat
      password: secure
      repo: octocat/example
-     tags: latest
+     auto_tag: true
      platforms:
        - linux/amd64
        - linux/arm64
```

### Upload to ECR

Please refer to the YAML example below and note that it uses the `ghcr.io/bitprocessor/drone-docker-buildx-ecr:1.0.0` image.

```yaml
- name: publish_image_to_aws_registry
  pull: always
  image: ghcr.io/bitprocessor/drone-docker-buildx-ecr:1.0.0
  privileged: true
  settings:
    access_key:
      from_secret: aws_docker_push_id
    secret_key:
      from_secret: aws_docker_push_key
    auto_tag: true
    region: ap-southeast-1
    Dockerfile: docker/Dockerfile.aws
    cache_from: xxxxxxxxxxxx.dkr.ecr.ap-southeast-1.amazonaws.com/user-service
    registry: xxxxxxxxxxxx.dkr.ecr.ap-southeast-1.amazonaws.com
    repo: user-service
    platforms:
      - linux/arm64
      - linux/amd64
```

The following is a reference image of the compilation process:

![cover2](https://i.imgur.com/wjSSwQy.png)
