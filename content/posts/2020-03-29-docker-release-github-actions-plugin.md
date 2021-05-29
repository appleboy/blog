---
title: Docker 推出官方 GitHub Actions 套件
author: appleboy
type: post
date: 2020-03-29T13:32:28+00:00
url: /2020/03/docker-release-github-actions-plugin/
dsq_thread_id:
  - 7940372289
categories:
  - DevOps
  - Docker
  - Drone CI
tags:
  - Docker
  - drone
  - drone ci
  - GitHub Actions

---
[![cover][1]][1]

去年 [GitHub][2] 推出 [Actions][3]，就有不少開發者相繼把 CI/CD 流程內會使用到的 Plugin 都丟到 [Marktetplace][4]，而在這 [Docker][5] 容器時代，肯定是需要用自動化上傳容器到 Docker Registry，而官方也在[上週正式釋出第一版 GitHub Actions][6]，雖然在 Marktet 尚有不少開發者已經有實現了此功能，但是官方既然推出了，就採用官方的套件會比較適合。底下我們來看看如何使用 Docker 推出的 GitHub Aciton 來自動化上傳 Docker Image。除了介紹如何使用 GitHub Action 上傳 Image 外，我也會拿 [Drone][7] 的 [Docker Plugin][8] 來進行比較。

<!--more-->

## 教學影片

{{< youtube lEkDdIkqHwI >}}

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][9]
  * [一天學會 DevOps 自動化測試及部署][10]
  * [DOCKER 容器開發部署實戰][11] (課程剛啟動，限時特價 $900 TWD)

如果需要搭配購買請直接透過 [FB 聯絡我][12]，直接匯款（價格再減 **100**）

## 如何使用 GitHub Action 上傳 Image

首先準備用 Go 語言服務來當作範例，底下是 Dockerfile 設定，本篇的程式碼的都可以在[這邊找到][13]。

<pre><code class="language-dockerfile">FROM golang:1.14-alpine

LABEL maintainer="Bo-Yi Wu <appleboy.tw@gmail.com>"

RUN apk add bash ca-certificates git gcc g++ libc-dev
WORKDIR /app
# Force the go compiler to use modules
ENV GO111MODULE=on
# We want to populate the module cache based on the go.{mod,sum} files.
COPY go.mod .
COPY go.sum .
COPY main.go .

ENV GOOS=linux
ENV GOARCH=amd64
RUN go build -o /app -tags netgo -ldflags '-w -extldflags "-static"' .

CMD ["/app"]</code></pre>

Docker 詳細的設定方式可以參考[此文件][14]

<pre><code class="language-yml">- name: build and push image
  uses: docker/build-push-action@v1
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_PASSWORD }}
    repository: appleboy/gin-docker-demo
    dockerfile: Dockerfile
    always_pull: true
    tags: latest</code></pre>

由於我們是拿 docker hub 當作範例，故不需要指定 registry，假設您只要有下 git tag 才做上傳的話，可以使用

<pre><code class="language-yaml">- name: build and push image
  uses: docker/build-push-action@v1
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_PASSWORD }}
    repository: appleboy/gin-docker-demo
    dockerfile: Dockerfile
    tag_with_ref: true
    push: ${{ startsWith(github.ref, 'refs/tags/') }}</code></pre>

其實設定不難，整個過程的 Log 可以看[這邊][15]。底下來介紹 Drone 的使用方式

## 用 Drone 上傳 Docker Image

GitHub Actions 的版本跟 Drone 的 Plugin 共通點都是用 CLI 完成全部指令，也全都用 Go 語言打造，所以設定方式其實蠻雷同的。

<pre><code class="language-yaml">- name: publish
  pull: always
  image: plugins/docker:linux-amd64
  settings:
    auto_tag: true
    cache_from: appleboy/gin-docker-demo
    daemon_off: false
    dockerfile: Dockerfile
    password:
      from_secret: docker_password
    repo: appleboy/gin-docker-demo
    username:
      from_secret: docker_username
  when:
    event:
      exclude:
      - pull_request</code></pre>

兩邊設定完成後，可以透過兩邊的 Log 方式，為什麼 Drone 只需要不到半分鐘的時間就可以執行完畢，而在 GitHub Actions 則是需要一分鐘以上，原因在於 Drone 支援了 `--cache-from`，不了解的可以直接參考『[在 docker-in-docker 環境中使用 cache-from 提升編譯速度][16]』，大概的意思就是在 docker build 之前，先把最新版本的 Image 下載下來，這時候在編譯的時候就會找到相同的 docker layer 而進行 Cache 動作。不過別擔心，為了能讓 GitHub Action 享有這個機制，我也發了 [PR 來支援此參數][17]，等到官方審核通過就可以使用了。

 [1]: https://lh3.googleusercontent.com/HM1o-XLKQSuzYOobmH10dENcm8KwZ3eMqHt99LWMLHMw_14CBHJEr8xuktBUvQFInGX1oLetjI97GkoHCTWFzaXLT_-YBVNv0_jsHYS1Fd2mDXk-v68I4itwP54-4eSZiQ3MewsF47U=w1920-h1080 "cover"
 [2]: https://github.com
 [3]: https://github.com/features/actions
 [4]: https://github.com/marketplace?type=actions
 [5]: https://docker.com
 [6]: https://www.docker.com/blog/first-docker-github-action-is-here/
 [7]: https://drone.io/
 [8]: http://plugins.drone.io/drone-plugins/drone-docker/
 [9]: https://www.udemy.com/course/golang-fight/?coupon
Code=202003
 [10]: https://www.udemy.com/course/devops-oneday/?couponCode=202003
 [11]: https://www.udemy.com/course/docker-practice/?couponCode=202003
 [12]: http://facebook.com/appleboy46
 [13]: https://github.com/go-training/docker-in-github-actions-vs-drone
 [14]: https://github.com/marketplace/actions/build-and-push-docker-images
 [15]: https://github.com/go-training/docker-in-github-actions-vs-drone/runs/542876427?check_suite_focus=true
 [16]: https://blog.wu-boy.com/2019/02/using-cache-from-can-speed-up-your-docker-builds/
 [17]: https://github.com/docker/github-actions/pull/17
