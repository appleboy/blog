---
title: "優化重構 Worker Pool 程式碼"
date: 2022-06-07T20:42:17+08:00
type: draft
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

最近看到 [Go 語言][1]一段代碼，我覺得有很大的優化空間，也將此優化的過程跟想法分享給大家，也許每個人優化的方向不同，大家可以把代碼整個看完，接著不要繼續往下看，先想看看是否有優化的空間，下述程式碼本身沒有任何問題，執行過程不會出現任何錯誤。

先說明底下案例在做什麼，相信大家都有聽過在 Go 語言內要實現 [Worker Pools][2] 機制相當簡單，看到 `ExecuteAll` 函式就是讓開發者可以自訂同時間開多少個 Goroutine 來平行執行工作，第二個參數可以自訂義工作內容是什麼。

[1]:https://go.dev
[2]:https://gobyexample.com/worker-pools

<!--more-->

## 程式代碼

```go
package executor

import (
  "context"
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

**第二個**問題就是這段代碼會 blocking 在最下面的讀取 Task 塞入 Queue 變數上，大家看到底下代碼，宣告的是根據想要開多少 Goroutine 的 buffer 大小 Channel。舉例假設使用 4 core，然後 100 個 Task，每個 Task 執行需要 10 秒，屆時塞 4 個 Task 進去 Queue 後，整個就會被 blocking。

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

先看看讀取 Task 的 goroutine for 迴圈，由於只要有一個 Task 執行錯誤，就會將錯誤設定給全域變數 `err`，但是可以看到如果有 1 萬的 Task，此迴圈後續還是將每個 Task 都讀取出來，完全沒有使用到 Context 重要的 Channel 功能。

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
