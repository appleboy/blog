---
title: "優化重構 Worker Pool 程式碼"
date: 2022-06-07T20:42:17+08:00
type: post
slug: refactor-worker-pool-source-code
share_img: https://i.imgur.com/mDJolWF.png
categories:
  - Golang
tags:
  - golang
  - worker pool
  - goroutine
---

![logo](https://i.imgur.com/mDJolWF.png)

最近看到 [Go 語言][1]一段程式碼，認為有很大的優化空間，也將過程跟想法分享給大家。也許每個人優化的方向不同，各位讀者可以把[程式碼][11]整個看完後，先停住，不要繼續往下看，想看看是否有優化的空間。此程式碼本身沒有任何問題，執行過程不會出現任何錯誤。

先說明底下範例在做什麼，相信大家都有聽過在 Go 語言內要實現 [Worker Pools][2] 機制相當簡單，看到 `ExecuteAll` 函式就是讓開發者可以自訂同時間開多少個 Goroutine 來平行執行工作，第二個參數可以自訂義工作內容是什麼。

[1]:https://go.dev
[2]:https://gobyexample.com/worker-pools

<!--more-->

## 程式碼

[線上測試看看][11]

[11]:https://go.dev/play/p/aZFiLXm16lI

```go
package main

import (
  "context"
  "errors"
  "fmt"
  "runtime"
  "sync"
)

type TaskFunc func(ctx context.Context) error

func ExecuteAll(numCPU int, tasks ...TaskFunc) error {
  var err error
  ctx, cancel := context.WithCancel(context.Background())
  defer cancel()

  wg := sync.WaitGroup{}
  wg.Add(len(tasks))

  if numCPU == 0 {
    numCPU = runtime.NumCPU()
  }
  fmt.Println("numCPU:", numCPU)
  queue := make(chan TaskFunc, numCPU)

  // Spawn the executer
  for i := 0; i < numCPU; i++ {
    go func() {
      for task := range queue {
        fmt.Println("get task")
        if err == nil {
          taskErr := task(ctx)
          if taskErr != nil {
            err = taskErr
            cancel()
          }
        }
        wg.Done()
      }
    }()
  }

  // Add tasks to queue
  for _, task := range tasks {
    queue <- task
  }
  close(queue)

  // wait for all task done
  wg.Wait()
  return err
}

func main() {
  tasks := make([]TaskFunc, 0, 100)
  for i := 0; i < 100; i++ {
    func(val int) {
      tasks = append(tasks, func(ctx context.Context) error {
        fmt.Println(val)
        if val == 51 {
          return errors.New("missing")
        }
        return nil
      })
    }(i)
  }

  err := ExecuteAll(0, tasks...)
  if err == nil {
    fmt.Println("missing error")
  }
}
```

## 三大優化方向

### 問題一

大家看完上述程式碼，是否心裡已經有想法該怎麼優化，或者是有看出什麼問題？首先我看到**第一個**疑問

```go
wg := sync.WaitGroup{}
wg.Add(len(tasks))
```

為什麼是從 Task 數量來放進去 WatiGroup，理論上我們是要控制開多少個 Goroutine，而不是將 Task 數量全部執行完畢，才結束程式。

### 問題二

**第二個**問題就是這段代碼會 blocking 在最下面的讀取 Task 塞入 Queue 變數上，大家看到底下代碼，宣告的是根據想要開多少 Goroutine 的 buffer 大小 Channel。舉例假設使用 4 core，然後 100 個 Task，每個 Task 執行需要 10 秒，此時塞 4 個 Task 進去 Queue 後，會被順利讀取出來 4 個 task，接著 Queue 又被塞滿 4 個 task 後，就無法再繼續將新的 Task 放入，故程式就會被 blocking。

```go
 queue := make(chan TaskFunc, numCPU)
//
// 中間省略一堆代碼
//
//
// Add tasks to queue
for _, task := range tasks {
  queue <- task
}
close(queue)

// wait for all task done
wg.Wait()
```

### 問題三

先看看讀取 Task 的 goroutine for 迴圈，由於只要有一個 Task 執行錯誤，就會將錯誤設定給全域變數 `err`，但是可以看到如果有 1 萬的 Task，此迴圈後續還是將每個 Task 都讀取出來，完全沒有使用到 Context 重要的 Channel 功能。更多 Context 用法可以參考這篇『[用 10 分鐘了解 Go 語言 context package 使用場景及介紹][31]』

[31]:https://blog.wu-boy.com/2020/05/understant-golang-context-in-10-minutes/

```go
  go func() {
    for task := range queue {
      fmt.Println("get task")
      if err == nil {
        taskErr := task(ctx)
        if taskErr != nil {
          err = taskErr
          cancel()
        }
      }
      wg.Done()
    }
  }()
```

## 重構流程

### 改寫 sync.WaitGroup 使用方式

根據上面提到的三個問題，底下來一一解決，首先這段程式碼目的是開多個平行化處理的 Goroutine，故結束前必須要等待全部 Goroutine 執行完成才讓主程式繼續往下走，所以使用 `sync.WaitGroup` 可以改成根據目前設定多少平行處理來決定

```go
if numCPU == 0 {
  numCPU = runtime.NumCPU()
}

wg := sync.WaitGroup{}
wg.Add(numCPU)
```

### 改寫 buffer channel 大小

上面有提到 Channel 大小原本使用要同步處理多少工作當作 Buffer 大小，但是只要 Task 數量大於 Buffer 大小，就會出現 blocking，故這邊可以改成底下

```go
queue := make(chan TaskFunc, len(tasks))

// Add tasks to queue
for _, task := range tasks {
  queue <- task
}
close(queue)
```

將 Buffer 大小改成跟 Task 數量一致，藉此透過 for 迴圈先將 Task 塞到 Channel 內，並關閉 Channel 即可。

### 讀取 Task 流程

此函式目的就是平行跑多個 Task，遇到任何錯誤，就中斷流程，並返回錯誤訊息，故需要透過 Context Cancel 特性來改寫原本流程

```go
for i := 0; i < numCPU; i++ {
  go func() {
    defer wg.Done()
    for {
      select {
      case task, ok := <-queue:
        if ctx.Err() != nil || !ok {
          return
        }
        fmt.Println("get task")
        if e := task(ctx); e != nil {
          err = e
          cancel()
        }
      case <-ctx.Done():
        return
      }
    }
  }()
}
```

當 Task 出現錯誤時，會將錯誤訊息放到全域變數 err 內，並且執行 `cancel()`，此時 for 在讀取下一個 Job 時，就可以透過 `<-ctx.Done()` 或 `ctx.Err()` 方式來終止程式執行，這樣才不會多跑了很多次迴圈

## 心得

Worker Pool 網路上寫法千奇百種，優化的方式每個人想的也是不一樣，透過這樣的練習可以加深自己對於 Go Channel 特性。原本的程式碼都可以正常執行沒問題，只是看到覺得有幾個地方可以優化，故寫在這邊紀錄重構想法，可以讓剛入門 Go 語言的朋友們參考。
