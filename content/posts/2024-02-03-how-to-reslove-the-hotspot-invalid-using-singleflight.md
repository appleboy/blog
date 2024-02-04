---
title: "在 Go 語言用 singleflight 解決快取擊穿 (Cache Hotspot Invalid)"
date: 2024-02-03T14:19:13+08:00
author: appleboy
type: post
slug: how-to-reslove-the-hotspot-invalid-using-singleflight
share_img: /images/2024-02-03/cache-hotspot-invalid.png
categories:
- golang
---

![photo](/images/2024-02-03/cache-hotspot-invalid.png)

上圖是在實作 Web 服務時常用的架構，會在服務跟資料庫之間加上快取，以減少資料庫的負載。然而在實作服務串接時，常常會遇到快取三大問題：[雪崩、擊穿、穿透][1]，其中 Cache Hotspot Invalid (快取擊穿) 是一個非常常見的問題，當快取中的資料過期或消失時，大量的請求會同時打到後端資料庫，這會導致資料庫的負載過大，甚至會導致資料庫掛掉，如下圖某篇文章的 cache key過期。這篇文章將會介紹如何使用 [Go 語言][2]內建的 [singleflight][3] 來解決快取擊穿的問題，這是 [sync][4] 套件中的一個功能，可以避免重複的請求同時打到後端資料庫。

![photo](/images/2024-02-03/cache-missing.png)

[1]: https://totoroliu.medium.com/redis-%E5%BF%AB%E5%8F%96%E9%9B%AA%E5%B4%A9-%E6%93%8A%E7%A9%BF-%E7%A9%BF%E9%80%8F-8bc02f09fe8f
[2]: https://go.dev
[3]: https://pkg.go.dev/golang.org/x/sync/singleflight
[4]: https://pkg.go.dev/golang.org/x/sync

<!--more-->

## 模擬快取擊穿

我們寫個簡單範例來模擬快取擊穿的問題。用 Go 語言 map 函式來簡單實現快取機制，並且將資料放到快取中，這樣下次再次撈取相同的資料時，就可以直接從快取中取得。

```go
package main

import "sync"

type Cache struct {
  sync.Mutex
  entries map[int]*Article
}

func (c *Cache) Get(id int) *Article {
  if _, ok := c.entries[id]; !ok {
    return nil
  }
  c.Lock()
  defer c.Unlock()
  return c.entries[id]
}

func (c *Cache) Set(id int, article *Article) {
  c.Lock()
  defer c.Unlock()
  c.entries[id] = article
}

func NewCache() *Cache {
  return &Cache{
    entries: make(map[int]*Article),
  }
}
```

接著用 [goroutine][11] 來模擬多個請求同時撈取快取中的資料，這樣就可以看到快取擊穿的問題。

[11]: https://go.dev/tour/concurrency/1

```go
package main

import (
  "log/slog"
  "sync"
)

type Article struct {
  ID      int
  Content string
}

func main() {
  db := &DB{
    cache: NewCache(),
  }

  var wg sync.WaitGroup
  wg.Add(5)
  for i := 0; i < 5; i++ {
    go func(req int) {
      defer wg.Done()
      data := db.GetArticle(req, 1)
      slog.Info("data info", "data", data, "req", req)
    }(i)
  }
  wg.Wait()
}

type DB struct {
  cache *Cache
}

func (db *DB) GetArticle(req int, id int) *Article {
  data := db.cache.Get(id)
  if data != nil {
    slog.Info("cache hit", "id", id, "req", req)
    return data
  }

  slog.Info("missing cache", "id", id, "req", req)
  data = &Article{
    ID:      id,
    Content: "FooBar",
  }
  db.cache.Set(id, data)
  time.Sleep(100 * time.Millisecond)

  return data
}
```

底下是執行結果，可以看到有 3 次 missing cache，這表示有 3 次請求同時打到後端資料庫，剩下的 2 次是 cache hit。這就是快取擊穿的問題，正常來說要避免超過 1 次存取資料庫，這樣可以有效保護後端資料庫。

