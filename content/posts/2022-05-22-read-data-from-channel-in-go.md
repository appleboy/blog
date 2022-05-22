---
title: "用 10 分鐘了解 Go 語言如何從 Channel 讀取資料"
date: 2022-05-22T22:42:46+08:00
type: post
slug: read-data-from-channel-in-go
share_img: https://i.imgur.com/NGE7q2U.png
categories:
  - Golang
tags:
  - golang
  - golang channel
---

![logo](https://i.imgur.com/NGE7q2U.png)

Go 語言強大的 [goroutine 特性](https://go.dev/tour/concurrency/1)，讓各位開發者愛不釋手，而多個 goroutine 如何溝通呢？就是透過 [Channel](https://go.dev/tour/concurrency/2) 來做到。本篇教大家從 Channel 讀取資料的兩種方式及使用時機，並實際用一個案例快速了解 Channel 實作上會遇到哪些問題？底下用兩個範例讓大家了解如何讀取 Channel 資料出來。

<!--more-->

## 讀取 Channel 兩種方式

第一個用的是 `for range` 方式

```go
package main

import "fmt"

func main() {
  ch := make(chan int)
  go func() {
    for i := 0; i < 10; i++ {
      ch <- i
    }
    close(ch)
  }()

  for v := range ch {
    fmt.Println(v)
  }
}
```

第二種是透過 `v, ok := <-ch` 方式

```go
package main

import "fmt"

func main() {
  ch := make(chan int)
  go func() {
    for i := 0; i < 10; i++ {
      ch <- i
    }
    close(ch)
  }()

  for {
    v, ok := <-ch
    if !ok {
      return
    }
    fmt.Println(v)
  }
}
```

看完上面兩個範例，開發者也很清楚知道這兩種讀取方式，但是會遇到什麼時候開始用第一種，什麼時候該使用第二種？底下來看看一個簡單範例

## 兩個 goroutine 交互讀取字元

先看看題目，有一個字串 foobar，將字元拆開丟到 Channel 內，用兩個 goroutine 交互讀取字元，底下是最後的輸出結果

```sh
goroutine01: f
goroutine02: o
goroutine01: o
goroutine02: b
goroutine01: a
goroutine02: r
```

先把上面題目複製到 `main.go`，大家可以看一下底下範例後，看看怎麼寫出兩個 goroutine，可以先在[線上練習看看](https://go.dev/play/p/O-X5WRyHjhU)，不要往下看解答

```go
package main

import (
  "sync"
)

func main() {
  str := []byte("foobar")
  ch := make(chan byte, len(str))
  wg := &sync.WaitGroup{}
  wg.Add(2)

  for i := 0; i < len(str); i++ {
    ch <- str[i]
  }

  go func() {
  }()

  go func() {
  }()

  wg.Wait()
}
```

看完這題目，大家應該就知道是無法使用方式一來讀取 channel 資料，因為 `for range` 會持續讀資料直到 channel 被關閉為止，這樣是不能保證另一個 gorountine 可以正確讀到下一個字元。

## 實作方式

從上面範例可以看到兩個 goroutine 裡面寫的代碼應該要一樣，故需要一個 channel 來通知下一個 goroutine 進行讀取，將程式碼改成如下:

```go
package main

import (
  "fmt"
  "sync"
)

func main() {
  str := []byte("foobar")
  ch := make(chan byte, len(str))
  next := make(chan struct{})
  wg := &sync.WaitGroup{}
  wg.Add(2)

  for i := 0; i < len(str); i++ {
    ch <- str[i]
  }

  close(ch)

  go func() {
    defer wg.Done()
    for {
      <-next

      v, ok := <-ch
      if ok {
        fmt.Println("goroutine01:", string(v))
      } else {
        close(next)
        return
      }

      next <- struct{}{}
    }
  }()

  go func() {
    defer wg.Done()
    for {
      <-next

      v, ok := <-ch
      if ok {
        fmt.Println("goroutine02:", string(v))
      } else {
        close(next)
        return
      }

      next <- struct{}{}
    }
  }()

  next <- struct{}{}

  wg.Wait()
}
```

1. 首先當資料全部寫進 Channel 後，需要關閉 Channel
2. 新增 next Channel 用來通知下一個 goroutine 讀取資料
3. main 主函式要先丟資料到 next Channel
4. 當 ch Channel 讀取資料結束後，需要關閉 next Channel

執行完上述步驟後，會得到底下結果

```sh
goroutine02: f
goroutine01: o
goroutine02: o
goroutine01: b
goroutine02: a
goroutine01: r
panic: close of closed channel
```

這邊可以看到 `<-next` 此 channel 被關閉後，會一直有資料，故需要用另一種方式來判斷 channel 是否關閉，就改成如下

```go
  go func() {
    defer wg.Done()
    for {
      stop, ok := <-next
      if !ok {
        return
      }

      v, ok := <-ch
      if ok {
        fmt.Println("goroutine01:", string(v))
      } else {
        close(next)
        return
      }

      next <- stop
    }
  }()
```

程式可以正確執行了，但是看到 `if else` 程式碼，我們可以在重構一次

```go
  go func() {
    defer wg.Done()
    for {
      stop, ok := <-next
      if !ok {
        return
      }

      v, ok := <-ch
      if !ok {
        close(next)
        return
      }

      fmt.Println("goroutine01:", string(v))
      next <- stop
    }
  }()
```

最後完整程式碼如下，可以線上[執行試試看](https://go.dev/play/p/G6nkoIIHAky)

```go
package main

import (
  "fmt"
  "sync"
)

func main() {
  str := []byte("foobar")
  ch := make(chan byte, len(str))
  next := make(chan struct{})
  wg := &sync.WaitGroup{}
  wg.Add(2)

  for i := 0; i < len(str); i++ {
    ch <- str[i]
  }

  close(ch)

  go func() {
    defer wg.Done()
    for {
      stop, ok := <-next
      if !ok {
        return
      }

      v, ok := <-ch
      if !ok {
        close(next)
        return
      }

      fmt.Println("goroutine01:", string(v))
      next <- stop
    }
  }()

  go func() {
    defer wg.Done()
    for {
      stop, ok := <-next
      if !ok {
        return
      }

      v, ok := <-ch
      if !ok {
        close(next)
        return
      }

      fmt.Println("goroutine02:", string(v))
      next <- stop
    }
  }()

  next <- struct{}{}

  wg.Wait()
}
```

## 心得

透過上述範例希望可以讓剛入門朋友了解 Channel 特性，除了此案例之外，大家可以想一下怎麼實現 worker pool pattern，之後有機會可以跟大家介紹此部分。
