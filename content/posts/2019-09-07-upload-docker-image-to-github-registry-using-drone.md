---
title: 用 Drone 自動化上傳 Docker Image 到 GitHub Docker Registry
author: appleboy
type: post
date: 2019-09-07T02:42:42+00:00
url: /2019/09/upload-docker-image-to-github-registry-using-drone/
dsq_thread_id:
  - 7622980589
dsq_needs_sync:
  - 1
categories:
  - Docker
  - Drone CI
tags:
  - Docker
  - drone

---
[![github][1]][1]

很高興收到 [GitHub][2] 的 Beta 邀請函來開始試用 [GitHub Package Registry][3] 相關功能，從說明文件可以知道目前 Registry 支援了好幾種 Package 像是 [npm][4], [gem][5], [docker][6], [mvn][7] 及 [nuget][8]，這篇主要跟大家介紹如何用 Drone 快速串接 CI/CD 流程的『自動上傳 Docker Image 到 GitHub Registry』，底下來看看如何使用 GitHub 提供的 Docker Registry。

<!--more-->

## 教學影片

更多實戰影片可以參考我的 Udemy 教學系列

  * Go 語言實戰課程: <http://bit.ly/golang-2019>
  * Drone CI/CD 自動化課程: <http://bit.ly/drone-2019>

## GitHub 認證

<pre><code class="language-bash">$ docker login docker.pkg.github.com \
  -u USERNAME \
  -p PASSWORD/TOKEN</code></pre>

要登入 GitHub 的 Docker Registry，最快的方式就是用個人的帳號及密碼就可以直接登入，而 Registry 設定則是 `docker.pkg.github.com`，這邊請注意，雖然官方有寫可以用個人的 Password 登入，如果你有使用 OTP 方式登入，這個方式就不適用，也不安全，我個人強烈建議去後台建立一把專屬的 Token。

[![Personal Token][9]][9]

其中 `read:packages` and `write:packages` 兩個 scope 請務必勾選，如果是 private 的 repo，再把 `repo` 選項打勾，這樣就可以拿到一把 token 當作是密碼，你可以透過 `docker login` 來登入試試看

## 串接 Drone CI/CD

從 commit 到自動化上傳 Docker Image 可以透過 Drone 快速完成，底下我們先建立 `Dockerfile`

<pre><code class="language-dockerfile">FROM plugins/base:multiarch

LABEL maintainer="Bo-Yi Wu <appleboy.tw@gmail.com>" \
  org.label-schema.name="Drone Workshop" \
  org.label-schema.vendor="Bo-Yi Wu" \
  org.label-schema.schema-version="1.0"

ADD release/linux/amd64/helloworld /bin/

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "/bin/helloworld", "-ping" ]

ENTRYPOINT ["/bin/helloworld"]</code></pre>

接著透過 Drone 官方 [docker][10] 套件來完成自動化上傳

<pre><code class="language-yaml">kind: pipeline
name: default

steps:
- name: build
  image: golang:1.13
  commands:
  - make build_linux_amd64

- name: docker
  image: plugins/docker
  settings:
    registry: docker.pkg.github.com
    repo: docker.pkg.github.com/appleboy/test/demo
    auto_tag: true
    auto_tag_suffix: linux-amd64
    username: appleboy
    password:
      from_secret: docker_password</code></pre>

比較需要注意的是 GitHub 跟 DockerHub 不同的是，GitHub 格式是 `OWNER/REPOSITORY/IMAGE_NAME`，注意中間有多一個 `REPOSITORY` 而 DockerHub 是 `OWNER/IMAGE_NAME`。接著到後台將 `docker_password` 設定完成，就可以正確部署了。

 [1]: https://lh3.googleusercontent.com/tR9wbUwpzzbEUnDDsZlo0jnL1AaTZRLo-T4D7Dz-PE5mN9cj6vQ94bJVzoOdUPlZtJEjxkxJvCe5WFgzKyclj94HBZdo9FMCnY5_b98ZG88pGN5v9A6jLSbY-dnz2oetLiuSi1pYI7E=w1920-h1080 "github"
 [2]: https://github.com
 [3]: https://help.github.com/en/articles/about-github-package-registry
 [4]: https://help.github.com/en/articles/configuring-npm-for-use-with-github-package-registry/
 [5]: https://help.github.com/en/articles/configuring-rubygems-for-use-with-github-package-registry/
 [6]: https://help.github.com/en/articles/configuring-docker-for-use-with-github-package-registry/
 [7]: https://help.github.com/en/articles/configuring-apache-maven-for-use-with-github-package-registry/
 [8]: https://help.github.com/en/articles/configuring-nuget-for-use-with-github-package-registry/
 [9]: https://lh3.googleusercontent.com/wLdNdGGODCbl1RKxsIg4SANzxrivIIH-IJA2zKd4FfWhtFRoVykQD4qs0GbxbOrZJuKooRhmI6R8WM0r41rDo0Asv7NdObXfGorcORR7YhYPlko91P22kXHgIMlRL1-WdnOkxtGxOo0=w1920-h1080 "Personal Token"
 [10]: http://plugins.drone.io/drone-plugins/drone-docker/