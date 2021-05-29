---
title: '[Go 教學] graceful shutdown 搭配 docker-compose 實現 rolling update'
author: appleboy
type: post
date: 2020-02-08T14:50:33+00:00
url: /2020/02/graceful-shutdown-using-docker-compose-with-rolling-update/
dsq_thread_id:
  - 7860163643
categories:
  - Docker
  - Golang
tags:
  - Docker
  - Docker compose
  - golang

---
> 線上課程:『[Go 語言實戰][1]』目前特價 **$2100 TWD**，優惠代碼『**202003**』，也可以直接匯款（價格再減 **100**），如果想搭配另外兩門課程合購可以透過 [FB 聯絡我][2]

[![golang logo][3]][3]

上一篇作者有提到『[什麼是 graceful shutdown?][4]』，本篇透過 docker-compose 方式來驗證 [Go 語言][5]的 graceful shutdown 是否可以正常運作。除了驗證之外，單機版 [Docker][6] 本身就可以設定 scale 容器數量，那這時候又該如何搭配 graceful shutdown 來實現 rolling update 呢？相信大家對於 rolling update 並不陌生，現在的 [kubernetes][7] 已經有實現這個功能，用簡單的指令就可以達到此需求，但是對於沒有在用 k8s 架構的開發者，可能網站也不大，那該如何透過單機本的 docker 來實現呢？底下先來看看為什麼會出現這樣的需求。

<!--more-->

假設您有一個 App 服務，需要在單機版上面透過 docker-compose 同時啟動兩個容器，可以透過底下指令一次完成：

<pre><code class="language-shell=">docker-compose up -d --scale app=2</code></pre>

其中 `app` 就是在 YAML 裡面的服務名稱。這時候可以看到背景就跑了兩個容器，接著要升級 App 服務，您會發現在下一次上述指令，可以看到 docker 會先把兩個容器先停止，但是容器被停止前會透過 graceful shutdown 確認背景的服務或工作需要完成結束，才可以正確停止容器並且移除，最後再啟動新的 App 容器。這時候你會發現 App 服務被終止了幾分鐘時間完全無法運作。底下來介紹該如何解決此問題，以及驗證 graceful shutdown 是否可以正常運作

## 教學影片

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][8]
  * [一天學會 DevOps 自動化測試及部署][9]
  * [DOCKER 容器開發部署實戰][10] (課程剛啟動，限時特價 $800 TWD)

## graceful shutdown 範例

先簡單寫個 Go 範例:

<pre><code class="language-go">package main

import (
    "context"
    "flag"
    "log"
    "net/http"
    "os"
    "os/signal"
    "syscall"
    "time"
)

var (
    listenAddr string
)

func main() {
    flag.StringVar(&listenAddr, "listen-addr", ":8080", "server listen address")
    flag.Parse()

    logger := log.New(os.Stdout, "http: ", log.LstdFlags)

    router := http.NewServeMux() // here you could also go with third party packages to create a router
    // Register your routes
    router.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        time.Sleep(15 * time.Second)
        w.WriteHeader(http.StatusOK)
    })

    router.HandleFunc("/ping", func(w http.ResponseWriter, r *http.Request) {
        time.Sleep(10 * time.Second)
        w.WriteHeader(http.StatusOK)
    })

    server := &http.Server{
        Addr:         listenAddr,
        Handler:      router,
        ErrorLog:     logger,
        ReadTimeout:  30 * time.Second,
        WriteTimeout: 30 * time.Second,
        IdleTimeout:  30 * time.Second,
    }

    done := make(chan bool, 1)
    quit := make(chan os.Signal, 1)

    signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)

    go func() {
        &lt;-quit
        logger.Println("Server is shutting down...")

        ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
        defer cancel()

        if err := server.Shutdown(ctx); err != nil {
            logger.Fatalf("Could not gracefully shutdown the server: %v\n", err)
        }
        close(done)
    }()

    logger.Println("Server is ready to handle requests at", listenAddr)
    if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
        logger.Fatalf("Could not listen on %s: %v\n", listenAddr, err)
    }

    &lt;-done
    logger.Println("Server stopped")
}</code></pre>

上面程式可以知道，直接打 `/` 就會等待 15 秒後才能拿到回應

<pre><code class="language-shell=">curl -v -H Host:app.docker.localhost http://127.0.0.1:8088</code></pre>

## 準備 docker 環境

準備 dockerfile 

<pre><code class="language-dockerfile="># build stage
FROM golang:alpine AS build-env
ADD . /src
RUN cd /src && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app

# final stage
FROM centurylink/ca-certs
COPY --from=build-env /src/app /

