---
title: 在 Go 語言內管理 Concurrency 的三種方式
author: appleboy
type: post
date: 2020-08-09T07:58:04+00:00
url: /2020/08/three-ways-to-manage-concurrency-in-go/
dsq_thread_id:
  - 8158665063
categories:
  - Golang
tags:
  - golang

---
[![golang logo][1]][1]

相信大家踏入 [Go 語言][2]的世界，肯定是被強大的 Concurrency 所吸引，Go 語言用最簡單的關鍵字 `go` 就可以將任務丟到背景處理，但是怎麼有效率的控制 Concurrency，這是入門 Go 語言必學的項目，本篇會介紹三種方式來帶大家認識 Concurrency，而這三種方式分別對應到三個不同的名詞: [WaitGroup][3], [Channel][4], 及 [Context][5]，底下用簡單的範例帶大家了解。

<!--more-->

## 教學影片

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][6]
  * [一天學會 DevOps 自動化測試及部署][7]
  * [DOCKER 容器開發部署實戰][8]

如果需要搭配購買請直接透過 [FB 聯絡我][9]，直接匯款（價格再減 **100**）

## WaitGroup

先來了解有什麼情境需要使用到 WaitGroup，假設您有兩台機器需要同時上傳最新的程式碼，兩台機器分別上傳完成後，才能執行最後的重啟步驟。就像是把一個 Job 同時拆成好幾份同時一起做，可以減少不少時間，但是最後需要等到全部做完，才能執行下一步，這時候就需要用到 WaitGroup 函式才能做到。底下看個簡單例子

<pre><code class="language-go">package main

import (
    "fmt"
    "sync"
)

func main() {
    var wg sync.WaitGroup
    i := 0
    wg.Add(3) //task count wait to do
    go func() {
        defer wg.Done() // finish task1
        fmt.Println("goroutine 1 done")
        i++
    }()
    go func() {
        defer wg.Done() // finish task2
        fmt.Println("goroutine 2 done")
        i++
    }()
    go func() {
        defer wg.Done() // finish task3
        fmt.Println("goroutine 3 done")
        i++
    }()
    wg.Wait() // wait for tasks to be done
    fmt.Println("all goroutine done")
    fmt.Println(i)
}</code></pre>

## Channel

另外一種實際的案例就是，我們需要主動通知一個 Goroutine 進行停止的動作。舉例來說，當 App 啟動時，會在背景跑一些監控程式，而當整個 App 需要停止前，需要發個 Notification 給背景的監控程式，將其先停止，這時候就需要用到 Channel 來通知。底下來看個範例:

<pre><code class="language-go">package main

import (
    "fmt"
    "time"
)

func main() {
    exit := make(chan bool)
    go func() {
        for {
            select {
            case &lt;-exit:
                fmt.Println("Exit")
                return
            case &lt;-time.After(2 * time.Second):
                fmt.Println("Monitoring")
            }
        }
    }()
    time.Sleep(5 * time.Second)
    fmt.Println("Notify Exit")
    exit &lt;- true //keep main goroutine alive
    time.Sleep(5 * time.Second)
}</code></pre>

上面例子可以發現，背景用了一個 Goutine 及一個 Channel 來控制。可以想像當背景有無數個 Goroutine 的時候，我們就需要宣告多個 Channel 才能進行控制，也許 Goroutine 內又會產生 Goroutine，開發者這時候就會發現已經無法單純使用 Channel 來控制多個 Goroutine 了。這時候解決方式會是透過 `context`

## Context

大家可以想像，今天有一個背景任務 A，A 任務又產生了 B 任務，B 任務又產生了 C 任務，也就是可以按照此模式一直產生下去，假設中途我們需要停止 A 任務，而 A 又必須告訴 B 及 C 要一起停止，這時候透過 context 方式是最快的了。

<pre><code class="language-go">package main

import (
    "context"
    "fmt"
    "time"
)

func foo(ctx context.Context, name string) {
    go bar(ctx, name) // A calls B
    for {
        select {
        case &lt;-ctx.Done():
            fmt.Println(name, "A Exit")
            return
        case &lt;-time.After(1 * time.Second):
            fmt.Println(name, "A do something")
        }
    }
}

func bar(ctx context.Context, name string) {
    for {
        select {
        case &lt;-ctx.Done():
            fmt.Println(name, "B Exit")
            return
        case &lt;-time.After(2 * time.Second):
            fmt.Println(name, "B do something")
        }
    }
}

func main() {
    ctx, cancel := context.WithCancel(context.Background())
    go foo(ctx, "FooBar")
    fmt.Println("client release connection, need to notify A, B exit")
    time.Sleep(5 * time.Second)
    cancel() //mock client exit, and pass the signal, ctx.Done() gets the signal  time.Sleep(3 * time.Second)
    time.Sleep(3 * time.Second)
}</code></pre>

大家可以把 context 想成是一個 controller，可以隨時控制不確定個數的 Goroutine，由上往下，只要宣告 `context.WithCancel` 後，再任意時間點都可以透過 `cancel()` 來停止整個背景服務。這邊實在案例會用在當 App 需要重新 restart 時，要先通知全部 goroutine 停止，正常停止後，才會重新啟動 App。

## 總結

根據不同的情境跟狀況來選擇不同的函式，底下做個總結

  * WaitGroup: 需要將單一個 Job 拆成多個子任務，等到全部完成後，才能進行下一步，這時候用 WaitGroup 最適合了
  * Channel+select: Channel 只能用在比較單純的 Goroutine 狀況下，如果要管理多個 Goroutine，建議還是走 context 會比較適合
  * Context: 如果你想一次控制全部的 Goroutine，相信用 context 會是最適合不過的，這也是現在 Go 用最兇的地方，當然 context 不只有這特性，詳細可以參考『[用 10 分鐘了解 Go 語言 context package 使用場景及介紹][5]』

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://golang.org/
 [3]: https://gobyexample.com/waitgroups
 [4]: https://tour.golang.org/concurrency/2
 [5]: https://blog.wu-boy.com/2020/05/understant-golang-context-in-10-minutes/
 [6]: https://www.udemy.com/course/golang-fight/?couponCode=202008
 [7]: https://www.udemy.com/course/devops-oneday/?couponCode=202008
 [8]: https://www.udemy.com/course/docker-practice/?couponCode=202008
 [9]: http://facebook.com/appleboy46