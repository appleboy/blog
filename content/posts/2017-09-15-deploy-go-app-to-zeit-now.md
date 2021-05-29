---
title: 部署 Go 語言 App 到 Now.sh
author: appleboy
type: post
date: 2017-09-15T03:35:12+00:00
url: /2017/09/deploy-go-app-to-zeit-now/
dsq_thread_id:
  - 6144596941
categories:
  - DevOps
  - Docker
  - Golang
tags:
  - Docker
  - golang
  - now.sh

---
[![][1]][1]

本篇要教大家如何部署 [Go][2] 語言的 App 到 [now.sh][3] 服務。now 服務是讓開發者可以透過 JavaScript 或用 Docker 方式直接部署到 now 雲端機器，也就是 now 所提供的服務可以在自己電腦透過 `package.json` 或 `Dockerfile` 來部署 app。原先剛出來時候，只有支援 node.js 部署，後來才增加 Docker。透過 Docker 就可以來部署各種不同語言的專案。

<!--more-->

## 事前準備

請先下載 [now-cli][4] 工具，直接到 [Release][5] 頁面找到相對應的執行檔。下載後丟到 `/usr/local/bin` 或新增到 `$PATH` 變數底下。

## Go 語言

請直接在專案內建立 `server.go`

```go
package main

import (
    "flag"
    "time"

    "github.com/gin-gonic/gin"
)

func rootHandler(context *gin.Context) {
    currentTime := time.Now()
    currentTime.Format("20060102150405")
    context.JSON(200, gin.H{
        "current_time": currentTime,
        "text":         "Hello World",
    })
}

// GetMainEngine is default router engine using gin framework.
func GetMainEngine() *gin.Engine {
    r := gin.New()

    r.GET("/", rootHandler)

    return r
}

// RunHTTPServer List 8000 default port.
func RunHTTPServer() error {
    port := flag.String("port", "8000", "The port for the mock server to listen to")

    // Parse all flag
    flag.Parse()

    err := GetMainEngine().Run(":" + *port)

    return err
}

func main() {
    RunHTTPServer()
}
```

存檔後，請直接透過 `go run` 進行測試。

## 撰寫 Dockerfile

接著要寫 Dockerfile 來進行編譯及測試

```bash
FROM golang:1.9-alpine3.6

MAINTAINER Bo-Yi Wu <appleboy.tw@gmail.com>

ADD . /go/src/github.com/appleboy/go-hello

RUN go install github.com/appleboy/go-hello

EXPOSE 8000
CMD ["/go/bin/go-hello"]
```

請修改 `github.com/appleboy/go-hello` 路徑，接著透過底下指令來編譯 Docker，注意 `EXPOSE 8000` 代表需要將 docker 內的 8000 對外。

```bash
$ docker build -t appleboy/go-hello -f Dockerfile .
```

編譯成功後，使用 docker run 執行

```bash
$ docker run -p 8080:8000 appleboy/go-hello
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:   export GIN_MODE=release
 - using code:  gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /                         --> main.rootHandler (1 handlers)
[GIN-debug] Listening and serving HTTP on :8000
```

你可以發現成功執行了 app。

## 部署到 Now.sh

在第一個步驟安裝好 now-cli 指令，請直接在專案目錄內下 `now`，就可以發現系統會自動上傳該專案目錄底下所有檔案。有些檔案是不需要上傳的話，請使用 `.dockerignore` 來自動忽略，node.js 則是透過 `.npmignore`。如果沒有發現 `.dockerignore` 及 `.npmignore` 則是檢查 `.gitignore` 檔案。

# [Demo 網站][6]

## Now.sh 缺陷

### 部署慢

不確定是不是在台灣的關係，在家裡部署到 now.sh，檔案大小不到 5MB 要部署 30 分鐘以上。蠻久的。

### 免費方案

免費方案單一上傳檔案不能超過 1MB，這對於寫 Go 語言的，不能先編譯出 binary 然後再進行 Docker 包裝來說相當不方便。變成需要將檔案全部丟到 now.sh 再進行編譯，部署體驗就會變得不是很好。

### 無法指定 Dockerfile 名稱

現在只支援專案目錄底下的 `Dockerfile`，假設今天把檔名換成 `Dockerfile.now` 這樣是無法讀取的，command 也沒有參數讓開發者修正。

### .dockerignore 無作用

如果在 `.dockerignore` 寫入

    *
    !bin/
    !config/

可以發現加上 `--debug` 模式後，config 內的檔案沒有上傳到 now.sh，造成編譯失敗。

## 結論

如果想要透過 now.sh 來 demo，其實蠻方便的，要是上 production，我建議還是不要冒險。免費方案目前只支援三個 instance，每個月流量只能有 1G。大家可以參考試用看看。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://golang.org
 [3]: https://zeit.co/now
 [4]: https://github.com/zeit/now-cli
 [5]: https://github.com/zeit/now-cli/releases
 [6]: https://go-hello-arfqsbnfph.now.sh/