```sh
2024/02/04 08:28:48 INFO missing cache id=1 req=4
2024/02/04 08:28:48 INFO missing cache id=1 req=0
2024/02/04 08:28:48 INFO cache hit id=1 req=3
2024/02/04 08:28:48 INFO cache hit id=1 req=2
2024/02/04 08:28:48 INFO data info data="&{ID:1 Content:FooBar}" req=3
2024/02/04 08:28:48 INFO missing cache id=1 req=1
2024/02/04 08:28:48 INFO data info data="&{ID:1 Content:FooBar}" req=2
2024/02/04 08:28:48 INFO data info data="&{ID:1 Content:FooBar}" req=0
2024/02/04 08:28:48 INFO data info data="&{ID:1 Content:FooBar}" req=1
2024/02/04 08:28:48 INFO data info data="&{ID:1 Content:FooBar}" req=4
```

## 使用 singleflight 解決快取擊穿

接著我們來使用 [singleflight][3] 來解決快取擊穿的問題。這個套件可以避免重複的請求同時打到後端資料庫。先看正確的結果要如下

```sh
2024/02/03 21:42:29 INFO missing cache id=1 req=1
2024/02/03 21:42:29 INFO data info data="&{ID:1 Content:FooBar}" req=1
2024/02/03 21:42:29 INFO data info data="&{ID:1 Content:FooBar}" req=2
2024/02/03 21:42:29 INFO data info data="&{ID:1 Content:FooBar}" req=3
2024/02/03 21:42:29 INFO data info data="&{ID:1 Content:FooBar}" req=4
2024/02/03 21:42:29 INFO data info data="&{ID:1 Content:FooBar}" req=0
```

只會看到一次 missing cache，其他的都是從快取中取得資料。底下看看怎麼用 singleflight 來解決問題。底下是存取 DB 的程式碼。

```go
  slog.Info("missing cache", "id", id, "req", req)
  data = &Article{
    ID:      id,
    Content: "FooBar",
  }
  db.cache.Set(id, data)
```

該怎麼改寫成使用 singleflight 來解決快取擊穿的問題呢？底下是修改後的程式碼。

```go
type DB struct {
  cache  *Cache
  engine singleflight.Group
}

func (db *DB) GetArticleDo(req int, id int) *Article {
  data := db.cache.Get(id)
  if data != nil {
    slog.Info("cache hit", "id", id, "req", req)
    return data
  }

  key := fmt.Sprintf("article:%d", id)
  row, err, _ := db.engine.Do(key, func() (interface{}, error) {
    slog.Info("missing cache", "id", id, "req", req)
    data := &Article{
      ID:      id,
      Content: "FooBar",
    }
    db.cache.Set(id, data)
    return data, nil
  })

  if err != nil {
    slog.Error("singleflight error", "err", err)
    return nil
  }

  return row.(*Article)
}
```

可以看到我們將原本的 `db.cache.Set` 改成使用 `singleflight.Group` 來包裝起來，這樣就可以避免重複的請求同時打到後端資料庫。

除了使用 Do 之外，各位有沒有想過如果同時 100 個請求同時撈取快取中的資料，但是讀取資料庫的連線需要花更多時間處理？但是我們又想設定一個超時機制避免過多的請求持續等待。這時候我們可以使用 `singleflight.Group` 的 `DoChan` 來解決這個問題。底下是修改後的程式碼。

```go
func (db *DB) GetArticleDoChan(req int, id int, t time.Duration) *Article {
  data := db.cache.Get(id)
  if data != nil {
    slog.Info("cache hit", "id", id, "req", req)
    return data
  }

  key := fmt.Sprintf("article:%d", id)
  dataChan := db.engine.DoChan(key, func() (interface{}, error) {
    slog.Info("missing cache", "id", id, "req", req)
    data := &Article{
      ID:      id,
      Content: "FooBar",
    }
    db.cache.Set(id, data)
    time.Sleep(115 * time.Millisecond)
    return data, nil
  })

  select {
  case <-time.After(t):
    slog.Info("timeout", "id", id, "req", req)
    return nil
  case res := <-dataChan:
    return res.Val.(*Article)
  }
}
```

在 main.go 主程式改成如下

