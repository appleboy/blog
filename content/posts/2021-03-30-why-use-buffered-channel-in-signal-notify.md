---
title: 為什麼 signal.Notify 要使用 buffered channel
author: appleboy
type: post
date: 2021-03-30T03:19:16+00:00
url: /2021/03/why-use-buffered-channel-in-signal-notify/
dsq_thread_id:
  - 8457751666
categories:
  - Golang

---
[![golang logo][1]][1]

如果不了解什麼是 buffer 或 unbuffer [channel][2] 的朋友們，可以參考[這篇文章][3]先做初步了解，本文要跟大家介紹為什麼 signal.Notify 要使用 buffered channel 才可以，底下先來看看如何使用 signal.Notify，當我們要做 [graceful shutdown][4] 都會使用到這功能，想要正常關閉服務或連線，透過 signal 可以偵測訊號來源，執行後續相關工作 (關閉 DB 連線，檢查 Job 是否結束 ... 等)。

```go
package main

import (
    "fmt"
    "os"
    "os/signal"
)

func main() {
    // Set up channel on which to send signal notifications.
    // We must use a buffered channel or risk missing the signal
    // if we're not ready to receive when the signal is sent.
    c := make(chan os.Signal, 1)
    signal.Notify(c, os.Interrupt)

    // Block until a signal is received.
    s := <-c
    fmt.Println("Got signal:", s)
}
```

上面例子可以很清楚看到說明，假如沒有使用 buffered channel 的話，你有一定的風險會沒抓到 Signal。那為什麼會有這段說明呢？底下用其他例子來看看。

<!--more-->

## 教學影片

## 使用 unbuffered channel

將程式碼改成如下:

```go
package main

import (
    "fmt"
    "os"
    "os/signal"
)

func main() {
    c := make(chan os.Signal)
    signal.Notify(c, os.Interrupt)

    // Block until a signal is received.
    s := <-c
    fmt.Println("Got signal:", s)
}
```

執行上述程式碼，然後按下 ctrl + c，沒意外你會看到 `Got signal: interrupt`，那接著我們在接受 channle 前面有處理一些很複雜的工作，先用 `time.Sleep` 來測試

```go
package main

import (
    "fmt"
    "os"
    "os/signal"
)

func main() {
    c := make(chan os.Signal)
    signal.Notify(c, os.Interrupt)

    time.Sleep(5 * time.Second)

    // Block until a signal is received.
    s := <-c
    fmt.Println("Got signal:", s)
}
```

一樣執行程式，然後按下 ctrl + c，你會發現在這五秒內，怎麼按都不會停止，等到五秒後，整個程式也不會終止，需要再按下一次 ctrl + c，這時候程式才會終止，我們預期的是，在前五秒內，按下任何一次 ctrl + c，理論上五秒後要能正常接受到第一次傳來的訊號，底下來看看原因

## 形成原因

我們打開 Golang 的 `singal.go` 檔案，找到 `process` func，可以看到部分程式碼

```go
    for c, h := range handlers.m {
        if h.want(n) {
            // send but do not block for it
            select {
            case c <- sig:
            default:
            }
        }
    }
```

可以看到上述程式碼，如果使用 unbuffered channel，那麼在五秒內接收到的任何訊號，都會跑到 default 條件內，所以造成 Channel 不會收到任何值，這也就是為什麼五秒內的任何動作，在五秒後都完全收不到。為了避免這件事情，所以通常我們會將 signal channel 設定為 `buffer 1`，來避免需要中斷程式時，確保主程式可以收到一個 signal 訊號。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://tour.golang.org/concurrency/2
 [3]: https://blog.wu-boy.com/2019/04/understand-unbuffered-vs-buffered-channel-in-five-minutes/
 [4]: https://blog.wu-boy.com/2020/02/what-is-graceful-shutdown-in-golang/