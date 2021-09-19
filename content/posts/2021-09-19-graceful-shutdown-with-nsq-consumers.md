---
title: "NSQ Consumers 處理 Graceful Shutdown 技巧"
date: 2021-09-19T14:50:42+08:00
author: appleboy
type: post
url: /2021/09/graceful-shutdown-with-nsq-consumers
share_img: https://i.imgur.com/i98snGt.png
categories:
  - Golang
tags:
  - NSQ
  - graceful shutdown
  - queue
---

![Imgur](https://i.imgur.com/i98snGt.png)

[NSQ][1] 是一套即時分散式處理消息平台，目的在於提供大量的訊息傳遞，團隊可以依據不同的任務來設計分散式架構去消化大量的訊息。而我在最近開發了一套開源項目 [golang-queue/queue][2]，這套詳細的資訊會再開另一篇進行討論，簡單來說這個套件可以讓開發者用在單機的 Producer 及 Consumer 架構，使用的就是 [Go 語言][3]的 Goroutine 及 Channel，又或者直接搭配 [NSQ][1], [NATs][4] 或 [Redis Pub/Sub][5] 第三方的系統取代內建的 Channel 機制。而本篇會講在整合 NSQ 要處理 [Graceful Shutdown][6] 所遇到的問題跟解決方式。

[1]:https://nsq.io/
[2]:https://github.com/golang-queue/queue
[3]:https://golang.org
[4]:https://nats.io/
[5]:https://redis.io/topics/pubsub
[6]:https://blog.wu-boy.com/2020/02/what-is-graceful-shutdown-in-golang/

<!--more-->

## 整合問題

> 為什麼開發者還要自行去處理 NSQ Consumers 的 Graceful Shutdown 機制？

大家是不是有個疑問，這個感覺應該是在 NSQ 系統內自行處理完畢，但是實際上就是要透過處理 System Signals，來決定何時讓 Consumers 可以結束處理，最後關閉服務。如果不懂什麼是 Graceful Shutdown 的朋友們，可以看一下[這篇介紹][6]。底下我們來討論看看整個流程會是什麼樣子？

當系統收到通知

1. 通知 Consumer 不要處理新的 Message
2. 等到所有的 Worker 都處理完手受 Message
3. 正常關閉 NSQ Consumer 服務

先看看如何宣告 NSQ Consumer，[程式碼在這邊](https://github.com/golang-queue/nsq/blob/19c59b9c063ced2d6cfc9f404f7ab69be73ad795/nsq.go#L22-L37)

```go
// Worker for NSQ
type Worker struct {
  q           *nsq.Consumer
  p           *nsq.Producer
  startOnce   sync.Once
  stopOnce    sync.Once
  stop        chan struct{}
  maxInFlight int
  addr        string
  topic       string
  channel     string
  runFunc     func(context.Context, queue.QueuedMessage) error
  logger      queue.Logger
  stopFlag    int32
  startFlag   int32
  busyWorkers uint64
}
```

其中 `maxInFlight` 是讓開發者決定併發的數量。而 Handler 怎麼寫呢？

```go
// Run start the worker
func (w *Worker) Run() error {
  wg := &sync.WaitGroup{}
  panicChan := make(chan interface{}, 1)
  w.q.AddHandler(nsq.HandlerFunc(func(msg *nsq.Message) error {
    wg.Add(1)
    defer func() {
      wg.Done()
      if p := recover(); p != nil {
        panicChan <- p
      }
    }()

    if len(msg.Body) == 0 {
      // Returning nil will automatically send a FIN command to NSQ to mark the message as processed.
      // In this case, a message with an empty body is simply ignored/discarded.
      return nil
    }

    var data queue.Job
    _ = json.Unmarshal(msg.Body, &data)
    return w.handle(data)
  }))

  // wait close signal
  select {
  case <-w.stop:
  case err := <-panicChan:
    w.logger.Error(err)
  }

  // wait job completed
  wg.Wait()

  return nil
}
```

這邊透過 WaitGroup 來控制此 Worker 需要等待 Message 處理完成後，才可以正常關閉，而底下看看處理 Shutdown 部分

```go
// Shutdown worker
func (w *Worker) Shutdown() error {
  if !atomic.CompareAndSwapInt32(&w.stopFlag, 0, 1) {
    return queue.ErrQueueShutdown
  }

  w.stopOnce.Do(func() {
    if atomic.LoadInt32(&w.startFlag) == 1 {
      w.q.Stop()
      w.p.Stop()
    }

    close(w.stop)
  })
  return nil
}
```

其中 `w.q.Stop()` 就是將 consumer 停止運作。看上面程式碼似乎沒有什麼破綻，那我們來寫個 Handle Func 每個 Message 處理 10 秒鐘，把 `maxInFlight` 設定為 `2` 個，也就是當有兩個 worker 正在處理 2 個 Job，而會有另外的 Job 正在等待。

底下看看怎麼跑出問題的:

```sh
3:30PM INF start the worker num: 2
3:30PM INF start the worker num: 1
2021/09/19 15:30:09 INF    1 [tip-io/upload] (localhost:4150) connecting to nsqd
3:30PM INF new message uuid=fc848b13-0e4f-4c6f-b5b8-2ba5b73b99c5
3:30PM INF new message uuid=9aee6919-8dd2-408c-bbf4-27a30b3c6faa
^C3:30PM INF interrupt received, terminating process
3:30PM INF shutdown all woker numbers: 2
2021/09/19 15:30:45 INF    1 [tip-io/upload] stopping...
2021/09/19 15:30:45 INF    2 stopping

3:30PM INF stop the worker num: 2
3:30PM INF new message uuid=82045daa-b915-432e-b9d4-8f394d3d07c0

2021/09/19 15:30:49 INF    1 [tip-io/upload] (localhost:4150) received CLOSE_WAIT from nsqd
3:30PM INF new message uuid=bf00f719-1381-471e-9008-8d75dfb5e24c
3:30PM ERR sync: WaitGroup is reused before previous Wait has returned
2021/09/19 15:30:49 WRN    1 [tip-io/upload] (localhost:4150) delaying close, 2 outstanding messages
2021/09/19 15:30:49 INF    1 [tip-io/upload] (localhost:4150) readLoop exiting
3:30PM INF restart the new worker: 1
3:30PM INF server has been shutdown.
```

大家可以看到底下關鍵的訊息

```sh
WaitGroup is reused before previous Wait has returned
```

## NSQ MaxInFlight 設定

NSQ 會根據目前的連線數量以及 `MaxInFlight` 設定值來決定現在可以有多少個 Message 同時處理，而出現上述的問題點會是，當 Consumer 處理完手上 Job 後，此時 WaitGroup 已經結束，但是 NSQ Handler 還沒結束，繼續處理下一個 Message，所以在 `wg.Add` 時就會噴出這個錯誤，為了解決這問題，我們需要完全等到 NSQ Handler 都處理完畢，才可以將 stop channel 關閉。

所以將 `Shutdown` 函式[改成如下](https://github.com/golang-queue/nsq/compare/v0.0.3...v0.0.4):

```go
func (w *Worker) Shutdown() error {
  if !atomic.CompareAndSwapInt32(&w.stopFlag, 0, 1) {
    return queue.ErrQueueShutdown
  }

  w.stopOnce.Do(func() {
    if atomic.LoadInt32(&w.startFlag) == 1 {
      w.q.ChangeMaxInFlight(0)
      w.q.Stop()
      <-w.q.StopChan
      w.p.Stop()
    }

    close(w.stop)
  })
  return nil
}
```

先將 `MaxInFlight` 設定為零，也就是將整個 Message Flow 停止，不再讓 Consumer 可以繼續處理後續的 Message，最後在讀取 Consumer StopChan，確認所有的 Hander 都處理完畢，才真正關閉服務。

## 訊息丟回隊列

上面修正後，還是有個問題點，就是當 2 個 worker 處理完手受的 Message 後，由於我們先將 MaxInFlight 設定為零了，但是在 Handler 手上還是會有一個需要處理，假設這個任務需要處理很久，這樣整個服務都需要多等個幾分鐘才可以關閉，所以這時候就需要將新的任務重新丟回到原本的 Queue 內，等到下一個新的 Handler 才來處理。

```diff
  w.q.AddHandler(nsq.HandlerFunc(func(msg *nsq.Message) error {
    wg.Add(1)
    defer func() {
      wg.Done()
      if p := recover(); p != nil {
        panicChan <- p
      }
    }()

+   // re-queue the job if worker has been shutdown.
+   if atomic.LoadInt32(&w.stopFlag) == 1 {
+     msg.Requeue(-1)
+     return nil
+   }

    if len(msg.Body) == 0 {
      // Returning nil will automatically send a FIN command to NSQ to mark the message as processed.
      // In this case, a message with an empty body is simply ignored/discarded.
      return nil
    }
    var data queue.Job
    _ = json.Unmarshal(msg.Body, &data)
    return w.handle(data)
  }))
```

## 心得

正確的關閉服務，才可以讓系統穩定不會出現奇怪問題，也可以讓工程團隊專心處理程式邏輯，不用擔心部署上面會遇到什麼問題。之後會詳細寫一篇怎麼使用 [golang-queue/queue][2] 套件，讓系統不會產生大量的 goroutine 而發生效能上的問題。
