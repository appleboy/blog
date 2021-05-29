---
title: 用 Traefik 搭配 Docker 快速架設服務
author: appleboy
type: post
date: 2019-01-08T03:51:43+00:00
url: /2019/01/deploy-service-using-traefik-and-docker/
dsq_thread_id:
  - 7153822956
categories:
  - DevOps
  - Docker
  - Drone CI
  - Golang
tags:
  - Docker
  - drone
  - droneci
  - golang
  - traefik

---
**更新: 2019.01.10 新增教學影片**

[![drone traefik docker deploy][1]][1]

相信大家在架設服務肯定會選一套像是 [HAProxy][2], [Nginx][3], [Apache][4] 或 [Caddy][5]，這四套架設的難度差不多，如果要搭配 [Let's Encrypt][6] 前面兩套需要自己串接 (Nginx, Apache)，而 Caddy 是用 [Golang][7] 開發裡面已經內建了 Let's Encrypt，，管理者不用擔心憑證過期，相當方便。但是本篇我要介紹另外一套工具叫 [Traefik][8]，這一套也是用 Go 語言開發，而我推薦這套的原因是，此套可以跟 Docker 很深度的結合，只要服務跑在 Docker 上面，Traefik 都可以自動偵測到，並且套用設定。透過底下的範例讓 Traefik 串接後端兩個服務，分別是 `domain1.com` 及 `domain2.com`。來看看如何快速設定 Traefik。

[![traefik + docker + golang][9]][9]

<!--more-->

## 影片教學

不想看內文的，可以直接參考 Youtube 影片，如果喜歡的話歡迎訂閱

## 撰寫服務

我們先透過底下 Go 語言實作後端，並且放到 [Docker Hub][10] 內，方便之後透過 [docker-compose][11] 設定。

<pre><code class="language-go">package main

import (
    "flag"
    "fmt"
    "log"
    "net/http"
    "os"
    "time"
)

// HelloWorld for hello world
func HelloWorld() string {
    return "Hello World, golang workshop!"
}

func handler(w http.ResponseWriter, r *http.Request) {
    log.Printf("Got http request. time: %v", time.Now())
    fmt.Fprintf(w, "I love %s!", r.URL.Path[1:])
}

func pinger(port string) error {
    resp, err := http.Get("http://localhost:" + port)
    if err != nil {
        return err
    }
    defer resp.Body.Close()
    if resp.StatusCode != 200 {
        return fmt.Errorf("server returned not-200 status code")
    }

    return nil
}

func main() {
    var port string
    var ping bool
    flag.StringVar(&port, "port", "8080", "server port")
    flag.StringVar(&port, "p", "8080", "server port")
    flag.BoolVar(&ping, "ping", false, "check server live")
    flag.Parse()

    if p, ok := os.LookupEnv("PORT"); ok {
        port = p
    }

    if ping {
        if err := pinger(port); err != nil {
            log.Printf("ping server error: %v\n", err)
        }

        return
    }

    http.HandleFunc("/", handler)
    log.Println("http server run on " + port + " port")
    log.Fatal(http.ListenAndServe(":"+port, nil))
}</code></pre>

撰寫 Dockerfile

<pre><code class="language-yaml">FROM alpine:3.8

LABEL maintainer="Bo-Yi Wu &lt;appleboy.tw@gmail.com&gt;" \
  org.label-schema.name="Drone Workshop" \
  org.label-schema.vendor="Bo-Yi Wu" \
  org.label-schema.schema-version="1.0"

RUN apk add --no-cache ca-certificates && \
  rm -rf /var/cache/apk/*

ADD release/linux/i386/helloworld /bin/

ENTRYPOINT ["/bin/helloworld"]</code></pre>

設定 [Drone][12] 自動上傳到 DockerHub，使用 [drone-docker][13] 外掛。

<pre><code class="language-yaml">  - name: publish
    image: plugins/docker:17.12
    settings:
      repo: appleboy/test
      auto_tag: true
      dockerfile: Dockerfile.alpine
      default_suffix: alpine
      username:
        from_secret: docker_username
      password:
        from_secret: docker_password
    when:
      event:
        - push
        - tag</code></pre>

其中 `docker_username` 及 `docker_password` 可以到 drone 後台設定。

## 啟動 Traefik 服務

如果只是單純綁定在非 80 或 443 port，您可以用一般帳號設定 Traefik，設定如下:

<pre><code class="language-toml">debug = false

logLevel = "INFO"
defaultEntryPoints = ["http"]

[entryPoints]
  [entryPoints.http]
  address = ":8080"

[retry]

################################################################
# Docker Provider
################################################################

# Enable Docker Provider.
[docker]

# Docker server endpoint. Can be a tcp or a unix socket endpoint.
#
# Required
#
endpoint = "unix:///var/run/docker.sock"

# Enable watch docker changes.
#
# Optional
#
watch = true</code></pre>

上面設定可以看到將 Traefik 啟動在 `8080` port，並且啟動 Docker Provider，讓 Traefik 可以自動偵測目前 Docker 啟動了哪些服務。底下是啟動 Traefik 的 docker-compose 檔案

<pre><code class="language-yaml">version: '2'

services:
  traefik:
    image: traefik
    restart: always
    ports:
      - 8080:8080
      # - 80:80
      # - 443:443
    networks:
      - web
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./traefik.toml:/traefik.toml
      # - ./acme.json:/acme.json
    container_name: traefik

networks:
  web:
    external: true</code></pre>

啟動 Traefik 環境前需要建立虛擬網路名叫 web

<pre><code class="language-bash">$ docker network create web
$ docker-compose up -d</code></pre>

## 啟動 App 服務

接著只要透過 docker-compose 來啟動您的服務

<pre><code class="language-yaml">version: '3'

services:
  app_1:
    image: appleboy/test:alpine
    restart: always
    networks:
      - web
    logging:
      options:
        max-size: "100k"
        max-file: "3"
    labels:
      - "traefik.docker.network=web"
      - "traefik.enable=true"
      - "traefik.basic.frontend.rule=Host:domain1.com"
      - "traefik.basic.port=8080"
      - "traefik.basic.protocol=http"

  app_2:
    image: appleboy/test:alpine
    restart: always
    networks:
      - web
    logging:
      options:
        max-size: "100k"
        max-file: "3"
    labels:
      - "traefik.docker.network=web"
      - "traefik.enable=true"
      - "traefik.basic.frontend.rule=Host:domain2.com"
      - "traefik.basic.port=8080"
      - "traefik.basic.protocol=http"

networks:
  web:
    external: true</code></pre>

大家可以清楚看到透過設定 docker label 可以讓 Traefik 自動偵測到系統服務

<pre><code class="language-yaml">    labels:
      - "traefik.docker.network=web"
      - "traefik.enable=true"
      - "traefik.basic.frontend.rule=Host:domain2.com"
      - "traefik.basic.port=8080"
      - "traefik.basic.protocol=http"</code></pre>

其中 `traefik.basic.frontend.rule` 可以填入網站 DNS Name，另外 `traefik.basic.port=8080` 則是服務預設啟動的 port (在 Go 語言內實作)。

驗證網站是否成功

<pre><code class="language-bash">$ curl -v http://domain1.com:8080/test
$ curl -v http://domain2.com:8080/test</code></pre>

[![bash screen][14]][14]

## 搭配 Let's Encrypt

這邊又要感謝 Go 語言內建 Let's Encrypt 套件，讓 Go 開發者可以快速整合憑證，這邊只需要修正 Traefik 服務設定檔

<pre><code class="language-toml">logLevel = "INFO"
defaultEntryPoints = ["https","http"]

[entryPoints]
  [entryPoints.http]
  address = ":80"
    [entryPoints.http.redirect]
    entryPoint = "https"
  [entryPoints.https]
  address = ":443"
  [entryPoints.https.tls]

[retry]

[docker]
endpoint = "unix:///var/run/docker.sock"
watch = true
exposedByDefault = false

[acme]
email = "appleboy.tw@gmail.com"
storage = "acme.json"
entryPoint = "https"
onHostRule = true
[acme.httpChallenge]
entryPoint = "http"</code></pre>

跟之前 Traefik 比較多了 `entryPoints` 及 `acme`，另外在 docker-compose 內要把 80 及 443 port 啟動，並且將 acme.json 掛載進去

<pre><code class="language-yaml">version: '2'

services:
  traefik:
    image: traefik
    restart: always
    ports:
      - 80:80
      - 443:443
    networks:
      - web
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./traefik.toml:/traefik.toml
      - ./acme.json:/acme.json
    container_name: traefik

networks:
  web:
    external: true</code></pre>

其中先建立 `acme.json` 並且設定權限為 600

<pre><code class="language-bash">$ touch acme.json
$ chmod 600 acme.json</code></pre>

再重新啟動 Traefik 服務

<pre><code class="language-bash">$ docker-compose down
$ docker-compose up -d</code></pre>

最後只要改 `traefik.basic.frontend.rule` 換成真實的 Domain，你會發現 Traefik 會將憑證內容寫入 acme.json。這也為什麼我們需要將 acme.json 建立在 Host 空間上。

## 搭配 Drone 自動化更新服務

未來所有服務都可以透過 docker-compose 來啟動，所以只要透過 Drone 將 一些 yaml 設定檔案傳到服務器即可

<pre><code class="language-yaml">  - name: scp
    image: appleboy/drone-scp
    pull: true
    settings:
      host: demo1.com
      username: deploy
      key:
        from_secret: deploy_key
      target: /home/deploy/gobento
      rm: true
      source:
        - release/*
        - Dockerfile
        - docker-compose.yml</code></pre>

上面將檔案丟到遠端機器後，再透過 ssh 編譯並且部署

<pre><code class="language-yaml">  - name: ssh
    image: appleboy/drone-ssh
    pull: true
    settings:
      host: console.gobento.co
      user: deploy
      key:
        from_secret: deploy_key
      target: /home/deploy/demo
      rm: true
      script:
        - cd demo && docker-compose build
        - docker-compose up -d --force-recreate --no-deps demo
        - docker images --quiet --filter=dangling=true | xargs --no-run-if-empty docker rmi -f</code></pre>

## 心得

本篇教大家一步一步建立 Traefik 搭配 Docker，相對於 Nginx 我覺得簡單非常多，尤其時可以在 docker-compose 內設定 docker Label，而 Traefik 會自動偵測設定，並且重新啟動服務。希望這篇對於想要快速架設網站的開發者有幫助。如果您有在用 [AWS 服務][15]，想省錢可以使用 Traefik 幫您省下一台 [ALB 或 ELB][16] 的費用。最後補充一篇效能文章：『[NGINX、HAProxy和Traefik负载均衡能力对比][17]』有興趣可以參考一下。

 [1]: https://lh3.googleusercontent.com/TAK3Xi-hQKY1RCRGFLWmUGwdhP8UdI5mrWDyV5rQstQaQMDa27Fp0JOX2lezArNrZEdX227TyajH9wmVO3geDSFGQH9QBU4MANFSCBmPnlL2_eEehszF2tPhm1NNv1xYiCgiSM6air8=w1920-h1080 "drone traefik docker deploy"
 [2]: http://www.haproxy.org/
 [3]: https://www.nginx.com/ "Nginx"
 [4]: https://httpd.apache.org/ "Apache"
 [5]: https://caddyserver.com/ "Caddy"
 [6]: https://letsencrypt.org/ "Let's Encrypt"
 [7]: https://golang.org/ "Golang"
 [8]: https://traefik.io/ "Traefik"
 [9]: https://lh3.googleusercontent.com/e4VvNhQLdG0agSrE3EbxYURmbZevK8kVUaBhvHE3FVg_9iCRFeDFdFo9PHEm9EGPkYX2Q-ZmdcwyJhsDRbPi0HdZIN1HRjdkgFI8mWrbVWPLscPKI2WxCDIlSkCzB2zoh6pay-3R2Xg=w1920-h1080 "traefik + docker + golang"
 [10]: https://hub.docker.com "Docker Hub"
 [11]: https://docs.docker.com/compose/ "docker-compose"
 [12]: http://cloud.drone.io "Drone"
 [13]: https://github.com/drone/drone-docker "drone-docker"
 [14]: https://lh3.googleusercontent.com/8RGL4EBCr8LDqhjc0y5l0o4UYTBbRY-CLbd_RKJl_PPbjr2LkgEYAc7Y7WuFxjXWKXC9OMZVi1jSV1JL18pAdRGG7PGwOi1UssZN0a-BqURPDSIZlU0X9EUlbMp7X2u_Y0qYY9DHtYw=w1920-h1080 "bash screen"
 [15]: https://aws.amazon.com/tw/ "AWS 服務"
 [16]: https://aws.amazon.com/tw/elasticloadbalancing/ "ALB 或 ELB"
 [17]: https://zhuanlan.zhihu.com/p/41354937 "NGINX、HAProxy和Traefik负载均衡能力对比"