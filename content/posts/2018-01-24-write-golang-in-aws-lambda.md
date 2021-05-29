---
title: 在 AWS Lambda 上寫 Go 語言搭配 API Gateway
author: appleboy
type: post
date: 2018-01-24T02:43:43+00:00
url: /2018/01/write-golang-in-aws-lambda/
dsq_thread_id:
  - 6434215532
categories:
  - Golang
tags:
  - AWS
  - golang
  - lambda

---
[<img src="https://i2.wp.com/farm5.staticflickr.com/4655/39154963694_d53bc2a73e_z.jpg?w=840&#038;ssl=1" alt="Snip20180124_2" data-recalc-dims="1" />][1]

這應該不是什麼新消息了，就是 [AWS Lambda][2] 正式[支援 Go 語言][3]，也就是可以將 [Go 語言][4]編譯出來的二進制檔案直接放進去 Lambda Function 內，前面可以搭配 [API Gateway][5]，後面可以搭配 [CloudWatch][6] 或 [S3][7]，本文章會教大家如何將 [Gin][8] 打包編譯進 Lambda，官網其實也有提供 [Library 或範例][9]方便大家實作，大家可以參考看看。

<!--more-->

## 撰寫 Lambda function

如果想搭配 API Gateway 後端 Lambda 可能接 Restful 或 GraphQL API 的話，肯定要 Listen 單一 Http Port，底下是用 Gin 來實現一個簡單的 http 伺服器:

```go
package main

import (
    "log"
    "net/http"
    "os"

    "github.com/gin-gonic/gin"
)

func helloHandler(c *gin.Context) {
    name := c.Param("name")
    c.String(http.StatusOK, "Hello %s", name)
}

func welcomeHandler(c *gin.Context) {
    c.String(http.StatusOK, "Hello World from Go")
}

func rootHandler(c *gin.Context) {
    c.JSON(http.StatusOK, gin.H{
        "text": "Welcome to gin lambda server.",
    })
}

func routerEngine() *gin.Engine {
    // set server mode
    gin.SetMode(gin.DebugMode)

    r := gin.New()

    // Global middleware
    r.Use(gin.Logger())
    r.Use(gin.Recovery())

    r.GET("/welcome", welcomeHandler)
    r.GET("/user/:name", helloHandler)
    r.GET("/", rootHandler)

    return r
}

func main() {
    addr := ":" + os.Getenv("PORT")
    log.Fatal(http.ListenAndServe(addr, routerEngine()))
}
```

可以很清楚看到在 Gin 內，只要實現 Router 部分，就可以透過 `http.ListenAndServe` 方式來啟動小型 Web 服務，但是上面的程式碼不能跑在 Lambda 內，這邊就要使用 [Go 大神 TJ][10] 所開發的 [apex/gateway][11]，只要將 `http.ListenAndServe` 換成 `gateway.ListenAndServe` 就可以了

```go
func main() {
    addr := ":" + os.Getenv("PORT")
    log.Fatal(gateway.ListenAndServe(addr, routerEngine()))
}
```

有沒有簡單到不行？詳細範例可以參考此 [GitHub Repo][12]。

## 建立 Lambda function

[<img src="https://i2.wp.com/farm5.staticflickr.com/4622/39865839281_0b2b5b99fb_z.jpg?w=840&#038;ssl=1" alt="Snip20180124_3" data-recalc-dims="1" />][13]

這邊不詳細說明了，重點是在下拉選單請選擇 `Go 1.x` 版本即可，不知道官方什麼時候要升級 [Node.js][14] 版本 XD

## 編譯 Go 檔案並上傳

AWS Lambda 只有支援 Linux 架構，所以只需要透過底下指令就可以編譯出來:

```bash
$ GOOS=linux go build -o main .
$ zip deployment.zip main
```

把輸出檔案設定為 `main`，最後透過 zip 方式打包成 `deployment.zip`，並且從 AWS Web Console 頁面上傳。

[<img src="https://i2.wp.com/farm5.staticflickr.com/4703/38967051975_369ba55720_z.jpg?w=840&#038;ssl=1" alt="Snip20180124_5" data-recalc-dims="1" />][15]

