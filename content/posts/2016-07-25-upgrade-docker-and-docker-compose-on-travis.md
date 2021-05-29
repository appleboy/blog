---
title: 在 Travis 升級 Docker 和 docker-compose 版本
author: appleboy
type: post
date: 2016-07-25T13:10:56+00:00
url: /2016/07/upgrade-docker-and-docker-compose-on-travis/
dsq_thread_id:
  - 5012991895
categories:
  - DevOps
  - Docker
  - Testing
tags:
  - Docker
  - Github
  - Travis
  - Travis CI

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/25660808075/in/dateposted-public/" title="docker"><img src="https://i2.wp.com/farm2.staticflickr.com/1600/25660808075_c8190290f7_z.jpg?resize=640%2C217&#038;ssl=1" alt="docker" data-recalc-dims="1" /></a>

[Travis][1] 是在 [Github][2] 上常用的整合測試服務，支援了各種程式語言 [Golang][3], PHP, Node.js ..等測試及部署，也同時支援了一些常用 Service，像是 [Docker][4], Redis 或 Database。這次來聊聊[在 Travis 如何使用 Docker][5]，在 Travis 內建的 Docker 跟 [docker-compose][6] 版本都是非常舊，所以使用預設的 docker-compose 指令常常會出現 (詳細 build log 可以參考[這裡][7])

<!--more-->

### Error log

會有兩種錯誤訊息，第一種是

> docker-compose -f docker/docker-compose.yml run golang-build Creating network "docker_default" with the default driver ERROR: 404 page not found make: \*** [test] Error 1

第二種是

> docker-compose -f docker/docker-compose.yml run golang-build Unsupported config option for services service: 'golang-build' make: \*** [test] Error 1

### 解法

雖然官方網站有教如何升級 docker-compose，但是光是升級 docker-compose 是沒用的，如果 [docker-engine][8] 沒有升級，還是會出現此錯誤訊息，正確解法就是將 docker 也順便升級，打開 `.travis.yml` 檔案，在 `before_install` 內補上底下 script。

```yml
services:
  - docker

env:
  DOCKER_COMPOSE_VERSION: 1.7.1

before_install:
  - sudo apt-get -y update
  - sudo apt-get -y purge docker-engine
  - sudo apt-get -y install docker-engine
  - sudo rm /usr/local/bin/docker-compose
  - curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
  - chmod +x docker-compose
  - sudo mv docker-compose /usr/local/bin
```

請參考完整的 [.travis.yml 設定檔][9]。

 [1]: https://travis-ci.org/
 [2]: https://github.com/
 [3]: https://golang.org/
 [4]: https://www.docker.com/
 [5]: https://docs.travis-ci.com/user/docker/
 [6]: https://docs.docker.com/compose/
 [7]: https://travis-ci.org/appleboy/golang-testing/jobs/147125401
 [8]: https://www.docker.com/products/docker-engine
 [9]: https://github.com/appleboy/golang-testing/blob/master/.travis.yml