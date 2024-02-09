---
title: "Using singleflight in Go language to solve Cache Hotspot Invalid"
date: 2024-02-03T14:19:13+08:00
author: appleboy
type: post
slug: how-to-reslove-the-hotspot-invalid-using-singleflight-en
share_img: /images/2024-02-03/cache-hotspot-invalid.png
categories:
- golang
---

![photo](/images/2024-02-03/cache-hotspot-invalid.png)

The diagram above illustrates a commonly used architecture in implementing web services, which involves adding a cache between the service and the database to reduce the load on the database. However, when implementing service integration, three major cache problems are often encountered: [Cache Avalanche, Hotspot Invalid, Cache Penetration][1]. Among them, Cache Hotspot Invalid is a very common issue. When the data in the cache expires or disappears, a large number of requests will simultaneously hit the backend database, causing an excessive load on the database and even leading to database crashes, as shown in the diagram where the cache key of a certain article expires. This article will introduce how to use the [singleflight][3] built into the [Go language][2] to solve the Cache Hotspot Invalid problem. This is a feature in the [sync][4] package that can prevent duplicate requests from hitting the backend database simultaneously.

![photo](/images/2024-02-03/cache-missing.png)

[1]: https://totoroliu.medium.com/redis-%E5%BF%AB%E5%8F%96%E9%9B%AA%E5%B4%A9-%E6%93%8A%E7%A9%BF-%E7%A9%BF%E9%80%8F-8bc02f09fe8f
[2]: https://go.dev
[3]: https://pkg.go.dev/golang.org/x/sync/singleflight
[4]: https://pkg.go.dev/golang.org/x/sync

<!--more-->

## Simulating Cache Hotspot Invalid

We will write a simple example to simulate the problem of Cache Hotspot Invalid. We will use the map function in Go language to implement a simple caching mechanism and store the data in the cache. This way, when fetching the same data again, we can directly retrieve it from the cache.

```go
package main

import "sync"

type Cache[K comparable, V any] struct {
  sync.Mutex
  entries map[K]V
}

func (c *Cache[K, V]) Get(id K) (v V) {
  if _, ok := c.entries[id]; !ok {
    return v
  }
  c.Lock()
  defer c.Unlock()
  return c.entries[id]
}

func (c *Cache[K, V]) Set(id K, article V) {
  c.Lock()
  defer c.Unlock()
  c.entries[id] = article
}

func NewCache[K comparable, V any]() *Cache[K, V] {
  return &Cache[K, V]{
    entries: make(map[K]V),
  }
}
```

Next, we will use [goroutines][11] to simulate multiple requests simultaneously fetching data from the cache, so that we can observe the problem of Cache Hotspot Invalid.

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
    cache: NewCache[int, *Article](),
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

Below is the execution result, where we can see 3 instances of "missing cache," indicating that 3 requests simultaneously hit the backend database, while the remaining 2 instances are cache hits. This is the issue of Cache Hotspot Invalid. Ideally, we should avoid accessing the database more than once, which can effectively protect the backend database.

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

## Using singleflight to Solve Cache Problem

Next, let's use [singleflight][3] to solve the problem of Cache Hotspot Invalid. This package can prevent duplicate requests from hitting the backend database simultaneously. The expected correct result should be as follows:

```sh
2024/02/03 21:42:29 INFO missing cache id=1 req=1
2024/02/03 21:42:29 INFO data info data="&{ID:1 Content:FooBar}" req=1
2024/02/03 21:42:29 INFO data info data="&{ID:1 Content:FooBar}" req=2
2024/02/03 21:42:29 INFO data info data="&{ID:1 Content:FooBar}" req=3
2024/02/03 21:42:29 INFO data info data="&{ID:1 Content:FooBar}" req=4
2024/02/03 21:42:29 INFO data info data="&{ID:1 Content:FooBar}" req=0
```

We should only see one instance of "missing cache," with the rest of the data being retrieved from the cache. Let's see how to use singleflight to solve the problem. Below is the code for accessing the DB.

```go
  slog.Info("missing cache", "id", id, "req", req)
  data = &Article{
    ID:      id,
    Content: "FooBar",
  }
  db.cache.Set(id, data)
```

How should we modify the code to use singleflight to solve the problem of Cache Hotspot Invalid? Below is the modified code.

