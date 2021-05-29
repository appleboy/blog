---
title: 用 10 分鐘安裝好 Drone 搭配 GitLab
author: appleboy
type: post
date: 2019-08-23T01:05:48+00:00
url: /2019/08/install-drone-with-gitlab-in-10-minutes/
dsq_thread_id:
  - 7600809731
categories:
  - DevOps
  - Docker
  - Drone CI
tags:
  - drone
  - droneci
  - GitLab

---
[![Drone+GitLab][1]][1]

如果你沒在使用 [GitLab CI][2]，那可以來嘗試看看 [Drone CI/CD][3]，用不到 10 分鐘就可以快速架設好 Drone，並且上傳一個 `.drone.yml` 並且開啟第一個部署或測試流程，安裝步驟非常簡單，只需要對 [Docker][4] 有基本上的了解，通常都可以在短時間完成 Drone CI/CD 架設。

<!--more-->

## 教學影片

更多實戰影片可以參考我的 Udemy 教學系列

  * Go 語言實戰課程: <http://bit.ly/golang-2019>
  * Drone CI/CD 自動化課程: <http://bit.ly/drone-2019>

## 安裝 Drone Server

用 docker-compose 可以快速設定 Drone Server

```yaml
services:
  drone-server:
    image: drone/drone:1
    ports:
      - 8081:80
    volumes:
      - ./:/data
    restart: always
    environment:
      - DRONE_SERVER_HOST=${DRONE_SERVER_HOST}
      - DRONE_SERVER_PROTO=${DRONE_SERVER_PROTO}
      - DRONE_RPC_SECRET=${DRONE_RPC_SECRET}
      - DRONE_AGENTS_ENABLED=true
      # Gitlab Config
      - DRONE_GITLAB_SERVER=https://gitlab.com
      - DRONE_GITLAB_CLIENT_ID=${DRONE_GITLAB_CLIENT_ID}
      - DRONE_GITLAB_CLIENT_SECRET=${DRONE_GITLAB_CLIENT_SECRET}
      - DRONE_LOGS_PRETTY=true
      - DRONE_LOGS_COLOR=true
```

只要在 `docker-compose.yml` 底下新增 `.env` 檔案，將上面的變數值填寫進去即可

## 安裝 Drone Agent

雖然 drone 在 1.0 提供單機版，也就是 server 跟 agent 可以裝在同一台，但是本篇教學還是以分開安裝為主，對未來擴充性會更好。

```yaml
  drone-agent:
    image: drone/agent:1
    restart: always
    depends_on:
      - drone-server
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - DRONE_RPC_SERVER=http://drone-server
      - DRONE_RPC_SECRET=${DRONE_RPC_SECRET}
      - DRONE_RUNNER_CAPACITY=3
```

完整的設定檔可以[參考這邊][5]。

 [1]: https://lh3.googleusercontent.com/UBBk430Fl5KSAbDHuu0gyb6VXrjdGM5aj9JV7LqyFbubYDYuUu3KfahdarNJn0SHyEUCN_lWXfhb2BsNxjgD--kFt-MRkDguj1pWRNEpgiTL_zaVn9BDJPmm7wkIFmv0oEm6pt0NHkY=w1920-h1080 "Drone+GitLab"
 [2]: https://about.gitlab.com/product/continuous-integration/
 [3]: https://drone.io/
 [4]: https://docker.com
 [5]: https://github.com/go-training/drone-tutorial/blob/7f152ef7074ace3831002dda2217473b2b400b9f/1.x/docker-compose.gitlab.yml#L1