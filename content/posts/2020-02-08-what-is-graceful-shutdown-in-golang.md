---
title: '[Go 教學] 什麼是 graceful shutdown?'
author: appleboy
type: post
date: 2020-02-08T03:29:08+00:00
url: /2020/02/what-is-graceful-shutdown-in-golang/
dsq_thread_id:
  - 7859417152
categories:
  - Golang
tags:
  - golang
  - graceful shutdown

---
[![golang logo][1]][1]

我們該如何升級 Web 服務，你會說很簡單啊，只要關閉服務，上程式碼，再開啟服務即可，可是很多時候開發者可能沒有想到現在服務上面是否有正在處理的資料，像是購物車交易？也或者是說背景有正在處理重要的事情，如果強制關閉服務，就會造成下次啟動時會有一些資料上的差異，那該如何優雅地關閉服務，這就是本篇的重點了。底下先透過簡單的 gin http 服務範例介紹簡單的 web 服務

<!--more-->

## 教學影片

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][2]
  * [一天學會 DevOps 自動化測試及部署][3]

## 基本 HTTPD 服務

<pre><code class="language-go">package main

import (
    "log"
    "net/http"
    "time"

    "github.com/gin-gonic/gin"
)

func main() {
    router := gin.Default()
    router.GET("/", func(c *gin.Context) {
        time.Sleep(5 * time.Second)
        c.String(http.StatusOK, "Welcome Gin Server")
    })

    srv := &http.Server{
        Addr:    ":8080",
        Handler: router,
    }

    // service connections
    if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
        log.Fatalf("listen: %s\n", err)
    }

    log.Println("Server exiting")
}</code></pre>

上述程式碼在我們寫基本的 web 服務都不會考慮到 graceful shutdown，如果有重要的 Job 在上面跑，我強烈建議一定要加上 [Go][4] 在 1.8 版推出的 [graceful shutdown 函式][5]，上述程式碼假設透過底下指令執行:

<pre><code class="language-sh">curl -v http://localhost:8080</code></pre>

接著把 server 關閉，就會強制關閉 client 連線，並且噴錯。底下會用 graceful shutdown 來解決此問題。

## 使用 graceful shutdown

Go 1.8 推出 graceful shutdown，讓開發者可以針對不同的情境在升級過程中做保護，整個流程大致上會如下:

  1. 關閉服務連接埠
  2. 等待並且關閉所有連線

可以看到步驟 1. 會先關閉連接埠，確保沒有新的使用者連上服務，第二步驟就是確保處理完剩下的 http 連線才會正常關閉，來看看底下範例

<pre><code class="language-go">// +build go1.8

package main

import (
    "context"
    "log"
    "net/http"
    "os"
    "os/signal"
    "syscall"
    "time"

    "github.com/gin-gonic/gin"
)

func main() {
    router := gin.Default()
    router.GET("/", func(c *gin.Context) {
        time.Sleep(5 * time.Second)
        c.String(http.StatusOK, "Welcome Gin Server")
    })

    srv := &http.Server{
        Addr:    ":8080",
        Handler: router,
    }

    go func() {
        // service connections
        if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
            log.Fatalf("listen: %s\n", err)
        }
    }()

    // Wait for interrupt signal to gracefully shutdown the server with
    // a timeout of 5 seconds.
    quit := make(chan os.Signal, 1)
    // kill (no param) default send syscall.SIGTERM
    // kill -2 is syscall.SIGINT
    // kill -9 is syscall.SIGKILL but can&#039;t be catch, so don&#039;t need add it
    signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
    &lt;-quit
    log.Println("Shutdown Server ...")

    ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
    defer cancel()
    if err := srv.Shutdown(ctx); err != nil {
        log.Fatal("Server Shutdown: ", err)
    }

    log.Println("Server exiting")
}</code></pre>

首先可以看到將 `srv.ListenAndServe` 直接丟到背景執行，這樣才不會阻斷後續的流程，接著宣告一個 `os.Signal` 訊號的 Channel，並且接受系統 SIGINT 及 SIGTERM，也就是只要透過 kill 或者是 `docker rm` 就會收到訊號關閉 `quit` 通道

<pre><code class="language-go">&lt;-quit</code></pre>

由上面可知，整個 main func 會被 block 在這地方，假設按下 ctrl + c 就會被系統訊號 (SIGINT 及 SIGTERM) 通知關閉 quit 通道，通道被關閉後，就會繼續往下執行

<pre><code class="language-go">ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()
if err := srv.Shutdown(ctx); err != nil {
    log.Fatal("Server Shutdown: ", err)
}</code></pre>

最後可以看到 `srv.Shutdown` 就是用來處理『1. 關閉連接埠』及『2. 等待所有連線處理結束』，可以看到傳了一個 context 進 Shutdown 函式，目的就是讓程式最多等待 5 秒時間，如果超過 5 秒就強制關閉所有連線，所以您需要根據 server 處理的資料時間來決 定等待時間，設定太短就會造成強制關閉，建議依照情境來設定。至於服務 shutdown 後可以處理哪些事情就看開發者決定。

  1. 關閉 Database 連線
  2. 等到背景 worker 處理

可以搭配上一篇提到的『[graceful shutdown with multiple workers][6]』

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://www.udemy.com/course/golang-fight/?couponCode=202001
 [3]: https://www.udemy.com/course/devops-oneday/?couponCode=202001
 [4]: https://golang.org
 [5]: https://golang.org/doc/go1.8#http_shutdown
 [6]: https://blog.wu-boy.com/2020/02/graceful-shutdown-with-multiple-workers/