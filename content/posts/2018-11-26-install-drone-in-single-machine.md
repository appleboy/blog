---
title: Drone 支援單機版安裝 (內附影片)
author: appleboy
type: post
date: 2018-11-26T03:43:35+00:00
url: /2018/11/install-drone-in-single-machine/
dsq_thread_id:
  - 7071524788
categories:
  - DevOps
  - Docker
  - Drone CI
tags:
  - devops
  - Docker
  - drone

---
[<img src="https://i0.wp.com/farm5.staticflickr.com/4820/32181752988_0112dca2a5_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2018-11-26 at 11.40.28 AM" data-recalc-dims="1" />][1]

在上週寫了『[Drone 推出 1.0.0 RC1 版本][2]』介紹，裡面提到一個很重要的改變，就是 Drone 現在支援『單機版』安裝了，你會問什麼是單機版安裝？以前不就是可以支援在單台機器把 Drone 給架設起來，那在 1.0.0 RC1 版本指的是什麼意思？在之前的版本，要完整的安裝完成 Drone，需要架設 drone server 及 drone agent，但是在 1.0 版本之後，只需要一個 drone 服務，裡面就內建了 server 及 agent，這很適合用在團隊非常小的狀況底下來快速安裝 drone，假設團隊專案很多，或者是成長很快，建議還是將 server 及 agent 分開架設，未來只需要擴充 agent 即可，底下來看看該如何架設單機版 drone。

<!--more-->

## 影片介紹

直接看 Youtube 影片

## 安裝方式

可以直接參考[官網安裝方式][3]

<pre><code class="language-bash">docker run \
  --volume=/var/run/docker.sock:/var/run/docker.sock \
  --volume=/var/lib/drone:/data \
  --env=DRONE_GITHUB_SERVER=https://github.com \
  --env=DRONE_GITHUB_CLIENT_ID={% your-github-client-id %} \
  --env=DRONE_GITHUB_CLIENT_SECRET={% your-github-client-secret %} \
  --env=DRONE_RUNNER_CAPACITY=2 \
  --env=DRONE_SERVER_HOST={% your-drone-server-host %} \
  --env=DRONE_SERVER_PROTO={% your-drone-server-protocol %} \
  --env=DRONE_TLS_AUTOCERT=true \
  --publish=80:80 \
  --publish=443:443 \
  --restart=always \
  --detach=true \
  --name=drone \
  drone/drone:1.0.0-rc.1</code></pre>

上述是用單行指令就可以架設好 drone，可以注意兩個地方。

  1. 設定 `DRONE_RUNNER_CAPACITY` 為非零值，一次可以執行幾個 JOB
  2. 將 docker socket 掛載到 container 內

如果你喜歡用 docker-compose 請參考底下，或直接到 [GitHub 上面看看][4]

<pre><code class="language-yml">version: &#039;2&#039;

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
      - DRONE_RUNNER_CAPACITY=3
      # GitHub Config
      - DRONE_GITHUB_SERVER=https://github.com
      - DRONE_GITHUB_CLIENT_ID=${DRONE_GITHUB_CLIENT_ID}
      - DRONE_GITHUB_CLIENT_SECRET=${DRONE_GITHUB_CLIENT_SECRET}
      - DRONE_LOGS_PRETTY=true
      - DRONE_LOGS_COLOR=true</code></pre>

## 心得

這次提供單機版我覺得非常棒，對於不懂 server 及 agent 架構的入門新手，可以很快地用單機版安裝完成，減少操作門檻，讓更多開發者可以享受 drone 帶來的好處。已經在使用的朋友們，我就不建議這樣安裝了。更多安裝方式請參考[此 GitHub repo][5]。

 [1]: https://www.flickr.com/photos/appleboy/32181752988/in/dateposted-public/ "Screen Shot 2018-11-26 at 11.40.28 AM"
 [2]: https://blog.wu-boy.com/2018/11/drone-release-1-0-0-rc1/
 [3]: https://docs.drone.io/intro/github/single-machine/
 [4]: https://github.com/go-training/drone-tutorial/blob/307c80ebf8e5e1bc4bb485afa06dd06071f0dcf0/1.0.x/docker-compose.single.yml#L1
 [5]: https://github.com/go-training/drone-tutorial