---
title: 用 10 分鐘部署專案到 AWS Lambda
author: appleboy
type: post
date: 2018-10-25T03:10:18+00:00
url: /2018/10/deploy-app-to-aws-lambda-using-up-tool-in-ten-minutes/
dsq_thread_id:
  - 6994444829
categories:
  - AWS
  - Drone CI
  - Golang
tags:
  - AWS
  - AWS Lambda
  - deployment
  - drone
  - golang

---
[<img src="https://i1.wp.com/farm2.staticflickr.com/1956/43711539730_7bd9f610c3_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2018-10-24 at 9.37.49 AM" data-recalc-dims="1" />][1]

看到這標題也許非常聳動，也可能覺得不可思議，今天來探討如何將專案直接部署到 [AWS Lambda][2] 並且自動化將 [API Gateway][3] 設定完成。當然要做到完全自動化，必須要使用一些工具才能完成，本篇將介紹由 [TJ][4] 所開發的 [apex/up][5] 工具，如果您不熟悉 EC2 也不太懂 Command line 操作，本文非常適合您，不需要管理任何 EC2 機器，也不需要在熟悉任何 Linux Command 就可以完成簡單的專案部署。首先為什麼我選擇 apex/up 而不是選擇 [apex/apex][6]，原因是使用 up 工具，您的專案是不用更動任何程式碼，就可以將專案直接執行在 AWS Lambda，那 API Gateway 部分也會一並設定完成，將所有 Request 直接 Proxy 到該 Lambda function。如果您希望對於 AWS Lambda 有更多進階操作，我會建議您用 [apex/apex][6] 或 [Serverless][7]。您可以想像使用 up 就可以將 AWS Lambda 當作小型的 EC2 服務，但是不用自己管理 EC2，現在 up 支援 [Golang][8], [Node.js][9], [Python][10] 或 Java 程式語言，用一行 command 就可以將專案部署到雲端了。

<!--more-->

## 影片教學

{{< youtube Z2vp-L3bZwU >}}

本系列影片不只有介紹 up 工具，還包含『設定 custom domain 在 API Gateway』及『用 drone 搭配 apex/up 自動化部署 AWS Lambda』。有興趣可以參考底下:

  * 使用 apex/up 工具部署 Go 專案到 AWS Lambda [Youtube][11], [Udemy][12]
  * 設定 Custom Domain Names 在 API Gateway 上 [Udemy][13]
  * 用 drone-apex-up 自動化更新 Go 專案到 AWS Lambda [Udemy][14]

買了結果沒興趣想退費怎麼辦？沒關係，在 Udemy 平台 30 天內都可以全額退費，所以不用擔心買了後悔。如果你對 Go 語言 (現在 $1800) 及 Drone 自動化部署 (現在 $1800) 都有興趣，想要一起購買，你可以直接匯款到底下帳戶，有合購優惠價

  * 富邦銀行: 012
  * 富邦帳號: 746168268370
  * 匯款金額: 台幣 $3400 元

## 使用 up 工具

[up][15] 可以在幾秒鐘的時間將專案直接部署到 AWS Lambda，透過 up 可以快速將 Staging 及 Productoon 環境建置完成。底下直接用 GO 語言當例子。

```go
package main

import (
    "os"

    "github.com/gin-gonic/gin"
)

func main() {
    port := ":" + os.Getenv("PORT")
    stage := os.Getenv("UP_STAGE")

    r := gin.Default()
    r.GET("/", func(c *gin.Context) {
        c.JSON(200, gin.H{
            "message": "pong " + stage,
        })
    })

    r.GET("/v1", func(c *gin.Context) {
        c.JSON(200, gin.H{
            "message": "pong " + stage + " v1 ++ drone",
        })
    })

    r.Run(port)
}
```

接著在專案內放置 `up.json` 檔案，內容如下:

```json
{
  "name": "demo",
  "profile": "default",
  "regions": [
    "ap-southeast-1"
  ]
}
```

`name` 代表 aws lambda 函數名稱，`profile` 會讀 `~/.aws/credentials` 底下的 profile 設定。接著執行 `up -v`