```go
  wg.Add(5)
  for i := 10; i < 15; i++ {
    go func(req int) {
      defer wg.Done()
      t := time.Duration(time.Duration(int64(req*10)) * time.Millisecond)
      data := db.GetArticleDoChan(req, 3, t)
      slog.Info("data info", "data", data, "req", req)
    }(i)
  }
  wg.Wait()
```

結果如下，可以看到 req=10, 11 等待超過 100ms, 110ms 後，就會直接反回 nil。

```sh
2024/02/03 23:00:45 INFO missing cache id=3 req=11
2024/02/03 23:00:45 INFO timeout id=3 req=10
2024/02/03 23:00:45 INFO data info data=<nil> req=10
2024/02/03 23:00:45 INFO timeout id=3 req=11
2024/02/03 23:00:45 INFO data info data=<nil> req=11
2024/02/03 23:00:45 INFO data info data="&{ID:3 Content:FooBar}" req=14
2024/02/03 23:00:45 INFO data info data="&{ID:3 Content:FooBar}" req=13
2024/02/03 23:00:45 INFO data info data="&{ID:3 Content:FooBar}" req=12
```

## 了解 singleflight 的實作

看完上述使用 `singleflight` 解決快取擊穿的問題，我們來看看 `singleflight` 的實作。底下是 `singleflight` 的程式碼。首先了解 `Do` 的實作。

```go
func (g *Group) Do(key string, fn func() (interface{}, error)) (v interface{}, err error, shared bool) {
  g.mu.Lock()
  if g.m == nil {
    g.m = make(map[string]*call)
  }
  if c, ok := g.m[key]; ok {
    c.dups++
    g.mu.Unlock()
    c.wg.Wait()

    if e, ok := c.err.(*panicError); ok {
      panic(e)
    } else if c.err == errGoexit {
      runtime.Goexit()
    }
    return c.val, c.err, true
  }
  c := new(call)
  c.wg.Add(1)
  g.m[key] = c
  g.mu.Unlock()

  g.doCall(c, key, fn)
  return c.val, c.err, c.dups > 0
}
```

這段程式碼是來自 singleflight 套件中的 Do 方法。singleflight 是一種用於避免重複執行相同工作的機制，它確保同一個 key 只有一個執行在進行中，並且如果有重複的呼叫進來，則重複的呼叫會等待原始呼叫完成並接收相同的結果。

讓我們來詳細解釋這個 Do 方法的實作方式及其背後的理念：

1. 首先，Do 方法接收兩個參數：key 和 fn。key 是用來識別不同工作的唯一標識，而 fn 則是實際要執行的工作函數，它會返回一個 interface{} 和一個 error。
2. 在方法開頭，我們可以看到程式碼鎖定了一個 mutex，這是為了確保在進行後續操作時不會有競爭條件發生。
3. 接著，程式檢查了一個 map g.m 是否為空，如果是的話則初始化它。這個 map 用來存儲每個 key 對應的呼叫狀態。
4. 接下來，程式檢查了是否已經有相同 key 的呼叫正在進行中。如果是的話，則將重複呼叫的計數加一，然後釋放 mutex，並等待原始呼叫完成。一旦原始呼叫完成，重複呼叫就會返回相同的結果。
5. 如果沒有相同 key 的呼叫正在進行中，則程式會建立一個新的呼叫狀態，並將其加入到 map 中，然後釋放 mutex。
6. 最後，程式呼叫了 doCall 方法來執行實際的工作函數 fn。一旦工作函數執行完成，程式就會返回結果和錯誤，同時檢查是否有重複的呼叫。

這個 Do 方法的實作方式確保了同一個 key 只有一個執行在進行中，並且能夠正確地處理重複的呼叫，確保它們能夠獲得相同的結果。這樣可以有效地避免重複執行相同的工作，同時節省系統資源。可以看到底層透過 sync.WaitGroup 讓相同的 key 只會執行一次，其他的都會等待。

接著看看 `DoChan` 的實作方式。

