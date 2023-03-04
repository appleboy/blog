---
title: "自動升級更新執行中的 Docker 容器解決方案 - watchtower"
date: 2023-02-28T08:44:19+08:00
author: appleboy
type: post
slug: automating-docker-container-base-image-updates-cht
share_img: https://i.imgur.com/sPCVa57.png
categories:
  - Golang
  - Watchtower
  - Docker
---

![CI](https://i.imgur.com/XbonwAZ.png)

現在大家在部署服務肯定都已經容器化，而如何有效管理及升級容器不影響現有的服務，這就是一個重要的議題，然而在 [CI/CD 的流程](https://zh.wikipedia.org/zh-tw/CI/CD)內，肯定有兩個步驟是必須的，第一就是將環境打包成 Docker Image 並上傳到公司內私有的 [Docker Registry](https://docs.docker.com/registry/)，以及上傳完畢後，也許透過 SSH 方式連上機器，並且拉取新的映像檔，再透過 Graceful Shutdown 機制重新啟動正在執行的服務。可以參考這篇了解什麼是 [Graceful Shutdown](https://blog.wu-boy.com/2020/02/what-is-graceful-shutdown-in-golang/)。本篇就是要帶給大家一個全新的工具 [Watchtower](https://containrrr.dev/watchtower) 用來自動升級更新執行中的容器，讓 CD 流程可以再簡化一步，開發者只要上傳完 Docker Image，遠方的伺服器就可以自動更新。

<!--more-->

架構圖就會變成底下

![CI](https://i.imgur.com/sPCVa57.png)

## 教學影片

{{< youtube u-ge5V6CN6w >}}

```sh
00:00 傳統 CI/CD 流程步驟
01:30 改善後 CI/CD 流程
02:45 什麼是 Watchtower
03:47 使用方式
10:00 使用心得
```

其他線上課程請參考如下

* [Docker 容器實戰](https://blog.wu-boy.com/docker-course/)
* [Go 語言課程](https://blog.wu-boy.com/golang-online-course/)

## 什麼是 Watchtower

Watchtower 是一個用 [Go 語言](https://go.dev)開發的應用程序，它會監視正在運行的 Docker 容器，並觀察這些容器最初啟動時所使用的映像檔 (Docker Image) 是否有更改。如果 watchtower 檢測到映像檔已更改，它將自動使用新映像檔重新啟動容器。

透過 watchtower，開發者可以通過將新的映像檔推送到 Docker Hub 或您自己的 Docker Registry，簡單地更新容器化應用程序的運行版本。Watchtower 將下載您的新映像，優雅地關閉現有容器，然後使用最初部署時使用的相同選項重新啟動它。

例如，假設您正在運行 watchtower 以及一個名為 `ghcr.io/go-training/example53` 的映像實例：

每隔幾分鐘，watchtower 將下載最新的 `ghcr.io/go-training/example53` 映像檔並將其與用於運行 "example53" 容器的映像進行比較。如果它發現映像檔已更改，它將停止/刪除 "example53" 容器，然後使用新映像和最初啟動容器時使用的相同 docker run 選項重新啟動它。

## 使用方式

Watchtower 本身被打包成 Docker 容器，因此安裝非常簡單，只需拉取 containrrr/watchtower 映像即可。如果您正在使用基於 ARM 的架構，請從 Docker Hub 拉取適當的 `containrrr/watchtower:armhf-tag` 映像。

由於 watchtower 代碼需要與 Docker API 進行交互以監視運行的容器，因此在運行容器時需要使用 -v 標誌將 /var/run/docker.sock 挂載到容器中。

使用以下命令運行 watchtower 容器：

```sh
docker run -d \
  --name watchtower \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower
```

如果從私有 Docker 註冊表中拉取映像檔，請使用環境變數 `REPO_USER` 和 `REPO_PASS` 或將主機的 docker 配置文件掛載到容器中（位於容器文件系統的根目錄 /）。

```sh
docker run -d \
  --name watchtower \
  -e REPO_USER=username \
  -e REPO_PASS=password \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower container_to_watch --debug
```

另外，如果您在 Docker Hub 上設置了 2FA 身份驗證，提供帳號和密碼將不足夠。相反，可以運行 docker login 命令將憑證存在 `$HOME/.docker/config.json` 文件中，然後掛載此配置文件以使其對 Watchtower 容器可用：

```sh
docker run -d \
  --name watchtower \
  -v $HOME/.docker/config.json:/config.json \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower container_to_watch --debug
```

## 執行範例

底下我們用 docker-compose 方式來測試正在執行的容器

```yml
version: "3"
services:
  example53:
    image: ghcr.io/go-training/example53:latest
    restart: always
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
    ports:
      - "8080:8080"

  watchtower:
    image: containrrr/watchtower
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: --interval 5
```

啟動後可以看到底下 Log 訊息

```sh
example53_1   | [GIN-debug] [WARNING] Creating an Engine instance with the Logger and Recovery middleware already attached.
example53_1   |
example53_1   | [GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
example53_1   |  - using env: export GIN_MODE=release
example53_1   |  - using code: gin.SetMode(gin.ReleaseMode)
example53_1   |
example53_1   | [GIN-debug] GET    /ping                     --> main.main.func1 (3 handlers)
example53_1   | [GIN-debug] GET    /                         --> main.main.func2 (3 handlers)
example53_1   | [GIN-debug] [WARNING] You trusted all proxies, this is NOT safe. We recommend you to set a value.
example53_1   | Please check https://pkg.go.dev/github.com/gin-gonic/gin#readme-don-t-trust-all-proxies for details.
example53_1   | [GIN-debug] Environment variable PORT is undefined. Using port :8080 by default
example53_1   | [GIN-debug] Listening and serving HTTP on :8080
watchtower_1  | time="2023-03-02T01:13:07Z" level=info msg="Watchtower 1.5.3"
watchtower_1  | time="2023-03-02T01:13:07Z" level=info msg="Using no notifications"
watchtower_1  | time="2023-03-02T01:13:07Z" level=info msg="Checking all containers (except explicitly disabled with label)"
watchtower_1  | time="2023-03-02T01:13:07Z" level=info msg="Scheduling first run: 2023-03-02 01:13:12 +0000 UTC"
watchtower_1  | time="2023-03-02T01:13:07Z" level=info msg="Note that the first check will be performed in 4 seconds"
watchtower_1  | time="2023-03-02T01:13:14Z" level=info msg="Session done" Failed=0 Scanned=2 Updated=0 notify=no
watchtower_1  | time="2023-03-02T01:13:19Z" level=info msg="Session done" Failed=0 Scanned=2 Updated=0 notify=no
watchtower_1  | time="2023-03-02T01:13:24Z" level=info msg="Session done" Failed=0 Scanned=2 Updated=0 notify=no
```

你可以根據需要監控的時間間隔調整 `--interval 5` 參數，這邊先設定 5 秒，watchtower 預設監控 Host 全部容器，故如果有些容器不想更新，可以在設定 `label` 為

```yml
labels:
  - "com.centurylinklabs.watchtower.enable=false"
```

另外每次升級後，舊有的容器或映像檔都還是會存在主機內，會佔用一定空間，這時可以透過 `--cleanup` 參數讓 watchtower 會在使用新的映像檔案重新啟動容器後刪除舊的映像檔。

```yml
  watchtower:
    image: containrrr/watchtower
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: --interval 5 --cleanup
```

過程中拉到新的 Image 就可以看到底下錯誤訊息，會先送 SIGTERM 訊號給容器做 Gracefully Shutdown。

```sh
watchtower_1  | time="2023-03-02T01:35:15Z" level=info msg="Found new ghcr.io/go-training/example53:latest image (040d01951ee2)"
watchtower_1  | time="2023-03-02T01:35:17Z" level=info msg="Stopping /root_example53_1 (57fc95adf8cd) with SIGTERM"
```

如果要改 Stop Signals 可以透過 Label 方式轉換，請改 `Dockerfile`

```yml
LABEL com.centurylinklabs.watchtower.stop-signal="SIGHUP"
```

或者是在啟動容器時加上

```sh
docker run -d --label=com.centurylinklabs.watchtower.stop-signal=SIGHUP someimage
```

## 使用心得

未來團隊在 CI/CD 流程，就可以專注在打包 Image，並且上傳到 Docker Registry 即可，機器上面所有的服務全部透過 Watchtower 來監控，上傳的 Image 也遵循 [semver](https://semver.org/) 原則。減輕不少撰寫 Shell Script 工作流程。
