---
title: Gorush 輕量級手機訊息發送服務
author: appleboy
type: post
date: 2017-11-01T02:03:29+00:00
url: /2017/11/gorush-a-push-notification-server-written-in-go/
dsq_thread_id:
  - 6255057348
categories:
  - DevOps
  - Docker
  - Drone CI
  - Golang
tags:
  - drone
  - golang
  - gorush

---
[![][1]][1]

今年第一次參加濁水溪以南最大研討會 \[Mopcon\]\[1\]，給了一場議程叫『\[用 Go 語言打造輕量級 Push Notification 服務\]\[2\]』，身為南部人一定要參加 Mopcon，剛好透過此議程順便發佈新版 \[Gorush\]\[3\]，其實今年投稿 Mopcon 最主要是回家鄉宣傳 \[Google\]\[4\] 所推出的 \[Go\]\[5\] 語言，藉由實際案例來跟大家分享如何入門 Go 語言，以及用 Go 語言最大好的好處有哪些。底下是此議程大綱:

  * 為什麼建立 \[Gorush\]\[3\] 專案
  * 如何用 Go 語言實作
  * 用 \[Drone\]\[6\] 自動化測試及部署
  * 在 \[Kubernetes\]\[7\] 上跑 Gorush

<!--more-->

## 什麼是 Gorush

Gorush 是一套輕量級的 Push Notification 服務，此服務只做一件事情，就是發送訊息給 Google [Andriod][2] 或 Apple [iOS][3] 手機，啟動時預設跑在 `8088` port，可以透過 [Docker][4] 或直接用 Command line 執行，對於 App 開發者，可以直接下載[執行檔][5]，在自己電腦端發送訊息給手機測試。藉由這次投稿順便發佈了新版本。底下來說明新版本多了哪些功能。

## 支援 RPC 協定

在此之前 Gorush 只有支援 [REST API][6] 方式，也就是透過 JSON 方式來通知伺服器來發送訊息，新版了多了 [RPC][7] 方式，這邊我是使用 [gRPC][8] 來實作，Gorush 預設是不啟動 gRPC 服務，你必須要透過參數方式才可以啟動，詳細可以參考[此文件][9]，底下是 Go 語言客戶端範例:

```go
package main

import (
    "log"

    pb "github.com/appleboy/gorush/rpc/proto"
    "golang.org/x/net/context"
    "google.golang.org/grpc"
)

const (
    address = "localhost:9000"
)

func main() {
    // Set up a connection to the server.
    conn, err := grpc.Dial(address, grpc.WithInsecure())
    if err != nil {
        log.Fatalf("did not connect: %v", err)
    }
    defer conn.Close()
    c := pb.NewGorushClient(conn)

    r, err := c.Send(context.Background(), &pb.NotificationRequest{
        Platform: 2,
        Tokens:   []string{"1234567890"},
        Message:  "test message",
    })
    if err != nil {
        log.Fatalf("could not greet: %v", err)
    }
    log.Printf("Success: %t\n", r.Success)
    log.Printf("Count: %d\n", r.Counts)
}
```

## 支援 ARM64 Docker 映像檔

目前已經支援 ARM64 的 Docker 版本，所以可以在 ARM64 板子內用 Docker 來執行，可以直接在 [Docker Hub][10] 找到相對應的標籤

## 支援全域變數

Gorush 本身支援 Yaml 設定檔，但是每次想要改設定，都要重新修改檔案，這不是很方便，所以我透過 [Viper][11] 套件來讓 Gorush 同時支援 Yaml 設定，或 Global 變數，也就是以後都可以透過變數方式來動態調整，有了這方式就可以讓 Docker 透過環境變數來設定。底下是範例讓開發者動態調整 HTTP 服務 Port。請注意所有變數的前置符號為 `GORUSH_`

```bash
$ GORUSH_CORE_PORT=8089 gorush
```

## 支援 Kubernetes

此版增加了 \[Kubernetes\]\[7\] 設定方式，有了上述的全域變數支援，這時候設定 Kubernetes 就更方便了，請直接參考 [k8s 目錄][12]，詳細安裝步驟請參考[此說明][13]，底下是透過 ENV 動態設定 Gorush

```yml
env:
- name: GORUSH_STAT_ENGINE
  valueFrom:
    configMapKeyRef:
      name: gorush-config
      key: stat.engine
- name: GORUSH_STAT_REDIS_ADDR
  valueFrom:
    configMapKeyRef:
      name: gorush-config
      key: stat.redis.host
```

## iOS 支援動態發送到開發或正式環境

在此之前發送訊息到 iOS 手機，都必須在啟動伺服器前將 iOS 環境設定好，現在可以動態調整 JSON 參數。

```json
{
  "notifications": [
    {
      "tokens": ["token_a", "token_b"],
      "platform": 1,
      "message": "Hello World iOS!"
    }
  ]
}
```

可以加上 `development` 或 `production` 布林參數，底下是將訊息傳給 iOS 開發伺服器

```json
{
  "notifications": [
    {
      "tokens": ["token_a", "token_b"],
      "platform": 1,
      "development": true,
      "message": "Hello World iOS!"
    }
  ]
}
```

## 投影片

底下是議程投影片，有興趣的參考看看

<div style="margin-bottom:5px">
  <strong> <a href="//www.slideshare.net/appleboy/gorush-a-push-notification-server-written-in-go" title="Gorush: A push notification server written in Go" target="_blank">Gorush: A push notification server written in Go</a> </strong> from <strong><a href="https://www.slideshare.net/appleboy" target="_blank">Bo-Yi Wu</a></strong>
</div> 最後有講到如何部署及測試 Go 語言，這邊講了一下 Drone 這套自動化測試工具。如果大家有興趣可以參考我在 \[Udemy 開設的課程\]\[31\]，目前特價 1600 元。Drone 幫忙開發者自動化測試，部署到 Docker Hub 或編譯出執行檔，這些在 Drone 裡面都可以透過 

`YAML` 來設定，開發者只需要專注於寫程式就可以了。 [31]:https://www.udemy.com/devops-oneday/?couponCode=KUBERNETES [1]:https://mopcon.org/2017/ [2]:https://www.slideshare.net/appleboy/gorush-a-push-notification-server-written-in-go [3]:https://github.com/appleboy/gorush [4]:https://www.google.com [5]:https://golang.org/ [6]:https://github.com/drone/drone [7]:https://kubernetes.io/

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://www.android.com/
 [3]: https://en.wikipedia.org/wiki/IOS
 [4]: https://www.docker.com/
 [5]: https://github.com/appleboy/gorush/releases
 [6]: https://zh.wikipedia.org/zh-tw/REST
 [7]: https://en.wikipedia.org/wiki/Remote_procedure_call
 [8]: https://grpc.io/
 [9]: https://github.com/appleboy/gorush#run-grpc-service
 [10]: https://hub.docker.com/r/appleboy/gorush/tags/
 [11]: https://github.com/spf13/viper
 [12]: https://github.com/appleboy/gorush/tree/master/k8s
 [13]: https://github.com/appleboy/gorush#run-gorush-in-kubernetes