```go
type DB struct {
  cache  *Cache[int, *Article]
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

As you can see, we have replaced the original db.cache.Set with the use of `singleflight.Group` to wrap it, thus preventing duplicate requests from hitting the backend database simultaneously.

In addition to using Do, have you ever considered what would happen if 100 requests simultaneously fetch data from the cache, but the database connection for reading data takes longer to process? However, we also want to set a timeout mechanism to avoid too many requests waiting indefinitely. In this case, we can use `DoChan` of `singleflight.Group` to solve this problem. Below is the modified code.

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

In the main.go program, the changes should be as follows:

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

The result is as follows: we can see that req=10, 11 waits for more than 100ms, 110ms, and then returns nil directly.

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

## Understanding the Implementation of singleflight

After learning about using `singleflight` to solve the problem of Cache Hotspot Invalid, let's take a look at the implementation of `singleflight`. Below is the code for `singleflight`. First, let's understand the implementation of Do.

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

This code snippet is from the Do method in the singleflight package. singleflight is a mechanism used to avoid executing the same work repeatedly. It ensures that only one execution is in progress for the same key, and if duplicate calls come in, the duplicate calls will wait for the original call to complete and receive the same result.

Let's explain in detail the implementation of this Do method and the underlying concept:

1. First, the Do method takes two parameters: key and fn. The key is used to uniquely identify different tasks, while fn is the actual work function that returns an interface{} and an error.
2. At the beginning of the method, we can see that the code locks a mutex to ensure that there are no race conditions during subsequent operations.
3. Next, the code checks whether the map g.m is empty, and if so, it initializes it. This map is used to store the call status for each key.
4. Then, the code checks if there is already a call in progress for the same key. If so, it increments the count of duplicate calls, releases the mutex, and waits for the original call to complete. Once the original call is completed, the duplicate call will return the same result.
5. If there is no call in progress for the same key, the code creates a new call status and adds it to the map, then releases the mutex.
6. Finally, the code calls the doCall method to execute the actual work function fn. Once the work function is completed, the code returns the result and error, while checking for any duplicate calls.

The implementation of this Do method ensures that only one execution is in progress for the same key and correctly handles duplicate calls, ensuring that they receive the same result. This effectively avoids repeatedly executing the same work and saves system resources. The underlying implementation uses sync.WaitGroup to ensure that the same key is only executed once, while others wait.

Next, let's take a look at the implementation of `DoChan`.

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

This code snippet is from the DoChan method in the singleflight package. The DoChan method is similar to the previously mentioned Do method, but it returns a channel that will receive the result when it is ready.

Let's explain in detail what the DoChan method does and how it differs from the Do method:

1. The DoChan method also takes two parameters: key and fn. The key is used to uniquely identify different tasks, while fn is the actual work function that returns an interface{} and an error.
2. At the beginning of the method, the code locks a mutex to ensure that there are no race conditions during subsequent operations.
3. Next, the code checks whether the map g.m is empty, and if so, it initializes it. This map is used to store the call status for each key.
4. Then, the code checks if there is already a call in progress for the same key. If so, it increments the count of duplicate calls, adds the new channel to the chans slice of the call status, releases the mutex, and returns the new channel.
5. If there is no call in progress for the same key, the code creates a new call status, adds the new channel to the chans slice of the call status, adds the call status to the map, and finally releases the mutex.
6. Finally, the code calls the doCall method to execute the actual work function fn. This method is executed in a new goroutine, allowing the DoChan method to immediately return the channel without waiting for the work function to complete.

In summary, the main difference between the DoChan method and the Do method lies in the return type: the Do method directly returns the result and error, while the DoChan method returns a channel that will receive the result when it is ready. This allows the caller to wait for the result without blocking and enables asynchronous processing. One thing to note is the line `ch := make(chan Result, 1)`—why is it set to `1`? You can think about the reason for this.

Therefore, we use [select][13] to handle the timeout situation, which avoids too many requests waiting indefinitely.

[13]: https://blog.wu-boy.com/2019/11/four-tips-with-select-in-golang/

## singleflight (Generic)

In Go 1.18, the `singleflight` package has been added with support for generics, making it easier for developers to use the singleflight package. The original Go team member, bradfitz, also proposed [this idea][15], which has not been implemented yet. Therefore, bradfitz created a package and placed it within the [tailscale][16] product, which can be used in other projects in the future.

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

Below is the declaration and partial code, showing that the singleflight package now supports generics.

```go
type DBG struct {
  cache  *Cache[int, *Article]
  engine gsingleflight.Group[int, *Article]
}

func (db *DBG) GetArticleDo(req int, id int) *Article {
  data := db.cache.Get(id)
  if data != nil {
    slog.Info("cache hit", "id", id, "req", req)
    return data
  }

  row, err, _ := db.engine.Do(id, func() (*Article, error) {
    slog.Info("missing cache", "id", id, "req", req)
    data := &Article{
      ID:      id,
      Content: "FooBar",
    }
    db.cache.Set(id, data)
    time.Sleep(100 * time.Millisecond)
    return data, nil
  })

  if err != nil {
    slog.Error("singleflight error", "err", err)
    return nil
  }

  return row
}
```

## Conclusion

The above code can be accessed [here][20] (including the Generic package). This article introduced how to use singleflight to solve the problem of Cache Hotspot Invalid. This is a feature in the sync package that can prevent duplicate requests from hitting the backend database simultaneously. In addition to using Do, we also introduced the usage of DoChan, which helps avoid too many requests waiting indefinitely. Finally, we also discussed the implementation of singleflight, making it easier for developers to use the singleflight package. It is believed that when encountering the problem of Cache Hotspot Invalid, developers can use singleflight to solve the issue.

[20]: https://github.com/go-training/training/tree/master/example55-cache-hotspot-invalid

## References

* [singleflight - GoDoc](https://pkg.go.dev/golang.org/x/sync/singleflight)
* [缓存雪崩 Cache Avalanche 缓存穿透 Cache Penetration 缓存击穿 Hotspot Invalid](https://www.cnblogs.com/Leo_wl/p/12294093.html)
* [redis - 快取雪崩、擊穿、穿透](https://totoroliu.medium.com/redis-%E5%BF%AB%E5%8F%96%E9%9B%AA%E5%B4%A9-%E6%93%8A%E7%A9%BF-%E7%A9%BF%E9%80%8F-8bc02f09fe8f)
* [Go 語言使用 Select 四大用法][13]
