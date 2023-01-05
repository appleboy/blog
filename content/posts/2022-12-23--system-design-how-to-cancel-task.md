---
title: "用 Go 語言實作如何取消正在執行的工作任務 (一)"
date: 2022-12-23T08:32:31+08:00
author: appleboy
type: post
slug: system-design-how-to-cancel-a-running-task-in-golang
share_img: https://i.imgur.com/VZyfv0M.png
categories:
  - Golang
  - System Design
---

![cancel a task](https://i.imgur.com/VZyfv0M.png)

本篇來聊聊『如何取消正在執行的工作任務』，當系統內有需要處理比較久或較多資源的任務，肯定會將這些任務丟到其他機器再執行，執行過程如果需要取消，會經過如上圖幾個步驟。先假設中間的過程不透過 Message Queue 機制，而是兩個服務進行溝通透過 [RESTful][1] 或 [gRPC][2] 方式。

[1]:https://aws.amazon.com/tw/what-is/restful-api/
[2]:https://grpc.io/

<!--more-->

## 教學影片

{{< youtube tj95O--us70 >}}

```sh
00:00 情境介紹
02:08 設計問題優缺點
03:44 單機版本實現方式
06:04 worker 連線請求
08:44 User 取消任務請求
12:24 worker 斷線跟如何處理?
13:26 解決方式 (設計 Timeout 機制)
15:52 清除 map 不必要資訊
17:47 實作後心得
```

其他線上課程請參考如下

* [Docker 容器實戰](https://blog.wu-boy.com/docker-course/)
* [Go 語言課程](https://blog.wu-boy.com/golang-online-course/)

## 使用情境

可以看到步驟一是 worker 會先發請求到後端服務，詢問目前正在執行的任務是否取消，這邊可以用一個長連接持續 30 秒或 1 分鐘才斷線。步驟二是 User 從 Web UI 端按下取消的按鈕。步驟三是後端服務接受到取消任務的請求，就回覆 Worker 到請求執行取消任務。

大家可以想看看此情境該如何設計流程，先不考慮多台後端服務的情境，也不考慮使用 Message Queue 的方式來實作。也許大家有想到一種方式，就是當使用者按下取消時 (到步驟三)，後端服務將此任務的狀態改成**取消**。而 Worker 每次來詢問狀態 (步驟一)，後端就再查詢一次就可以了 (步驟四)，這方式也沒有不對，只是即時性效果比較差，如果是每 30 秒輪詢一次，就有可能 30 秒後才能取消任務，輪詢時間設定很短，又會造成過多不必要的連線請求。除了這種方式外，還有沒有其他方式可以不需要查詢資料庫就可以即時讓 Worker 知道目前任務狀態。

## 單機實作方式

用 [Go 語言][3]來處理後端跟 Worker 之間的資料交換機制。可以看下圖，先實作 canceller package，裡面有兩個不同的 Method，一個是 `Cancel` 用來處裡使用者取消哪一筆任務，另一個是 `Cancelled` 用來接受 Worker 的連線請求。

[3]: https://go.dev

![cancel a task](https://i.imgur.com/TuWbShu.png)

這邊先考慮單個後端服務，為什麼先只考慮單個後端呢？原因就是底下的解法只適合在單一後端下才可以，多個後端會造成資料不同步問題。設計 `canceller` 結構可以用 `map` 方式來紀錄目前有多少 worker 請求，其中 map 內的 string 用來記錄任務唯一 ID 識別。

```go
type canceler struct {
  sync.Mutex

  subsciber map[string]chan struct{}
}

func newCanceler() *canceler {
  return &canceler{
    subsciber: make(subsciber map[string]chan struct{}),
  }
}
```

接著看 worker 發送一個任務請求時，該如何實現監聽 `Cancelled` 機制。

```go
func (c *canceler) Cancelled(ctx context.Context, id string) (bool, error) {
  subsciber := make(chan struct{})
  c.Lock()
  c.subsciber[id] = subsciber
  c.Unlock()

  defer func() {
    c.Lock()
    delete(c.subsciber, id)
    c.Unlock()
  }()

  select {
  case <-ctx.Done():
    return false, nil
  case <-subsciber:
    return true, nil
  }
}
```

`Cancelled` 內帶有兩個參數，一個是 conetxt 另一個是任務 ID，其中 context 可以用來設計此連線多久後會自動回覆給 worker 沒有收到任何 Cancel 狀態，後者就是紀錄此任務 ID。

```go
subsciber := make(chan struct{})
c.Lock()
c.subsciber[id] = subsciber
c.Unlock()
```

上面在 map 紀錄此任務 ID 及宣告 `struct{}` 通道。等到收到 cancel 或是 context 狀態，就結束函式，並把 map 內的紀錄取消。

```go
  defer func() {
    c.Lock()
    delete(c.subsciber, id)
    c.Unlock()
  }()

  select {
  case <-ctx.Done():
    return false, nil
  case <-subsciber:
    return true, nil
  }
```

最後來實現 User 怎麼觸發 `Cancel` 機制，就是透過上面 map 內的 struct channel 來完成。

```go
func (c *canceler) Cancel(ctx context.Context, id string) error {
  c.Lock()
  defer c.Unlock()
  if sub, ok := c.subsciber[id]; ok {
    close(sub)
  }
  return nil
}
```

用 for 迴圈來掃 c.subsciber 所有任務是否有比對成功，比對成功後，就將 subsciber channel 關閉，這樣在 `Cancelled` 內就會觸發 channel 通知。最後寫了兩個測試證明這方法是可以正常運作，第一個是透過 User 觸發取消任務

```go
func TestUserCancelTask(t *testing.T) {
  var canceled bool
  var err error
  engine := newCanceler()
  stop := make(chan struct{})
  go func() {
    canceled, err = engine.Cancelled(context.Background(), "test123456")
    stop <- struct{}{}
  }()
  time.Sleep(1 * time.Second)
  engine.Cancel(context.Background(), "test123456")
  <-stop

  if !canceled {
    t.Fatal("can't cancel task")
  }
  if err != nil {
    t.Fatal("get error")
  }
}
```

另一個是使用 context 搭配 cancel event 來結束函式

```go
func TestContextCancelTask(t *testing.T) {
  var canceled bool
  var err error
  engine := newCanceler()
  stop := make(chan struct{})

  ctx, cancel := context.WithCancel(context.Background())

  go func() {
    canceled, err = engine.Cancelled(ctx, "test123456")
    stop <- struct{}{}
  }()
  cancel()
  <-stop

  if canceled {
    t.Fatal("detect cancel task")
  }
  if err != nil {
    t.Fatal("get error")
  }
}
```

## 遇到問題

![cancel a task](https://i.imgur.com/myG5y8I.png)

服務之間溝通時，總是會遇到服務斷線的問題，假設全部 worker 都跟後端失去連線，這時候 User 觸發了取消任務，這時候上述代碼要如何調整才能讓 worker 恢復連線後又可以正常拿到取消任務的命令？

其實很簡單，只需要一個簡單的 Timeout 機制，User 按下取消時，先以當下時間加上 `5 分鐘`，這 5 分鐘是什麼意思呢？也就是 worker 必須在這 5 分鐘內重新連上後端服務才可以正常拿到 cancel 事件，所以在 canceller 內加上 map 存取所有任務時間資訊。大家請注意這 5 分鐘數字，你可以根據自家系統流程而改變。

```diff
type canceler struct {
  sync.Mutex

  subsciber map[string]chan struct{}
+ cancelled map[string]time.Time
}
```

接下來在 `Cancel` 函式內宣告時間

```diff
func (c *canceler) Cancel(ctx context.Context, id string) error {
  c.Lock()
  defer c.Unlock()
+ c.cancelled[id] = time.Now().Add(5 * time.Minute)
  if sub, ok := c.subsciber[id]; ok {
    close(sub)
  }
+ c.clear()
  return nil
}
```

最後請在 `Cancelled` 函式內補上底下判斷該任務是否存在

```diff
func (c *canceler) Cancelled(ctx context.Context, id string) (bool, error) {
  subsciber := make(chan struct{})
  c.Lock()
  c.subsciber[id] = subsciber
  c.Unlock()

  defer func() {
    c.Lock()
    delete(c.subsciber, id)
    c.Unlock()
  }()

+ c.Lock()
+ _, ok := c.cancelled[id]
+ c.Unlock()
+ if ok {
+   return true, nil
+ }

  select {
  case <-ctx.Done():
    return false, nil
  case <-subsciber:
    return true, nil
  }
}
```

除了解決上述問題外，也要想想怎麼定時清除 `c.cancelled` 多餘的資訊，避免任務要重新執行時，直接馬上收到 cancel event.

```go
func (c *canceler) clear() {
  now := time.Now()
  for k, trigger := range c.cancelled {
    if now.After(trigger) {
      delete(c.cancelled, k)
    }
  }
}
```

最後補上測試，先執行 `Cancel` 代表 User 取消執行的任務，接著 Worker 發送請求詢問，由於我們有給 5 分鐘緩衝，所以時間內都可以拿到取消任務的指令。

```go
func TestUserCancelTaskFirst(t *testing.T) {
  var canceled bool
  var err error
  engine := newCanceler()

  // User cancel task first and
  _ = engine.Cancel(context.Background(), "test1234")
  canceled, err = engine.Cancelled(context.Background(), "test1234")

  if !canceled {
    t.Fatal("can't get cancel event")
  }
  if err != nil {
    t.Fatal("get error")
  }
}
```

## 心得

本篇最主要是要用 Go 語言的 Channel 特性來處理兩個服務之間的溝通機制，大家可能想到的解法就是用 Message Queue 來處理，但是有時候把架構想的更簡單一點，用 Go 語言的特性來處理，那就減少一個服務的維運，未來要將此架構轉換到其他平台就會更簡單，其他部門有需求會是將整套服務架設在不同團隊內，這時候架構越簡單，除錯時間會越短。最後附上[程式碼](https://github.com/go-training/training/tree/master/example51-canceler/schedule)，大家可以直接取用試試看。

接下來會介紹關於如何實現 HTTP Server 跟 Worker 的代碼，有興趣可以繼續往下看『[系統設計: 建立 Web 及 Worker 服務實現取消任務 (二)](https://blog.wu-boy.com/2023/01/create-server-and-worker-for-cancel-task-in-golang/)』。