EXPOSE 8080

ENTRYPOINT ["/app"]</code></pre>

準備 docker-compose.yml，使用 [Traefik][11] v2 版本來做 Load balancer。

<pre><code class="language-yaml">version: &#039;3&#039;

services:
  app:
    image: go-training/app
    restart: always
    logging:
      options:
        max-size: "100k"
        max-file: "3"
    labels:
      - "traefik.http.routers.app.rule=Host(`app.docker.localhost`)"

  reverse-proxy:
    # The official v2.0 Traefik docker image
    image: traefik:v2.0
    # Enables the web UI and tells Traefik to listen to docker
    command: --api.insecure=true --providers.docker
    ports:
      # The HTTP port
      - "8088:80"
      # The Web UI (enabled by --api.insecure=true)
      - "8080:8080"
    volumes:
      # So that Traefik can listen to the Docker events
      - /var/run/docker.sock:/var/run/docker.sock</code></pre>

可以看到 `8088` port 會是入口，`app.docker.localhost` 會是 app 網域名稱。

## 驗證 graceful shutdown

啟動全部服務，App 及 Traefik 都有被正式啟動

<pre><code class="language-shell=">docker-compose up -d --scale app=2</code></pre>

接下來先修改原本的 Go 範例，在編譯一次把 Image 先產生好。另外開兩個 console 頁面直接下

<pre><code class="language-shell=">curl -v -H Host:app.docker.localhost http://127.0.0.1:8088</code></pre>

會發現 curl 會等待 15 秒才能拿到回應，這時候直接下

<pre><code class="language-shell=">docker-compose up -d --scale app=2</code></pre>

就可以看到

<pre><code class="language-shell=">app_2   | http: 2020/02/08 14:06:20 Server is shutting down... 
app_2   | http: 2020/02/08 14:06:20 Server stopped
app_1   | http: 2020/02/08 14:06:20 Server is shutting down...
app_1   | http: 2020/02/08 14:06:20 Server stopped</code></pre>

這代表 graceful shutdown 可以正常運作，確保 app 連線及後續處理的動作可以正常被執行。

## 用 docker-compose 執行 rolling update

從上面可以看到，當執行了

<pre><code class="language-shell=">docker-compose up -d --scale app=2</code></pre>

docker 會把目前的容器都全部停止，假設這時候都有重要的工作需要繼續執行，但是 graceful shutdown 已經將連接埠停止，造成使用者已經無法連線，這問題該如何解決呢？其實不難，只需要修正幾個指令就可以做到。由於 `docker-compose up -d` 會先將所有容器先停止，造成無法連線，這時候需要使用 `--no-recreate` flag 來避免這問題

<pre><code class="language-shell=">docker-compose up -d --scale app=3 --no-recreate</code></pre>

將數量 + 1 的意思就是先啟動一個新的容器用來接受新的連線，接著將舊的容器移除:

<pre><code class="language-shell=">docker stop -t 30 \
  $(docker ps --format "table {{.ID}} {{.Names}} {{.CreatedAt}}" | \
  grep app | \
  awk -F  " " &#039;{print $1 " " $3 "T" $4}&#039; ｜\
  sort -k2 | \
  awk -F  "  " &#039;{print $1}&#039; | head -2)</code></pre>

其中 `-t 30` 一定要設定，預設會是 10 秒相當短，也就是 10 秒容器沒結束就自動 kill 了，後面的 `head -2` 代表移除舊的容器，原本是開兩台，就需要停止兩台。接著將已經停止的容器砍掉:

<pre><code class="language-shell=">docker container prune -f</code></pre>

現在正在執行的容器只剩下一台，故還需要透過 scale 將不足的容器補上:

<pre><code class="language-shell=">docker-compose up -d --scale app=2 --no-recreate</code></pre>

完成上述步驟後，就可以確保服務不會中斷。如果有更好的解法歡迎大家提供。

 [1]: https://www.udemy.com/course/golang-fight/?couponCode=202002 "Docker 容器實用實戰"
 [2]: http://facebook.com/appleboy46
 [3]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [4]: https://blog.wu-boy.com/2020/02/what-is-graceful-shutdown-in-golang/
 [5]: https://golang.org
 [6]: https://docker.com
 [7]: https://kubernetes.io/
 [8]: https://www.udemy.com/course/golang-fight/?couponCode=202003
 [9]: https://www.udemy.com/course/devops-oneday/?couponCode=202003
 [10]: https://www.udemy.com/course/docker-practice/?couponCode=20200222
 [11]: https://containo.us/traefik/