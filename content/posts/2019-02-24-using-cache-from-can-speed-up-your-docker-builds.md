---
title: 在 docker-in-docker 環境中使用 cache-from 提升編譯速度
author: appleboy
type: post
date: 2019-02-24T12:37:23+00:00
url: /2019/02/using-cache-from-can-speed-up-your-docker-builds/
dsq_thread_id:
  - 7253249864
categories:
  - DevOps
  - Docker
  - Drone CI
tags:
  - Docker
  - drone
  - GitLab

---
[![提升 docker build 時間][1]][1]

在現代 CI/CD 的環境流程中，使用 [Docker In Docker][2] 來編譯容器已經相當流行了，像是 [GitLab CI][3] 或 [Drone][4] 都是全走 [Docker][5] 環境，然而有很多人建議盡量不要在 CI 環境使用 Docker In Docker，原因在於 CI 環境無法使用 Host Image 資料，導致每次要上傳 Image 到 [Docker Hub][6] 時都需要重新下載所有的 Docker Layer，造成每次跑一次流程都會重複花費不少時間，而這個問題在 [v1.13][7] 時被解決，現在只要在編譯過程指定一個或者是多個 Image 列表，先把 Layer 下載到 Docker 內，接著對照 Dockerfile 內只要有被 Cache 到就不會重新再執行，講得有點模糊，底下直接拿實際例子來看看。

<!--more-->

## 教學影片

歡迎訂閱我的 Youtube 頻道: <http://bit.ly/youtube-boy>

更多實戰影片可以參考我的 Udemy 教學系列

  * Go 語言實戰課程: <http://bit.ly/golang-2019>
  * Drone CI/CD 自動化課程: <http://bit.ly/drone-2019>

## 使用 --cache-from 加速編譯

在 Docker v1.13 版本中新增了 `--cache-from` 功能讓開發者可以在編譯 Dockerfile 時，同時指定先下載特定的 Docker Image，透過先下載好的 Docker Layer 在跟 Dockerfile 內文比較，如果有重複的就不會在被執行，這樣可以省下蠻多編譯時間，底下拿個簡單例子做說明，假設我們有底下的 Dockerfile

<pre><code class="language-docker">FROM alpine:3.9
LABEL maintainer="maintainers@gitea.io"

EXPOSE 22 3000

RUN apk --no-cache add \
    bash \
    ca-certificates \
    curl \
    gettext \
    git \
    linux-pam \
    openssh \
    s6 \
    sqlite \
    su-exec \
    tzdata

RUN addgroup \
    -S -g 1000 \
    git && \
  adduser \
    -S -H -D \
    -h /data/git \
    -s /bin/bash \
    -u 1000 \
    -G git \
    git && \
  echo "git:$(dd if=/dev/urandom bs=24 count=1 status=none | base64)" | chpasswd

ENV USER git
ENV GITEA_CUSTOM /data/gitea

VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]

COPY docker /
COPY --from=build-env /go/src/code.gitea.io/gitea/gitea /app/gitea/gitea
RUN ln -s /app/gitea/gitea /usr/local/bin/gitea</code></pre>

透過底下命令列可以編譯出 Image

<pre><code class="language-sh">$ docker build -t gitea/gitea .</code></pre>

而在命令列內可以看到花最多時間的是底下這個步驟

<pre><code class="language-docker">RUN apk --no-cache add \
    bash \
    ca-certificates \
    curl \
    gettext \
    git \
    linux-pam \
    openssh \
    s6 \
    sqlite \
    su-exec \
    tzdata</code></pre>

該如何透過 `--cache-from` 機制繞過此步驟加速 Docker 編譯時間，其實很簡單只要在網路上找到原本 image 就可以繞過此步驟，開發者總會知道原本的 Dockerfile 是用來編譯出哪一個 Image 名稱

<pre><code class="language-sh">$ docker build --cache-from=gitea/gitea -t gitea/gitea .</code></pre>

[![][8]][8]

從上圖可以知道時間最久的步驟已經被 cache 下來了，所以 cache-from 會事先把 Image 下載下來，接著就可以使用該 Image 內的 cache layer 享受簡短 build time 的好處。

## 在 Gitlab CI 使用 cache-from

在 Gitlab CI 如何使用，其實很簡單，請[參考此範例][9]

<pre><code class="language-yaml">image: docker:latest
services:
  - docker:dind
