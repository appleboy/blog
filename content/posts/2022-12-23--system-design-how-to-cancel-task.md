---
title: "系統設計: 如何取消正在執行的工作任務"
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

## 使用情境

可以看到步驟一是 worker 會先發一個請求到後端服務，詢問說現在正在執行的任務是否需要取消，這邊可以用一個長連接，或許是 30 秒或 1 分鐘才斷線。步驟二是 User 從 Web UI 端按下取消的按鈕。步驟三是後端服務接受到取消任務的請求，拿到請求後，就回覆給 Worker 取消任務。

大家可以想看看這樣的情境該如何設計此流程，先不考慮多台後端服務的情境，也不考慮使用 Message Queue 的方式來實作。也許大家有想到一種方式，就是當使用者按下取消時 (到步驟三)，後端服務就將此任務的狀態改成**取消**。而 Worker 每次來詢問狀態 (步驟一)，這樣後端就在查詢一次就可以了 (步驟四)，這方式也沒有不對，但是即時性效果比較差，如果是每 30 秒輪詢一次，就有可能 30 秒後才能取消任務，輪詢時間設定很短，又會造成過多不必要的連線請求。除了這種方式外，還有沒有其他方式可以不需要查詢資料庫就可以即時讓 Worker 知道目前任務狀態。

## 單機實作方式

用 [Go 語言][3]來處理後端跟 Worker 之間的資料交換機制。可以看下圖，先實作 canceller package，裡面有兩個不同的 Method，一個是 `Cancel` 用來處裡接受使用者取消哪一筆任務，另一個是 `Cancelled` 用來接受 Worker 的請求。

[3]: https://go.dev

![cancel a task](https://i.imgur.com/TuWbShu.png)

這邊先考慮單個後端服務，設計 `canceller` 結構可以用 `map` 方式來紀錄目前有多少 worker 請求，其中 map 內的 string 用來記錄任務唯一 ID 識別。

```go
type canceler struct {
  sync.Mutex

  subsciber map[chan struct{}]string
}

func newCanceler() *canceler {
  return &canceler{
    subsciber: make(map[chan struct{}]string),
  }
}
```

接著看 worker 發送一個任務請求時，該如何實現監聽 `Cancelled` 機制。

```go
func (c *canceler) Cancelled(ctx context.Context, id string) (bool, error) {
  subsciber := make(chan struct{})
  c.Lock()
  c.subsciber[subsciber] = id
  c.Unlock()

  defer func() {
    c.Lock()
    delete(c.subsciber, subsciber)
    c.Unlock()
  }()

  for {
    select {
    case <-ctx.Done():
      return false, nil
    case <-subsciber:
      return true, nil
    }
  }
}
```

`Cancelled` 內帶有兩個參數，一個是 conetxt 另一個是任務 ID，其中 context 可以用來設計此連線多久後會自動回覆給 worker 沒有收到任何 Cancel 狀態，後者就是紀錄此任務 ID。

```go
subsciber := make(chan struct{})
c.Lock()
c.subsciber[subsciber] = id
c.Unlock()
```

上面在 map 紀錄此任務 ID 及宣告 `struct{}` 通道。等到收到 cancel 或是 context 狀態，就結束函式，並把 map 內的紀錄取消。

```go
  defer func() {
    c.Lock()
    delete(c.subsciber, subsciber)
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
  for subsciber, target := range c.subsciber {
    if id == target {
      close(subsciber)
      return nil
    }
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

  subsciber map[chan struct{}]string
+ cancelled map[string]time.Time
}
```

接下來在 `Cancel` 函式內宣告時間

```diff
func (c *canceler) Cancel(ctx context.Context, id string) error {
  c.Lock()
  defer c.Unlock()
+ c.cancelled[id] = time.Now().Add(5 * time.Minute)
  for subsciber, target := range c.subsciber {
    if id == target {
      close(subsciber)
      return nil
    }
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
  c.subsciber[subsciber] = id
  c.Unlock()

  defer func() {
    c.Lock()
    delete(c.subsciber, subsciber)
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

## 心得

本篇最主要是要用 Go 語言的 Channel 特性來處理兩個服務之間的溝通機制，大家可能想到的解法就是用 Message Queue 來處理，但是有時候把架構想的更簡單一點，用 Go 語言的特性來處理，那就減少一個服務的維運，未來要將此架構轉換到其他平台就會更簡單，其他部門有需求會是將整套服務架設在不同團隊內，這時候架構越簡單，除錯時間會越短。
