---
title: 用 Travis 自動上傳 Docker Image 到 Docker Registry
author: appleboy
type: post
date: 2016-09-17T07:13:28+00:00
url: /2016/09/upload-docker-image-to-registry-using-travis/
dsq_thread_id:
  - 5150735032
categories:
  - DevOps
  - Docker
tags:
  - Docker
  - Travis
  - Travis CI

---
[<img src="https://i1.wp.com/farm2.staticflickr.com/1600/25660808075_c8190290f7_c.jpg?w=840&#038;ssl=1" alt="" data-recalc-dims="1" />][1]

在今年七月寫了一篇『[在 Travis 升級 Docker 和 docker-compose 版本][2]』，就在上個月底 [Travis][3] 終於將 [Docker][4] 預設版本換成 1.12.x 版本，並且將 [docker-compose][5] 也一併升級到 1.8.0，這樣就可以不用手動升級了。那這篇會紀錄如何用 Travis 自動編譯 Docker Image 並且上傳到 [Docker Hub][6]。Docker Hub 提供兩種方式讓開發者上傳 Image，第一種是透過 Command line 下指令手動上傳，另外一種則是在 Docker Hub 後台指定 Dockerfile 路徑及需要執行編譯的分支，這樣只要 Push commit 到 [Github][7]，Docker Hub 就會根據 [Dockerfile][8] 來自動編譯 Docker Image。本篇會介紹如何透過 Travis 服務來自動上傳 Dokcer Image，像是 Golang 的部屬方式通常是編譯出 Binary 執行檔後，將此執行檔加入 Image 最後才上傳。

<!--more-->

### 在 Travis 啟動 Docker Service

啟動方式非常簡單，只要加入底下程式碼到 `.travis.yml`

<pre><code class="language-yml">services:
  - docker</code></pre>

### 準備 Dockerfile 編譯 Image

我們用 Golang 為例，底下是 Dockerfile 範例

<pre><code class="language-bash">FROM alpine:3.4

RUN apk update && \
  apk add \
    ca-certificates && \
  rm -rf /var/cache/apk/*

ADD drone-line /bin/
ENTRYPOINT ["/bin/drone-line"]</code></pre>

接著透過底下指令編譯出 Dokcer Image

<pre><code class="language-bash">$ docker build --rm -t $(DEPLOY_ACCOUNT)/$(DEPLOY_IMAGE) .</code></pre>

`DEPLOY_ACCOUNT` 是 Dokcer hub 帳號，以我的帳號為例就是 [appleboy][9]，`DEPLOY_IMAGE` 則是 Image 名稱。請將這指令寫道 `.travis.yml` 內的 `script` 內

<pre><code class="language-yml">script:
  # 執行測試
  - make test
  # 通過測試後開始編譯 Image
  - docker build --rm -t $DEPLOY_ACCOUNT/$DEPLOY_IMAGE .</code></pre>

最後一道指令就是上傳了

### 上傳 Image 到 Docker Hub

由於上傳到 Docker Hub，需要登入帳號密碼，而 Travis 提供兩種方式讓開發者設定 Private global value，你不會想把帳號密碼用明碼方式寫在 `.travis.yml` 吧。在早期 Travis 只提供一種方式就是透過 `travis` 指令來新增，詳細指令可以參考[這文件][10]，這邊就不教大家指令了，而另一種方式就是到 Travis 管理頁面直接進到 settings 設定即可

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/29442189190/in/dateposted-public/" title="Screen Shot 2016-09-17 at 3.03.12 PM"><img src="https://i0.wp.com/c7.staticflickr.com/9/8268/29442189190_4d872ed6ac_z.jpg?resize=640%2C254&#038;ssl=1" alt="Screen Shot 2016-09-17 at 3.03.12 PM" data-recalc-dims="1" /></a>

將帳號密碼設定完成後，請在 `after_success` 加上上傳指令

<pre><code class="language-yml">after_success:
  - if [ "$TRAVIS_BRANCH" == "master" ] && [ "$TRAVIS_GO_VERSION" == "1.7.1" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
    docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD";
    make docker_deploy tag=latest;
    fi</code></pre>

上面表示只要是 `master` 分支，測試環境為 Golang 1.7.1 且不是在 Pull Request 狀態就執行登入，並且上傳，其中 `make docker_deploy tag=latest` 代表意思如下 (我把指令寫在 Makefile 內):

<pre><code class="language-bash">docker tag $(DEPLOY_ACCOUNT)/$(DEPLOY_IMAGE):latest $(DEPLOY_ACCOUNT)/$(DEPLOY_IMAGE):$(tag)
docker push $(DEPLOY_ACCOUNT)/$(DEPLOY_IMAGE):$(tag)</code></pre>

上面步驟完成，之後只要 commit 到主分支，Travis 就會自動編譯 Image 並且上傳到 Dokcer Hub，蠻方便的。

 [1]: https://i1.wp.com/farm2.staticflickr.com/1600/25660808075_c8190290f7_c.jpg?ssl=1
 [2]: https://blog.wu-boy.com/2016/07/upgrade-docker-and-docker-compose-on-travis/
 [3]: https://travis-ci.org/
 [4]: https://www.docker.com/
 [5]: https://docs.docker.com/compose/
 [6]: https://hub.docker.com/
 [7]: https://github.com/
 [8]: https://docs.docker.com/engine/reference/builder/
 [9]: https://hub.docker.com/u/appleboy/
 [10]: https://docs.travis-ci.com/user/environment-variables/