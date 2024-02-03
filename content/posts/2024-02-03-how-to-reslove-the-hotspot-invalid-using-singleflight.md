---
title: "在 Go 語言用 singleflight 解決快取擊穿 (Cache Hotspot Invalid)"
date: 2024-02-03T14:19:13+08:00
author: appleboy
type: draft
slug: codegpt-in-modernweb
share_img: /images/2023-11-08/cover.png
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

  return data
}
```

底下是執行結果，可以看到同時有 5 個請求同時撈取快取中的資料。可以看到全都是從後端資料庫撈取資料。

```sh
2024/02/03 20:52:39 INFO missing cache id=1 req=4
2024/02/03 20:52:39 INFO missing cache id=1 req=2
2024/02/03 20:52:39 INFO missing cache id=1 req=3
2024/02/03 20:52:39 INFO data info data="&{ID:1 Content:FooBar}" req=4
2024/02/03 20:52:39 INFO missing cache id=1 req=0
2024/02/03 20:52:39 INFO data info data="&{ID:1 Content:FooBar}" req=2
2024/02/03 20:52:39 INFO missing cache id=1 req=1
2024/02/03 20:52:39 INFO data info data="&{ID:1 Content:FooBar}" req=0
2024/02/03 20:52:39 INFO data info data="&{ID:1 Content:FooBar}" req=1
2024/02/03 20:52:39 INFO data info data="&{ID:1 Content:FooBar}" req=3
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