```bash
$ up -v
```

[<img src="https://i1.wp.com/farm2.staticflickr.com/1963/45494403542_a91463e6cc_z.jpg?w=840&#038;ssl=1" alt="up_json_—_training" data-recalc-dims="1" />][16]

從上圖可以看到預設編譯行為是

```bash
$ GOOS=linux GOARCH=amd64 go build -o server *.go
```

並且上傳完成後會將 `server` 移除。登入 AWS Lambda 入口，可以看到 up 幫忙建立了兩個環境，一個是 `staging` 另一個是 `production`，假設要部署專案到 production 環境可以下

```bash
$ up deploy production -v
```

部署完成後，可以直接透過 up 拿到 API Gateway 給的測試 URL，可以在瀏覽器瀏覽

```bash
$ up url
https://xxxxxxx.execute-api.ap-southeast-1.amazonaws.com/staging/
```

當然也可以到 API Gateway 那邊設定好 Custom Domain 就可以直接用自己的 Domain，而不會有 `/staging/` 字眼在 URL 路徑上。

## 搭配 Drone 自動化部署

在自己電腦測試完成後，接著要設定 CI/CD 來達到自動化部署，本文直接拿 [Drone][17] 來串接。底下是 .drone.yml 設定檔

```yaml
pipeline:
  build:
    image: golang:1.11
    pull: true
    environment:
      TAGS: sqlite
      GO111MODULE: "on"
    commands:
      - cd example23-deploy-go-application-with-up && GOOS=linux GOARCH=amd64 go build -o server *.go
  up:
    image: appleboy/drone-apex-up
    pull: true
    secrets: [aws_secret_access_key, aws_access_key_id]
    stage:
      - staging
    directory: ./example23-deploy-go-application-with-up
    when:
      event: push
      branch: master

  up:
    image: appleboy/drone-apex-up
    pull: true
    secrets: [aws_secret_access_key, aws_access_key_id]
    stage:
      - production
    directory: ./example23-deploy-go-application-with-up
    when:
      event: tag
```

上面可以很清楚看到，只要是 push 到 master branch 就會觸發 staging 環境部署。而下 Tag 則是部署到 Production。要注意的是由於 up 會有預設編譯行為，但是專案複雜的話就需要透過其他指令去執行。只要去蓋掉預設行為就可以。

```json
{
  "name": "demo",
  "profile": "default",
  "regions": [
    "ap-southeast-1"
  ],
  "hooks": {
    "build": [
      "up version"
    ],
    "clean": [
    ]
  }
}
```

看到 `hooks` 階段，其中 build 部分需要填寫，不可以是空白。

## 心得

如果您想快速的架設好 API 後端，或者是靜態網站，我相信 up 是一套不錯的工具，可以快速架設好開發或測試環境。而且可以省下不少開 EC2 費用，如果有興趣的話大家可以參考看看 up 工具。

 [1]: https://www.flickr.com/photos/appleboy/43711539730/in/dateposted-public/ "Screen Shot 2018-10-24 at 9.37.49 AM"
 [2]: https://aws.amazon.com/tw/lambda/
 [3]: https://aws.amazon.com/tw/api-gateway/
 [4]: https://github.com/tj
 [5]: https://github.com/apex/up
 [6]: https://github.com/apex/apex
 [7]: https://serverless.com/
 [8]: https://golang.org
 [9]: https://nodejs.org/en/
 [10]: https://www.python.org/
 [11]: {{< youtube Z2vp-L3bZwU >}}
 [12]: https://www.udemy.com/golang-fight/learn/v4/t/lecture/12246918
 [13]: https://www.udemy.com/golang-fight/learn/v4/t/lecture/12249324
 [14]: https://www.udemy.com/golang-fight/learn/v4/t/lecture/12270902
 [15]: https://up.docs.apex.sh/#introduction
 [16]: https://www.flickr.com/photos/appleboy/45494403542/in/dateposted-public/ "up_json_—_training"
 [17]: https://github.com/drone/drone