```go
// DoChan is like Do but returns a channel that will receive the
// results when they are ready.
//
// The returned channel will not be closed.
func (g *Group) DoChan(key string, fn func() (interface{}, error)) <-chan Result {
  ch := make(chan Result, 1)
  g.mu.Lock()
  if g.m == nil {
    g.m = make(map[string]*call)
  }
  if c, ok := g.m[key]; ok {
    c.dups++
    c.chans = append(c.chans, ch)
    g.mu.Unlock()
    return ch
  }
  c := &call{chans: []chan<- Result{ch}}
  c.wg.Add(1)
  g.m[key] = c
  g.mu.Unlock()

  go g.doCall(c, key, fn)

  return ch
}
```

這段程式碼是 singleflight 套件中的 DoChan 方法。DoChan 方法與前面提到的 Do 方法類似，但是它返回一個 channel，當結果準備好時，這個 channel 將接收到結果。

讓我們來詳細解釋這個 DoChan 方法做了什麼事情，以及它與 Do 方法的差異：

1. DoChan 方法也接收兩個參數：key 和 fn。key 用來識別不同工作的唯一標識，而 fn 是實際要執行的工作函數，它會返回一個 interface{} 和一個 error。
2. 在方法開頭，程式碼鎖定了一個 mutex，這是為了確保在進行後續操作時不會有競爭條件發生。
3. 接著，程式檢查了一個 map g.m 是否為空，如果是的話則初始化它。這個 map 用來存儲每個 key 對應的呼叫狀態。
4. 然後，程式檢查是否已經有相同 key 的呼叫正在進行中。如果是的話，則將重複呼叫的計數加一，並將這個新的 channel 加入到呼叫狀態的 chans 切片中，然後釋放 mutex，並返回這個新的 channel。
5. 如果沒有相同 key 的呼叫正在進行中，則程式會建立一個新的呼叫狀態，並將這個新的 channel 加入到呼叫狀態的 chans 切片中，然後將呼叫狀態加入到 map 中，最後釋放 mutex。
6. 最後，程式呼叫了 doCall 方法來執行實際的工作函數 fn。這個方法是在一個新的 goroutine 中執行的，這樣可以讓 DoChan 方法立即返回 channel，而不需要等待工作函數執行完成。

總結來說，DoChan 方法與 Do 方法的主要差異在於返回值的類型：Do 方法直接返回結果和錯誤，而 DoChan 方法返回一個 channel，當結果準備好時，這個 channel 將接收到結果。這樣可以讓呼叫者在不阻塞的情況下等待結果，並且可以進行非同步的處理。這邊有個地方需要注意，就是 `ch := make(chan Result, 1)`，為什麼要設定為 1 呢？大家可以想想看。

所以可以看到我們用 [select][13] 來處理超時的情況，這樣就可以避免過多的請求持續等待。

[13]: https://blog.wu-boy.com/2019/11/four-tips-with-select-in-golang/

## singleflight 泛型 (Generic)

在 Go 1.18 中，`singleflight` 套件已經被加入泛型支援，這樣可以讓開發者更容易使用 `singleflight` 套件。而原本 Go 團隊的 bradfitz 也有提出[這樣的想法][15]，目前尚未實作，所以 bradfitz 自己弄一個 package 放在 [tailscale][16] 產品內。之後可以拿來套在自己的專案上面。

[15]: https://github.com/golang/go/issues/53427
[16]: https://github.com/tailscale/tailscale

```go
// Group represents a class of work and forms a namespace in
// which units of work can be executed with duplicate suppression.
type Group[K comparable, V any] struct {
  mu sync.Mutex     // protects m
  m  map[K]*call[V] // lazily initialized
}

// Result holds the results of Do, so they can be passed
// on a channel.
type Result[V any] struct {
  Val    V
  Err    error
  Shared bool
}
```

## 心得感想

上述程式碼可以在[這邊取用][20]。這篇文章介紹了如何使用 `singleflight` 來解決快取擊穿的問題，這是 `sync` 套件中的一個功能，可以避免重複的請求同時打到後端資料庫。除了使用 `Do` 之外，我們也介紹了 `DoChan` 的使用方式，這樣可以避免過多的請求持續等待。最後我們也介紹了 `singleflight` 的實作方式，這樣可以讓開發者更容易使用 `singleflight` 套件。相信大家在遇到快取擊穿的問題時，可以使用 `singleflight` 來解決問題。

[20]: https://github.com/go-training/training/tree/master/example55-cache-hotspot-invalid
