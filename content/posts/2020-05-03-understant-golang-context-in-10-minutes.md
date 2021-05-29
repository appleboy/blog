---
title: 用 10 分鐘了解 Go 語言 context package 使用場景及介紹
author: appleboy
type: post
date: 2020-05-03T02:45:07+00:00
url: /2020/05/understant-golang-context-in-10-minutes/
dsq_thread_id:
  - 8004444301
categories:
  - Golang
tags:
  - golang

---
[![golang logo][1]][1]

[context][2] 是在 [Go 語言][3] 1.7 版才正式被納入官方標準庫內，為什麼今天要介紹 context 使用方式呢？原因很簡單，在初學 Go 時，寫 API 時，常常不時就會看到在 http handler 的第一個參數就會是 `ctx context.Context`，而這個 context 在這邊使用的目的及含義到底是什麼呢，本篇就是帶大家了解什麼是 context，以及使用的場景及方式，內容不會提到 context 的原始碼，而是用幾個實際例子來了解。

<!--more-->

## 教學影片

{{< youtube yXmPkSNByjY >}}

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][4]
  * [一天學會 DevOps 自動化測試及部署][5]
  * [DOCKER 容器開發部署實戰][6] (課程剛啟動，限時特價 $900 TWD)

如果需要搭配購買請直接透過 [FB 聯絡我][7]，直接匯款（價格再減 **100**）

## 使用 WaitGroup

學 Go 時肯定要學習如何使用併發 (goroutine)，而開發者該如何控制併發呢？其實有兩種方式，一種是 [WaitGroup][8]，另一種就是 context，而什麼時候需要用到 WaitGroup 呢？很簡單，就是當您需要將同一件事情拆成不同的 Job 下去執行，最後需要等到全部的 Job 都執行完畢才繼續執行主程式，這時候就需要用到 WaitGroup，看個實際例子

```go
package main

import (
    "fmt"
    "sync"
    "time"
)

func main() {
    var wg sync.WaitGroup

    wg.Add(2)
    go func() {
        time.Sleep(2 * time.Second)
        fmt.Println("job 1 done.")
        wg.Done()
    }()
    go func() {
        time.Sleep(1 * time.Second)
        fmt.Println("job 2 done.")
        wg.Done()
    }()
    wg.Wait()
    fmt.Println("All Done.")
}
```

上面範例可以看到主程式透過 `wg.Wait()` 來等待全部 job 都執行完畢，才印出最後的訊息。這邊會遇到一個情境就是，雖然把 job 拆成多個，並且丟到背景去跑，可是使用者該如何透過其他方式來終止相關 goroutine 工作呢 (像是開發者都會寫背景程式監控，需要長時間執行)？例如 UI 上面有停止的按鈕，點下去後，如何主動通知並且停止正在跑的 Job，這邊很簡單，可以使用 channel + select 方式。

## 使用 channel + select

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    stop := make(chan bool)

    go func() {
        for {
            select {
            case <-stop:
                fmt.Println("got the stop channel")
                return
            default:
                fmt.Println("still working")
                time.Sleep(1 * time.Second)
            }
        }
    }()

    time.Sleep(5 * time.Second)
    fmt.Println("stop the gorutine")
    stop <- true
    time.Sleep(5 * time.Second)
}
```

上面可以看到，透過 select + channel 可以快速解決這問題，只要在任何地方將 bool 值丟入 stop channel 就可以停止背景正在處理的 Job。上述用 channel 來解決此問題，但是現在有個問題，假設背景有跑了無數個 goroutine，或者是 goroutine 內又有跑 goroutine 呢，變得相當複雜，例如底下的狀況

[![cancel][9]][9]

這邊就沒辦法用 channel 方式來進行處理了，而需要用到今天的重點 context。

## 認識 context

從上圖可以看到我們建立了三個 worker node 來處理不同的 Job，所以會在主程式最上面宣告一個主 `context.Background()`，然後在每個 worker node 分別在個別建立子 context，其最主要目的就是當關閉其中一個 context 就可以直接取消該 worker 內正在跑的 Job。拿上面的例子進行改寫

```go
package main

import (
    "context"
    "fmt"
    "time"
)

func main() {
    ctx, cancel := context.WithCancel(context.Background())

    go func() {
        for {
            select {
            case <-ctx.Done():
                fmt.Println("got the stop channel")
                return
            default:
                fmt.Println("still working")
                time.Sleep(1 * time.Second)
            }
        }
    }()

    time.Sleep(5 * time.Second)
    fmt.Println("stop the gorutine")
    cancel()
    time.Sleep(5 * time.Second)
}
```

其實可以看到只是把原本的 channel 換成使用 context 來處理，其他完全不變，這邊提到使用了 `context.WithCancel`，使用底下方式可以擴充 context

```go
ctx, cancel := context.WithCancel(context.Background())
```

這用意在於每個 worknode 都有獨立的 `cancel func` 開發者可以透過其他地方呼叫 cancel() 來決定哪一個 worker 需要被停止，這時候可以做到使用 context 來停止多個 goroutine 的效果，底下看看實際例子

```go
package main

import (
    "context"
    "fmt"
    "time"
)

func main() {
    ctx, cancel := context.WithCancel(context.Background())

    go worker(ctx, "node01")
    go worker(ctx, "node02")
    go worker(ctx, "node03")

    time.Sleep(5 * time.Second)
    fmt.Println("stop the gorutine")
    cancel()
    time.Sleep(5 * time.Second)
}

func worker(ctx context.Context, name string) {
    for {
        select {
        case <-ctx.Done():
            fmt.Println(name, "got the stop channel")
            return
        default:
            fmt.Println(name, "still working")
            time.Sleep(1 * time.Second)
        }
    }
}
```

上面透過一個 context 可以一次停止多個 worker，看邏輯如何宣告 context 以及什麼時機去執行 cancel()，通常我個人都是搭配 graceful shutdown 進行取消正在跑的 Job，或者是停止資料庫連線等等..

## 心得

初學 Go 時，如果還不常使用 goroutine，其實也不會理解到 context 的使用方式及時機，等到需要有背景處理，以及該如何停止 Job，這時候才漸漸瞭解到使用方式，當然 context 不只有這個使用方式，未來還會介紹其他使用方式。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://golang.org/pkg/context/
 [3]: https://golang.org/
 [4]: https://www.udemy.com/course/golang-fight/?couponCode=202004
 [5]: https://www.udemy.com/course/devops-oneday/?couponCode=202004
 [6]: https://www.udemy.com/course/docker-practice/?couponCode=202004
 [7]: http://facebook.com/appleboy46
 [8]: https://golang.org/pkg/sync/#WaitGroup
 [9]: https://lh3.googleusercontent.com/5DlSP5PTIDoxS0MwAnFENz6IrPT05IQ8UjZfVm-aUb5qEsTd9DyUMSunc-_O7kliI4oqjZUcabL4A5fk2_X3RtXx1UhuBDQiswAAh4Ux6lO-WCs18Z3WVmi6ujxCxC_k9mNHBfl9SFA=w1920-h1080 "cancel"
