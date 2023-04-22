---
title: "用 Drone CI/CD 搭配 Docker BuildKit 編譯多架構映像檔"
date: 2023-04-22T07:12:47+08:00
author: appleboy
type: post
slug: drone-ci-cd-to-build-multiarch-docker-images-with-buildx
share_img: https://i.imgur.com/ySw4F8j.png
categories:
  - Drone CI/CD
  - Docker
  - Docker BuildKit
---

![cover](https://i.imgur.com/ySw4F8j.png)

在 2020 年就有 [Docker 宣布支援多架構映像檔][1]，後來才有正式的 [Docker BuildKit][2] 支援[多架構映像檔][22]，這篇文章來介紹如何使用 [Drone CI/CD][3] 搭配 [Docker BuildKit][2] 編譯多架構映像檔，而且這個功能是免費的，不需要付費的 Docker Hub 帳號。但是在 Drone CI/CD 官方提供的 [Drone Docker Plugin][4] 目前是不支援多架構映像檔，所以需要自己撰寫 Drone Pipeline，來達到我們的目的，官方也有人提出了這樣的 Proposal: 『[Support cross-arch Docker builds within Docker using QEMU][5]』，使用 QEMU 來達成目的，底下來介紹如何使用，關鍵點就是在 Host 支援 [Qemu][6] 的環境下，使用 Docker BuildKit 完成。

[1]:https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/
[2]:https://docs.docker.com/develop/develop-images/build_enhancements/
[3]:https://www.drone.io/
[4]:https://plugins.drone.io/plugins/docker
[5]:https://github.com/drone/proposal/issues/5
[6]:https://www.qemu.org/
[22]:https://docs.docker.com/build/building/multi-platform/

<!--more-->

## 什麼是 Qemu?

[Qemu][6]（Quick Emulator）是一個模擬器，可以模擬不同的 CPU 架構，例如 x86、ARM、MIPS、PowerPC 等等，這樣就可以在 x86 架構的主機上，執行 ARM 架構的映像檔，而且 Qemu 也支援 Docker BuildKit 的多架構映像檔編譯，所以我們可以在 x86 架構的主機上，執行 Docker BuildKit 來編譯多架構映像檔。

QEMU 的主要用途是在不同的環境之間提供虛擬化，它可以在一個主機上運行多個不同的虛擬機器，每個虛擬機器都可以運行不同的操作系統和應用程式。它也可以用作開發和測試軟件的工具，因為它可以模擬不同的環境，這使得開發人員可以在不同的操作系統和硬件上進行測試。

QEMU 的另一個特點是它可以運行在多種不同的平台上，包括Linux、Windows和Mac OS等等。它還提供了一個基於命令行的界面和一個圖形用戶界面，這使得它易於使用和設置。

## Qemu 運作原理

QEMU的運作原理可以簡單概括為以下三個步驟：

### 硬體模擬

QEMU會模擬虛擬硬體，例如虛擬中央處理器（CPU）、記憶體、網路卡、顯示卡等。它通過模擬這些硬體元件來創建虛擬機器。

### 執行代碼

當虛擬機器運行時，QEMU會讀取代碼並將其翻譯成可以在主機上執行的本機代碼。這個過程稱為動態二進制翻譯（Dynamic Binary Translation）或即時編譯（Just-in-time Compilation）。

### 主機和虛擬機器之間的交互

QEMU允許虛擬機器與主機之間進行通信，包括網路通信和存儲訪問等。它還提供了一些功能，如快照、重放、串流傳輸等，以便管理和監控虛擬機器。

總的來說，QEMU通過模擬虛擬硬體、翻譯代碼並與主機進行交互，實現了虛擬化的功能。這使得在單個主機上運行多個不同的虛擬機器成為可能，同時提供了一個方便的方式來進行開發和測試。

## GitHub Actions 支援 Qemu

如果你是用 GitHub Actions 來建置 Docker 映像檔，Docker 官方就有提供相關的 Actions 可以快速使用，例如 [docker/build-push-action][7]，這個 Actions 可以幫你快速建置 Docker 映像檔，並且可以支援多架構映像檔，而且不需要付費的 Docker Hub 帳號。

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

可以清楚看到上述代碼，需要先使用 docker/setup-qemu-action 來設置 Qemu，然後再使用 docker/setup-buildx-action 來設置 Docker Buildx，最後再使用 docker/build-push-action 來建置映像檔。

[7]:https://github.com/docker/build-push-action

## 使用 Drone CI/CD

如果你是用 Drone CI/CD 來建置 Docker 映像檔，Drone 官方也有提供相關的插件可以快速使用，例如 [plugins/docker][4]，這個插件可以幫你快速建置 Docker 映像檔，但是官方並沒有提供多架構映像檔的支援，所以我們需要自己來實現，不過可以[看到此留言][12]，已經有開源專案 [thegeeklab/drone-docker-buildx][8] 可以直接拿來使用，這個專案是基於 [docker/buildx][5] 來實現的，所以可以直接使用。相關使用文件[可以看這邊][9]

[8]:https://github.com/thegeeklab/drone-docker-buildx
[9]:https://drone-plugin-index.geekdocs.de/plugins/drone-docker-buildx/
[12]:https://github.com/drone/proposal/issues/5#issuecomment-1103353383

請注意，使用之前請務必要打開 [privileged 權限][10]，否則會出現錯誤。

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

另外在執行 Docker 构建之前，需要在主機上運行此命令以安裝要支持的所有平台 (請在 Runner 機器上執行)：

```sh
docker run --privileged --rm tonistiigi/binfmt --install arm64,arm,aarch64
```

在 Drone CI 後台請把專案設定勾選 **Trusted**

![cover](https://i.imgur.com/636iFsj.png)

接著就可以在 .drone.yml 內使用 docker BuildKit 來編譯多架構映像檔了：

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

### 上傳到 ECR

請參考底下 YAML 範例，請注意使用的是 `ghcr.io/bitprocessor/drone-docker-buildx-ecr:1.0.0` Image

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

編譯過程

![cover2](https://i.imgur.com/wjSSwQy.png)
