---
title: "用 Go 語言建立 Web 及 Worker 服務實現取消任務 (二)"
date: 2023-01-02T08:32:31+08:00
author: appleboy
type: post
slug: create-server-and-worker-for-cancel-task-in-golang
share_img: https://i.imgur.com/VZyfv0M.png
categories:
  - Golang
  - System Design
---

![cancel a task](https://i.imgur.com/a5rYLFr.png)

上一篇『[系統設計: 如何取消正在執行的工作任務 (一)][1]』教大家如何用 [Go 語言][2]實現 `canceler` package 來紀錄及取消正在執行的任務。而本篇來實現上圖的 `HTTP Server` 及 `Worker` 程式碼，底下直接用 Gin 框架來快速實現 HTTP 兩個 Handle，分別是 `Cancel Task` 及 `Ｗatch Task` (如下圖標示的 1 跟 2)。

![cancel a task](https://i.imgur.com/dquTd65.png)

其中上圖綠色框框 `1` 是用來接收使用者想要取消的任務，而 `2` 是用來讓 worker 進行長連接，根據不同的情境可以設定不同的等待時間。大家可能會問，為什麼不讓 Server 主動通知 Worker 就可以了，先解釋這點，這邊我們可能要先假設 Worker 存在的環境是封閉的，不能任意架設服務，故需要主動向 HTTP Server 進行詢問。其中 HTTP Server 跟 Worker 中間可以透過 gRPC 或 RESTful 進行資料交換，本篇先以 RESTful 進行說明。

[1]: https://blog.wu-boy.com/2022/12/system-design-how-to-cancel-a-running-task-in-golang/
[2]: https://go.dev

<!--more-->

## 實現 HTTP 服務

先透過 Gin 框架簡單實現 HTTP 服務

```go
package main

import (
  "context"
  "net/http"
  "time"

  "github.com/gin-gonic/gin"
)

func main() {
  r := gin.Default()
  r.GET("/ping", func(c *gin.Context) {
    c.JSON(http.StatusOK, gin.H{
      "message": "pong",
    })
  })

  r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}
```

![cancel a task](https://i.imgur.com/3WqBNOZ.png)

先來看看使用者取消任務 (ID 為 1234)，服務端該如何實現？上一篇教學有實現了 `schedule` package

```go
package schedule

type Engine struct {
  *canceler
}

func New() *Engine {
  return &Engine{
    canceler: newCanceler(),
  }
}
```

這時候只需要透過 New() 就可以。

```go
// initial schedule instance
s := schedule.New()
```

接著實現 Cancel Task Handler。

```go
r.GET("/cancel-task/:id", func(c *gin.Context) {
  taskID := c.Param("id")

  if err := s.Cancel(context.Background(), taskID); err != nil {
    c.String(http.StatusInternalServerError, "crash")
    return
  }

  c.String(http.StatusOK, "ok")
})
```

上述函式執行 Cancel 會將任務 ID 直接紀錄在 struct map 內，後續可以接著更新任務狀態為『取消』，這邊就看大家怎麼存任務，最直接的方式就是更新資料庫。接著時線 `Watch Task` 函式

![cancel a task](https://i.imgur.com/ebhWNo9.png)

要做到即時取消任務，故 Worker 需要長時間連接上 HTTP 服務，避免過多的請求，造成不必要的負擔，畢竟任務可能需要長時間去跑，時間設定太短，就會造成 HTTP Server 的負擔。

```go
r.GET("/watch-task/:id", func(c *gin.Context) {
  taskID := c.Param("id")

  ctxDone, cancel := context.WithTimeout(context.Background(), 5*time.Second)
  defer cancel()

  ok, _ := s.Cancelled(ctxDone, taskID)
  if ok {
    c.String(http.StatusOK, "true")
    return
  }

  c.String(http.StatusOK, "false")
})
```

上述程式碼可以看到，透過宣告 context timeout 來決定需要等待多長的時間，超過時間後就回覆 `false`，由 HTTP 服務端決定 Worker 連接上來後可以等待的時間。

## 實現 Worker 服務

簡單的 Worker 範例就是開幾個 Goroutine 去持續跟 HTTP 服務連線，直到收到 Cancel 事件。

![cancel a task](https://i.imgur.com/TuFWdNJ.png)

先假設有兩個任務分別是 `1234` 及 `5678`，當這兩個任務正在執行的時候，也順便開 goroutine 在背景跟 HTTP 服務連接，等到任務結束或收到 HTTP 端的中指請求，則結束各自的 Goroutine。

```go
package main

import (
  "fmt"
  "io"
  "net/http"
  "os"
  "sync"
)

func cancelTask(id string) []byte {
  req, err := http.NewRequest(http.MethodGet, "http://localhost:8080/watch-task/"+id, nil)
  if err != nil {
    fmt.Printf("client: could not create request: %s\n", err)
    os.Exit(1)
  }

  res, err := http.DefaultClient.Do(req)
  if err != nil {
    fmt.Printf("client: error making http request: %s\n", err)
    os.Exit(1)
  }

  resBody, err := io.ReadAll(res.Body)
  if err != nil {
    fmt.Printf("client: could not read response body: %s\n", err)
    os.Exit(1)
  }
  return resBody
}

func main() {
  wg := &sync.WaitGroup{}

  wg.Add(1)
  go func() {
    defer wg.Done()
    for {
      resp := string(cancelTask("1234"))
      fmt.Println("task[1234]: cancel the task:", resp)
      if resp == "true" {
        fmt.Println("task[1234]: get cancel event and canceld the task")
        return
      }
    }
  }()
  wg.Add(1)
  go func() {
    defer wg.Done()
    for {
      resp := string(cancelTask("5678"))
      fmt.Println("task[5678]: cancel the task:", resp)
      if resp == "true" {
        fmt.Println("task[5678]: get cancel event and canceld the task")
        return
      }
    }
  }()
  wg.Wait()
}
```

上面程式碼範例請不要直接套用在專案內，因為有些狀況尚未寫進去，像是一般 HTTP Client 不會用預設的 `http.DefaultClient`，因為沒有設定 Timeout 會讓系統整個掛掉，另外 Goroutine 也沒有傳入 Context，會造成背景 Goroutine 都不會結束。這邊只是為了講解才這樣寫的。

## 整合測試

![cancel a task](https://i.imgur.com/PRvUBUp.png)

主要測試的目的就是，當第一個 worker 正在處理 `1234` 任務時，不知道什麼原因，突然跟 HTTP Server 失去連線 (上圖步驟二)，此時如果步驟一收到使用者發送取消的請求，Worker 恢復連線後，要正確即時收到 Cancel 事件，才能完成取消任務。

## 心得

處理長時間的任務，可能會遇到底下問題

1. 如何取得目前任務的狀態？
2. 如何設定任務超時機制？
3. 如何跨服務取消任務？
4. 當 Worker 失去連線或不正常關閉，該如何讓 Task 可以重新執行？
5. 當有多台 Server + 多台 Worker 時，該如何配送任務及取消任務？

團隊除了需要解決此架構之外，也把上述的機制也實現在 [AWS SageMaker](https://aws.amazon.com/sagemaker/) 上，打造 AWS MLOps 平台。本篇程式碼可以在[這邊找到](https://github.com/go-training/training/tree/master/example51-canceler)。
