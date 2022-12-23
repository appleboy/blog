---
title: "系統設計: 處理服務讀取多個任務遇到的問題 (Go 語言)"
date: 2022-11-13T08:23:09+08:00
author: appleboy
type: post
slug: simple-scheduler-with-multiple-worker-using-golang
share_img: https://i.imgur.com/lbY6KzL.png
categories:
  - Golang
  - System Design
---

![system design 02](https://i.imgur.com/lbY6KzL.png)

不同的服務都會有需要處理比較久的任務，這些任務是不能即時執行完成，才回應給前端，這樣使用者體驗會非常的差。將類型的任務存在資料庫或放在[消息對列][1]就是一種處理方式，接著啟動另一個服務來消化非即時性的任務，而常見的處理方式就是在服務內啟動多個 Worker Node 來平行消化任務 (如上圖)。

[1]:https://zh.m.wikipedia.org/zh-hant/%E6%B6%88%E6%81%AF%E9%98%9F%E5%88%97

<!--more-->

## 教學影片

{{< youtube Sh9hN635j50 >}}

```sh
00:00 問題描述
02:52 如何用 Go 語言寫出多個 Worker
04:09 執行結果及問題展示
05:00 優化多個請求變成單一個
05:52 新增 Metric struct 用來記錄多少 Worker Node 執行中
06:41 設計 ready channel 判斷是否有新的 Worker Node
09:00 總結流程步驟
11:25 最終執行成果
```

其他線上課程請參考如下

* [Docker 容器實戰](https://blog.wu-boy.com/docker-course/)
* [Go 語言課程](https://blog.wu-boy.com/golang-online-course/)

## 讀取多個任務問題

先看看底下此服務內部的設計，用 [Go 語言][11]來當範例解釋當下問題，假設 Task 服務負責存放所有的任務，而 Agent 服務內可以開啟多個 Goroutine 來平行消化任務，步驟也很簡單，第一步就去讀取任務，而第二步就是執行。在步驟一時，設計每 5 秒才向 Task 服務詢問是否有新任務需要執行，時間區隔避免頻繁發請求給 Task 服務。

[11]:https://go.dev

先假設有 100 個任務需要等待執行，在 Agent 內開啟 10 個 Worker Node 去消化，這樣每次就會發送 10 個請求，而這 10 個請求有可能對於 Task 服務來說就是 10 個 SQL 指令，如果是 10 台 Agent 就變成 100 個請求，這樣對於 Task 服務來說會負擔太大。

![system design 01](https://i.imgur.com/4csL9To.png)

大家可以想看看如何解決上述的問題，底下提供一段 Go 語言實作多個 Worker 的代碼，步驟一就是開啟 Goroutine 來平行處理任務，就是在這邊會發送大量的請求到另一個 Task 服務

```go
type Poller struct {
  routineGroup *routineGroup
  workerNum    int
}

func (p *Poller) Poll(ctx context.Context) error {
  for i := 0; i < p.workerNum; i++ {
    // step01
    p.routineGroup.Run(func() {
      for {
        select {
        case <-ctx.Done():
          return
        default:
          // step02
          task, err := p.fetch(ctx)
          if err != nil {
            log.Println("can't get task", err.Error())
            break
          }

          // step03
          if err := p.execute(ctx, task); err != nil {
            log.Println("execute task error:", err.Error())
          }
        }
      }
    })
  }
  p.routineGroup.Wait()
  return nil
}
```

## 改善系統設計

為了解決不要發送大量的請求，我們可以在最前面多設計一個 Scheduler 來確保一次只讀取一個任務後，才繼續執行下一個讀取任務。大家可以看看底下的設計圖

![system design 02](https://i.imgur.com/lbY6KzL.png)

從上面的設計圖，我們需要在 Poller 的 struct 內紀錄目前有多少個 Worker Node 正在執行，故新增一個 Metric struct 來記錄這些資訊

```go
type metric struct {
  busyWorkers uint64
}

// newMetric for default metric structure
func newMetric() *metric {
  return &metric{}
}

func (m *metric) IncBusyWorker() uint64 {
  return atomic.AddUint64(&m.busyWorkers, 1)
}

func (m *metric) DecBusyWorker() uint64 {
  return atomic.AddUint64(&m.busyWorkers, ^uint64(0))
}

func (m *metric) BusyWorkers() uint64 {
  return atomic.LoadUint64(&m.busyWorkers)
}
```

有了上述資訊後，接著在 Poller 內多新增一個 ready channel 用來判斷是否有新的 Worker 可以分配。所以在初始化的 for 迴圈內需要判斷是否有新的 Worker Node 可以執行。

```go
func (p *Poller) schedule() {
  p.Lock()
  defer p.Unlock()
  if int(p.metric.BusyWorkers()) >= p.workerNum {
    return
  }

  select {
  case p.ready <- struct{}{}:
  default:
  }
}
```

接著改寫整體 Poll 函示，多寫一個 for 迴圈來判斷是否有新的 Worker Node

```go
func (p *Poller) Poll(ctx context.Context) error {
  // scheduler
  for {
    // step01
    p.schedule()

    select {
    case <-p.ready:
    case <-ctx.Done():
      return nil
    }

  LOOP:
    for {
      select {
      case <-ctx.Done():
        break LOOP
      default:
        // step02
        task, err := p.fetch(ctx)
        if err != nil {
          log.Println("fetch task error:", err.Error())
          break
        }
        p.metric.IncBusyWorker()
        // step03
        p.routineGroup.Run(func() {
          if err := p.execute(ctx, task); err != nil {
            log.Println("execute task error:", err.Error())
          }
        })
        break LOOP
      }
    }
  }
}
```

可以看到流程步驟會變成底下

1. 判斷使否有新的 Worker Node 可以執行
2. 單一 Worker Node 讀取是否有新任務
3. 如果有新的任務，則紀錄 Worker Node + 1
4. 返回步驟一

只要任何任務完成後，就將 Worker Node 數量再減一，並重新執行 `p.schedule()`，確保 ready channel 不為空。

```go
func (p *Poller) execute(ctx context.Context, task string) error {
  defer func() {
    p.metric.DecBusyWorker()
    p.schedule()
  }()
  return nil
}
```

## 心得

上述測試的代碼可以直接[參考這邊][22]，也許大家有其他方式可以解決此問題，像是用 Message Queue 避免大量請求也是一種解決方案，只是如果能不起另一種服務是最好的，畢竟團隊內有時候需要將整套流程打包放到客戶端環境，多起一種服務，這樣要除錯又更不方便了。

[22]:https://github.com/go-training/training/tree/master/example50-consumer-producer-pattern
