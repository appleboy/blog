---
title: 10 分鐘內用 Traefik 架設 Drone 搭配 GitHub 服務
author: appleboy
type: post
date: 2019-03-22T06:12:41+00:00
url: /2019/03/setup-traefik-with-drone-ci-cd-in-ten-minutes/
dsq_thread_id:
  - 7310584380
categories:
  - DevOps
  - Docker
  - Drone CI
tags:
  - Docker
  - drone
  - traefik

---
[![][1]][1]

這標題也許有點誇張，但是如果實際操作一次，肯定可以在 10 分鐘內操作完成。本篇來教大家如何用 [Traefik][2] 當作前端 Proxy，後端搭配 [Drone][3] 服務接 [GitHub][4]，為什麼會用 Traefik，原因很簡單，你可以把 Traefik 角色想成是 [Nginx][5]，但是又比 Nginx 更簡單設定，另外一點就是，Traefik 自動整合了 [Let's Encrypt][6] 服務，您就不用擔心憑證會過期的問題。假如機器只會有一個 Drone 當 Host 的話，其實也可以不使用 Traefik，因為 Drone 其實也是內建自動更新憑證的功能。如果您對 Traefik 有興趣，可以直接參考底下兩篇文章

  * [用 Traefik 搭配 Docker 快速架設服務][7] (內附教學影片)
  * [Traefik 搭配 Docker 自動更新 Let’s Encrypt 憑證][8] (內附教學影片)

<!--more-->

## 教學影片

  * 00:37 架設 Traefik 服務 Listen 80 及 443 port
  * 02:42 用 Docker 架設 Drone 並且透過 Label 跟 Traefik 串接
  * 04:11 在 GitHub 申請 App Client ID 及 Secret

更多實戰影片可以參考我的 Udemy 教學系列

  * Go 語言實戰課程: <http://bit.ly/golang-2019> 
  * Drone CI/CD 自動化課程: <http://bit.ly/drone-2019>

## 設定單一 Drone 服務

為什麼說是單一 Drone 服務呢，原因是在 Drone 1.0 開始支援在單一容器內就可以跑 server 跟 agent 同時啟動，降低大家入門門檻，本篇就是以單一容器來介紹，當然如果團隊比較大，建議還是把 server 跟 agent 拆開會比較適合。先建立 `docker-compose.yml`，相關代碼都可以在這邊[找到][9]。

<pre><code class="language-yaml">version: '2'

services:
  drone-server:
    image: drone/drone:1.0.0
    volumes:
      - ./:/data
      - /var/run/docker.sock:/var/run/docker.sock
    restart: always
    environment:
      - DRONE_SERVER_HOST=${DRONE_SERVER_HOST}
      - DRONE_SERVER_PROTO=${DRONE_SERVER_PROTO}
      - DRONE_TLS_AUTOCERT=false
      - DRONE_RUNNER_CAPACITY=3
      # GitHub Config
      - DRONE_GITHUB_SERVER=https://github.com
      - DRONE_GITHUB_CLIENT_ID=${DRONE_GITHUB_CLIENT_ID}
      - DRONE_GITHUB_CLIENT_SECRET=${DRONE_GITHUB_CLIENT_SECRET}
      - DRONE_LOGS_PRETTY=true
      - DRONE_LOGS_COLOR=true
    networks:
      - web
    logging:
      options:
        max-size: "100k"
        max-file: "3"
    labels:
      - "traefik.docker.network=web"
      - "traefik.enable=true"
      - "traefik.basic.frontend.rule=Host:${DRONE_SERVER_HOST}"
      - "traefik.basic.port=80"
      - "traefik.basic.protocol=http"

networks:
  web:
    external: true</code></pre>

接著建立 `.env`，並且寫入底下資料

<pre><code class="language-sh">DRONE_SERVER_HOST=
DRONE_SERVER_PROTO=
DRONE_GITHUB_CLIENT_ID=
DRONE_GITHUB_CLIENT_SECRET=</code></pre>

其中 proto 預設是跑 http，這邊不用動，traefik 會自動接上 container port，drone 預設跑在 80 port，這邊跟前一版的 drone 有些差異，請在 `traefik.basic.port` 設定 `80` 喔，接著跑 `docker-compose up`

<pre><code class="language-sh">$ docker-compose up
drone-server_1  | {
drone-server_1  |   "acme": false,
drone-server_1  |   "host": "drone.ggz.tw",
drone-server_1  |   "level": "info",
drone-server_1  |   "msg": "starting the http server",
drone-server_1  |   "port": ":80",
drone-server_1  |   "proto": "http",
drone-server_1  |   "time": "2019-03-21T17:13:32Z",
drone-server_1  |   "url": "http://drone.ggz.tw"
drone-server_1  | }</code></pre>

如果看到上面的訊息，代表已經架設完成。先假設各位已經都先安裝好 traefik，透過 docker label，traefik 會自動將流量 proxy 到對應的 container。

## 心得

這是我玩過最簡單的 CI/CD 開源專案，設定相當容易，作者花了很多心思在這上面。另外我會在四月北上參加『[CI / CD 大亂鬥][10]』擔任 Drone 的代表，希望可以在現場多認識一些朋友，如果對 Drone 有任何疑問，隨時歡迎找我，或直接到現場交流。

 [1]: https://lh3.googleusercontent.com/HIVQn1cNncIZ8EdJ7P-Nc9ohmuoSgGfnhB0Nfjl3fxsSoZ_RUBrz0yPB73EQy2Plc5NB1919QKsU7gwioFV0A9f-kD46qFovSkeJBO64iKPnTxZ860YGjdhRDMxseJ67OjSVSsEoskY=w2400
 [2]: https://traefik.io/
 [3]: https://github.com/drone/drone
 [4]: https://github.com
 [5]: https://www.nginx.com/
 [6]: https://letsencrypt.org/
 [7]: https://blog.wu-boy.com/2019/01/deploy-service-using-traefik-and-docker/
 [8]: https://blog.wu-boy.com/2019/01/traefik-docker-and-lets-encrypt/
 [9]: https://github.com/go-training/drone-tutorial
 [10]: https://battle.devopstw.club/