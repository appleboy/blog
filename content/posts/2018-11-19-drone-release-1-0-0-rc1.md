---
title: 開源專案 Drone 推出 1.0.0 RC1 版本
author: appleboy
type: post
date: 2018-11-19T02:26:03+00:00
url: /2018/11/drone-release-1-0-0-rc1/
dsq_thread_id:
  - 7055862790
categories:
  - DevOps
  - Drone CI
tags:
  - drone
  - Drone.io
  - golang

---
[<img src="https://i2.wp.com/farm5.staticflickr.com/4838/45223480124_b038fd86c1_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2018-11-19 at 10.12.47 AM" data-recalc-dims="1" />][1] 終於看到 [Drone][2] 作者 [bradrydzewski][3] 在 [11/7 號釋出 1.0.0-RC1 版本][4]，此版本尚未開源在 GitHub 上面，所以目前只能透過 docker 方式來安裝。另外如果您正在用 0.8.x 版本的，不建議現在轉換到 1.0 版本，原因有幾點，第一作者尚未公開原始碼，第二現在公開也才一週而已，還有很多 bug 以及用法都沒有在線上 document 寫很清楚，第三就是作者尚未提供工具從 0.8.x 升級到 1.0.0 RC 版本。根據上述的原因，建議大家先不要轉換，當然如果團隊尚未導入 CI/CD 的話，我強烈建議使用 1.0.0 RC-1 版本。底下來看看 1.0.0 RC-1 做了哪些變動？ <!--more-->

## 線上影片

## 新功能 從 

[Release Note][4] 可以看到底下新功能 

  * 支援 Windows. 
  * 支援 ARM. 
  * 支援 ARM64. 
  * 支援 Cron scheduling
  * 支援 multi-machine pipelines
  * 支援 multi-platform pipelines
  * 支援 signed Yaml files
  * 支援 agent affinity
  * 支援 jsonnet configuration 從上面可以看到這次支援了 Windows 及 ARM64 用戶，現在可以很輕易的在 Windows 上面安裝 Drone。再來是支援 Cron scheduling，在 0.8 版本您需要透過 linux cron tab 方式搭配 Drone 才能完成，現在可以直接在 Drone 後台設定 scheduling 了。 

[<img src="https://i1.wp.com/farm5.staticflickr.com/4864/45223480934_c8c2473b3c_z.jpg?w=840&#038;ssl=1" alt="Drone___Continuous_Integration" data-recalc-dims="1" />][5] 

## 支援單機版 Drone 在 1.0.0 RC-1 正式推出單機版本，什麼是單機版本呢？在此版本之前，都是需要一台 drone server 搭配多個 drone agent。現在不用將 drone agent 分開安裝了，可以透過一個指令將 server 跟 agent 跑在同一個服務內: 

[程式碼參考][6] 

<pre class="brush: plain; title: ; notranslate" title="">version: '2'

services:
  drone-server:
    image: drone/drone:1.0.0-rc.1
    ports:
      - 8081:80
    volumes:
      - ./:/data
      - /var/run/docker.sock:/var/run/docker.sock
    restart: always
    environment:
      - DRONE_SERVER_HOST=${DRONE_SERVER_HOST}
      - DRONE_SERVER_PROTO=${DRONE_SERVER_PROTO}
      - DRONE_TLS_AUTOCERT=false
      - DRONE_RPC_SECRET=${DRONE_RPC_SECRET}
      - DRONE_RUNNER_CAPACITY=3
      # GitHub Config
      - DRONE_GITHUB_SERVER=https://github.com
      - DRONE_GITHUB_CLIENT_ID=${DRONE_GITHUB_CLIENT_ID}
      - DRONE_GITHUB_CLIENT_SECRET=${DRONE_GITHUB_CLIENT_SECRET}
      - DRONE_LOGS_PRETTY=true
      - DRONE_LOGS_COLOR=true
</pre>

## Multi-Machine, Multi-Architecture, Multi-Cloud 現在同時支援了 AMD64, ARM64 及 Windows，那該如何同時測試多種平台，可以透過底下 YAML 語法就可以完成 

<pre class="brush: plain; title: ; notranslate" title="">kind: pipeline
name: backend

platform:
  arch: arm
  os: linux

steps:
- name: build
  image: golang
  commands:
  - go build
  - go test

---
kind: pipeline
name: frontend

platform:
  arch: amd64
  os: linux

steps:
- name: build
  image: node
  commands:
  - npm install
  - npm test

depends_on:
- backend
</pre>

## 擴充 YAML 語法變通性 Drone 現在也支援了 

[Jsonnet][7] 來擴充 YAML 語法，讓開發者可以使用變數或 Function 方式來擴充及管理 .drone.yml 語法，底下舉個簡單的例子: 

<pre class="brush: plain; title: ; notranslate" title="">local Pipeline(arch) = {
  kind: "pipeline",
  name: arch,
  steps: [
    {
      name: "build",
      image: "golang",
      commands: [
        "go build",
        "go test",
      ]
    }
  ]
};

[
  Pipeline("amd64"),
  Pipeline("arm64"),
  Pipeline("arm"),
]
</pre> 上面的 Jsonnet 可以幫忙轉換成底下 YAML 

<pre class="brush: plain; title: ; notranslate" title="">---
kind: pipeline
name: amd64

platform:
  os: linux
  arch: amd64

steps:
- name: build
  image: golang
  commands:
  - go build
  - go test

---
kind: pipeline
name: arm64

platform:
  os: linux
  arch: amd64

steps:
- name: build
  image: golang
  commands:
  - go build
  - go test

---
kind: pipeline
name: arm

platform:
  os: linux
  arch: amd64

steps:
- name: build
  image: golang
  commands:
  - go build
  - go test

...
</pre>

## 心得 未來會有更多技巧會介紹給大家，現在 Udemy 影片上面都是 0.8.x 語法，但是觀念跟寫法大同小異，我也會錄製 1.0.0 版本的 Drone 教學放在 Udemy 上面。如果有興趣可以點選此

[購買連結][8]。

 [1]: https://www.flickr.com/photos/appleboy/45223480124/in/dateposted-public/ "Screen Shot 2018-11-19 at 10.12.47 AM"
 [2]: https://github.com/drone/drone
 [3]: https://twitter.com/bradrydzewski
 [4]: https://blog.drone.io/drone-1-release-candidate-1/
 [5]: https://www.flickr.com/photos/appleboy/45223480934/in/dateposted-public/ "Drone___Continuous_Integration"
 [6]: https://github.com/go-training/drone-tutorial/blob/b3b2d55c78dfc2f2d9b86fcca97afba2d9ae4612/1.0.x/docker-compose.single.yml
 [7]: https://jsonnet.org/
 [8]: https://www.udemy.com/devops-oneday/?couponCode=DRONE-DEVOPS