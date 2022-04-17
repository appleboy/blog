---
title: "Go 語言實作 Graceful Shutdown 套件"
date: 2022-04-17T07:41:33+08:00
type: post
slug: new-package-graceful-shutdown-in-golang
share_img: https://i.imgur.com/D5FfhY5.png
categories:
  - Golang
tags:
  - golang
  - graceful shutdown
---

![background job 01](https://i.imgur.com/D5FfhY5.png)

目前團隊所有服務皆用 [Go 語言][2]打造，而如何優雅的重新啟動服務，避免正在跑的工作執行到一半就被關閉，是一個很中要的議題。故實作了簡易 Graceful Shutdown 套件，讓每個服務都可以支援此功能，如果不知道什麼是 Graceful Shutdown 的朋友們，可以參考這篇『 [[Go 教學] 什麼是 graceful shutdown?][1]』，本篇跟大家介紹一個好用的套件『[appleboy/graceful][3]』，使用後。不用再擔心背景的服務沒完成就被關閉，不只是背景的工作需要處理，在關閉服務前，開發者也要確保部分工作要在關閉服務前才執行，像是關閉 Database 及 Redis 連線。

[1]:https://blog.wu-boy.com/2020/02/what-is-graceful-shutdown-in-golang/
[2]:https://go.dev
[3]:https://github.com/appleboy/graceful

<!--more-->

## 關閉背景執行工作

第一個範例就是當服務啟動了很多背景服務，該如何被正常通知，並且關閉，這邊其實就是用了 [Context](https://blog.wu-boy.com/2020/05/understant-golang-context-in-10-minutes/) 來通知所有背景工作，底下實際範例

```go
package main

import (
  "context"
  "log"
  "time"

  "github.com/appleboy/graceful"
)

func main() {
  m := graceful.NewManager()

  // Add job 01
  m.AddRunningJob(func(ctx context.Context) error {
    for {
      select {
      case <-ctx.Done():
        return nil
      default:
        log.Println("working job 01")
        time.Sleep(1 * time.Second)
      }
    }
  })

  // Add job 02
  m.AddRunningJob(func(ctx context.Context) error {
    for {
      select {
      case <-ctx.Done():
        return nil
      default:
        log.Println("working job 02")
        time.Sleep(500 * time.Millisecond)
      }
    }
  })

  <-m.Done()
}
```

大家可以看到 `AddRunningJob` 就是讓開發者把工作丟到背景處理，而其中的 `ctx` 參數就是在關閉服務時，會立即通知到此函式，重複性執行的工作，就需要透過 `ctx.Done()` 來確保工作可以正常關閉。如果只是執行單次性工作，就不需要用到。

## 關閉服務前執行工作

第二個範例，除了背景工作之外，在關閉服務前，一定會有部分工作需要執行，像是關閉 Database 連線等類似的工作性質 (如下圖)，這時候可以透過另一個函式來使用

![background job 02](https://i.imgur.com/aUYEYrB.png)

```go
func main() {
  m := graceful.NewManager()

  // Add job 01
  m.AddRunningJob(func(ctx context.Context) error {
    for {
      select {
      case <-ctx.Done():
        return nil
      default:
        log.Println("working job 01")
        time.Sleep(1 * time.Second)
      }
    }
  })

  // Add job 02
  m.AddRunningJob(func(ctx context.Context) error {
    for {
      select {
      case <-ctx.Done():
        return nil
      default:
        log.Println("working job 02")
        time.Sleep(500 * time.Millisecond)
      }
    }
  })

  // Add shutdown 01
  m.AddShutdownJob(func() error {
    log.Println("shutdown job 01 and wait 1 second")
    time.Sleep(1 * time.Second)
    return nil
  })

  // Add shutdown 02
  m.AddShutdownJob(func() error {
    log.Println("shutdown job 02 and wait 2 second")
    time.Sleep(2 * time.Second)
    return nil
  })

  <-m.Done()
}
```

透過 `AddShutdownJob` 函式可以將關閉服務前需要的工作加入，當系統收到通知時，會執行上述工作，執行完畢才會關閉服務。

## 實作細節

看完上面兩個範例，大家應該都知道如何使用 graceful 套件了，那來聊聊如何實作此套件，其實也沒有很難，透過 `os/signal` 跟 `context` 兩個內建的套件就可以完成上面功能。首先用 `os/signal` 偵測系統訊號。

```go
signal.Notify(
  c,
  syscall.SIGINT,
  syscall.SIGTERM,
  syscall.SIGTSTP,
)
```

接著建立兩個 context，其中一個是 shutdown 另一個是 done context，前者用來通知所有正在執行的工作停止，後者是讓 main 主程式進行最後的確認，確保工作都執行完後，才通知 done context

```go
type Manager struct {
  lock              *sync.RWMutex
  shutdownCtx       context.Context
  shutdownCtxCancel context.CancelFunc
  doneCtx           context.Context
  doneCtxCancel     context.CancelFunc
  logger            Logger
  runningWaitGroup  *routineGroup
  errors            []error
  runAtShutdown     []ShtdownJob
}
```

接著看看執行 graceful shutdown 函式

```go
// doGracefulShutdown graceful shutdown all task
func (g *Manager) doGracefulShutdown() {
  g.shutdownCtxCancel()
  // doing shutdown job
  for _, f := range g.runAtShutdown {
    func(run ShtdownJob) {
      g.runningWaitGroup.Run(func() {
        g.doShutdownJob(run)
      })
    }(f)
  }
  go func() {
    g.waitForJobs()
    g.lock.Lock()
    g.doneCtxCancel()
    g.lock.Unlock()
  }()
}
```

首先執行 cancel 函式通知正在執行的工作進行關閉，接著執行關閉服務前註冊的工作內容 (`doShutdownJob`)，透過 waiting group 進行最後的卡控，全部工作執行完畢後，透過 `doneCtxCancel` 來通知主程式 (`main.go`) 結束。

## 心得

會自行開發此套件最主要原因是大部分服務都需要此功能，進而把會共用的功能抽出來在寫成套件，方便開發者進行實作，。如果喜歡此套件的話，歡迎追蹤 [appleboy/graceful][3]。