覺得每次都要手動上傳有點麻煩，歡迎大家試試看 [drone-lambda][16]，可以透過指令方式更新 Lambda function。下一篇會教大家自動化更新 Lambda

```bash
$ drone-lambda --region ap-southeast-1 \
  --access-key xxxx \
  --secret-key xxxx \
  --function-name upload-s3 \
  --zip-file deployment.zip
```

## API Gateway + Cloud Watch

快速參考底下測試方式

[<img src="https://i1.wp.com/farm5.staticflickr.com/4699/25992563108_a15e987f7d_z.jpg?w=840&#038;ssl=1" alt="Snip20180124_6" data-recalc-dims="1" />][17]

可以看到在網址輸入 `/user/appleboy` 可以很快速拿到 Response，接著看看 Cloud Watch

[<img src="https://i1.wp.com/farm5.staticflickr.com/4706/28086363329_8570114db2_z.jpg?w=840&#038;ssl=1" alt="Snip20180124_7" data-recalc-dims="1" />][18]

## 效能測試 Benchmark

預設 AWS Lambda 使用 128 MB 記憶體，那下面透過 [vegeta][19] 來看看 Go 的效能。之後有機會可以跟 Python 或 Node.js 比較看看。底下是 **128 MB** 記憶體。每秒打 1024 request 並且持續 10 秒

```bash
$ vegeta attack -rate=1024 -duration=10s -targets=target2.txt | tee results.bin | vegeta report
Requests      [total, rate]            10240, 1024.10
Duration      [total, attack, wait]    20.335101947s, 9.999018014s, 10.336083933s
Latencies     [mean, 50, 95, 99, max]  6.091282008s, 4.893951645s, 14.508009942s, 17.11847442s, 20.128384389s
Bytes In      [total, mean]            143360, 14.00
Bytes Out     [total, mean]            0, 0.00
Success       [ratio]                  100.00%
Status Codes  [code:count]             200:10240
```

換 512 MB 每秒打 1024 request 並且持續 10 秒

```bash
Requests      [total, rate]            10240, 1024.10
Duration      [total, attack, wait]    11.989730554s, 9.999012371s, 1.990718183s
Latencies     [mean, 50, 95, 99, max]  1.491340336s, 1.114643849s, 4.112241113s, 6.087949237s, 10.107294516s
Bytes In      [total, mean]            143360, 14.00
Bytes Out     [total, mean]            0, 0.00
Success       [ratio]                  100.00%
Status Codes  [code:count]             200:10240
```

可以看到 128MB Latencies 是 `6.091282008s` 而 512MB 可以降到 `1.491340336s`

# 所有資料請直接參考 [gin-lambda][12]

 [1]: https://www.flickr.com/photos/appleboy/39154963694/in/dateposted-public/ "Snip20180124_2"
 [2]: https://aws.amazon.com/lambda/
 [3]: https://aws.amazon.com/blogs/compute/announcing-go-support-for-aws-lambda/
 [4]: https://golang.org
 [5]: https://aws.amazon.com/api-gateway/
 [6]: https://aws.amazon.com/cloudwatch/
 [7]: https://aws.amazon.com/s3/
 [8]: https://github.com/gin-gonic/gin
 [9]: https://github.com/aws/aws-lambda-go
 [10]: https://github.com/tj
 [11]: https://github.com/apex/gateway
 [12]: https://github.com/appleboy/gin-lambda
 [13]: https://www.flickr.com/photos/appleboy/39865839281/in/dateposted-public/ "Snip20180124_3"
 [14]: https://nodejs.org/en/
 [15]: https://www.flickr.com/photos/appleboy/38967051975/in/dateposted-public/ "Snip20180124_5"
 [16]: https://github.com/appleboy/drone-lambda
 [17]: https://www.flickr.com/photos/appleboy/25992563108/in/dateposted-public/ "Snip20180124_6"
 [18]: https://www.flickr.com/photos/appleboy/28086363329/in/dateposted-public/ "Snip20180124_7"
 [19]: https://github.com/tsenart/vegeta