stages:
  - build
  - test
  - release
variables:
  CONTAINER_IMAGE: registry.anuary.com/$CI_PROJECT_PATH
  DOCKER_DRIVER: overlay2
build:
  stage: build
  script:
    - docker login -u gitlab-ci-token -p $CI_BUILD_TOKEN registry.anuary.com
    - docker pull $CONTAINER_IMAGE:latest
    - docker build --cache-from $CONTAINER_IMAGE:latest --build-arg NPM_TOKEN=${NPM_TOKEN} -t $CONTAINER_IMAGE:$CI_BUILD_REF -t $CONTAINER_IMAGE:latest .
    - docker push $CONTAINER_IMAGE:$CI_BUILD_REF
    - docker push $CONTAINER_IMAGE:latest</code></pre>

這時候你會問時間到底差了多久，在 Node.js 內如果沒有使用 cache，每次 CI 時間至少會多不少時間，取決於開發者安裝多少套件，我會建議如果是使用 multiple stage build 請務必使用 `cache-from`。

## 在 Drone 如何使用 --cache-from

在 Drone 1.0 架構內，可以架設多台 [Agent 服務][10]加速 CI/CD 流程，但是如果想要跨機器的 storage 非常困難，所以有了 `cache-from` 後，就可以確保多台 agent 享有 docker cache layer 機制。底下來看看 [plugins/docker][11] 該如何設定。

<pre><code class="language-yaml">- name: publish
  pull: always
  image: plugins/docker:linux-amd64
  settings:
    auto_tag: true
    auto_tag_suffix: linux-amd64
    cache_from: appleboy/drone-telegram
    daemon_off: false
    dockerfile: docker/Dockerfile.linux.amd64
    password:
      from_secret: docker_password
    repo: appleboy/drone-telegram
    username:
      from_secret: docker_username
  when:
    event:
      exclude:
      - pull_request</code></pre>

這邊拿公司的一個環境當作[範例][12]，在還沒使用 cache 前編譯時間為 [2 分 30 秒][13]，後來使用 `cache-from` 則變成 [30 秒][14]。

## 結論

使用 `--cache-from` 需要額外多花下載 Image 檔案的時間，所以開發者需要評估下載 Image 時間跟直接在 Dockerfile 內直接執行的時間差，如果差很多就務必使用 `--cache-from`。不管是不是應用在 Docker In Docker 內，假如您需要改別人 Dockerfile，請務必先下載對應的 Docker Image 在執行端，這樣可以省去不少 docker build 時間，尤其是在 Dockerfile 內使用到 `apt-get instll` 或 `npm install` 這類型的命令。

 [1]: https://lh3.googleusercontent.com/NxYD5o3PrenPHddPaNvv8EMK6u-cUdx5KnmmdYMXpxLzD9oDcTAchd0q4GRJxsOLJkeAhhVxzDmcJoWIzHqyo6hTV1FYZXzUbQ-elJNzlqKTYcBJcAOhkansgWHPTleQGOz92xwv_zE=w1920-h1080 "提升 docker build 時間"
 [2]: https://github.com/jpetazzo/dind
 [3]: https://about.gitlab.com/product/continuous-integration/
 [4]: https://github.com/drone/drone "Drone"
 [5]: https://www.docker.com/ "Docker"
 [6]: https://hub.docker.com/ "Docker Hub"
 [7]: https://github.com/docker/docker/releases/tag/v1.13.0
 [8]: https://lh3.googleusercontent.com/H_L7tVmjocwOvWEB4DgJsjhPqGyY3IObcl6f0ROl34qfUqDhnIaC9BtI4pN4I7RidYUg_VLw7bRtDdkDEG1eCk6EPdMZ8itjGvWm5aaobn-5oye7j0AsXQCIHIpZUfUW3XGvKCA1a1k=w1920-h1080
 [9]: https://gitlab.com/snippets/185782 "參考此範例"
 [10]: https://docs.drone.io/administration/agents/ "Agent 服務"
 [11]: https://github.com/drone-plugins/drone-docker "plugins/docker"
 [12]: https://github.com/Mediatek-Cloud/simulator "範例"
 [13]: https://cloud.drone.io/Mediatek-Cloud/simulator/2/1/2 "2 分 30 秒"
 [14]: https://cloud.drone.io/Mediatek-Cloud/simulator/6/1/2 "30 秒"