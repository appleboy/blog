---
title: 在 Travis 實現 Docker Cache
author: appleboy
type: post
date: 2016-09-17T08:25:13+00:00
url: /2016/09/docker-cache-on-travis/
dsq_thread_id:
  - 5150839583
categories:
  - DevOps
  - Docker
tags:
  - Docker
  - Travis
  - Travis CI

---
[<img src="https://i1.wp.com/farm2.staticflickr.com/1600/25660808075_c8190290f7_c.jpg?w=840&#038;ssl=1" alt="" data-recalc-dims="1" />][1]

前一篇寫了『[用 Travis 自動上傳 Docker Image][2]』，Travis 跑完測試成功後才自動編譯 Docker Image 並且上傳到 Docker Hub。在每次 commit 後，[Travis][3] 執行 docker build 時間總是非常長，當然原因很多。如果選用的 Docker base image 非常肥，指令非常多，每次編譯都要重新下載及執行指令，所以執行時間就是這麼長。本篇就是想辦法減少 Travis 編譯 Image 時間，就像把 `node_modules` 壓縮起來，下次執行測試前先解壓縮再安裝，可以大幅減少 npm install 時間(可以參考之前的『[用一行指令加速 npm install][4]』)。這邊我們就需要用到 Travis 的 [Cache 功能][5]。

<!--more-->

### 啟動 Travis Cache 快取服務

啟動方式如下:

```bash
cache:
  directories:
    - ${HOME}/docker
```

假設有其他目錄需要 cache，像是 [npm][6] 的 `node_module` 或是 [Laravel][7] 的 `vendor`，都可以透過此方式設定。

### 讀取 Docker Cache 快取

在 `before_install` 內透過 [docker load][8] 指令讀取 cache 資料

```bash
before_install:
  - if [ -f ${DOCKER_CACHE_FILE} ]; then gunzip -c ${DOCKER_CACHE_FILE} | docker load; fi
```

其中 DOCKER\_CACHE\_FILE 可以定義在 env 內

```yml
env:
  global:
    - DOCKER_CACHE_FILE=${HOME}/docker/cache.tar.gz
```

### 儲存 Docker Image cache 快取

經過測試及編譯 Image 後，就可以進行 儲存 Docker 快取

```yml
script:
  # 進行測試
  - make test
  # 編譯 Image
  - make docker
  # 儲存快取
  - if [ "$TRAVIS_BRANCH" == "master" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
    mkdir -p $(dirname ${DOCKER_CACHE_FILE});
    docker save $(docker history -q appleboy/drone-line:latest | grep -v '<missing>') | gzip > ${DOCKER_CACHE_FILE};
    fi
```

透過 [docker save][9] 指令將 Image 存起來，這樣下次再執行編譯 Image 時，就會先找看看是否有快取。上面設定只有 master branch 才會儲存快取，但是在任何一個 branch 都可以享受到快取的服務喔。

 [1]: https://i1.wp.com/farm2.staticflickr.com/1600/25660808075_c8190290f7_c.jpg?ssl=1
 [2]: https://blog.wu-boy.com/2016/09/upload-docker-image-to-registry-using-travis/
 [3]: https://travis-ci.com/
 [4]: https://blog.wu-boy.com/2016/07/speed-up-npm-install-command/
 [5]: https://docs.travis-ci.com/user/caching/
 [6]: https://www.npmjs.com/
 [7]: https://laravel.com/
 [8]: https://docs.docker.com/engine/reference/commandline/load/
 [9]: https://docs.docker.com/engine/reference/commandline/save/