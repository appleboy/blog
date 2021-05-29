---
title: 15 分鐘學習 Go 語言如何處理多個 Channel 通道
author: appleboy
type: post
date: 2019-05-13T02:37:51+00:00
url: /2019/05/handle-multiple-channel-in-15-minutes/
dsq_thread_id:
  - 7414845750
categories:
  - Golang
tags:
  - golang
  - Goroutines

---
[![golang logo][1]][1]

大家在初學 [Go 語言][2]時，肯定很少用到 Go Channel，也不太確定使用的時機點，其實在官方 Blog 有提供一篇不錯的文章『[Go Concurrency Patterns: Pipelines and cancellation][3]』，相信大家剛跨入學習新語言時，不會馬上看 Go Channel，底下我來用一個簡單的例子來說明如何使用 Go Channel，使用情境非常簡單，就是假設今天要同時處理 20 個背景工作，一定想到要使用 [Goroutines][4]，但是又想要收到這 20 個 JOB 處理的結果，並顯示在畫面上，如果其中一個 Job 失敗，就跳出 main 函式，當然又會希望這 20 個 JOB 預期在一分鐘內執行結束，如果超過一分鐘，也是一樣跳出 main 函式。針對這個問題，我們可以整理需要三個 Channel + 一個 Timeout 機制。

  * 使用 outChan 顯示各個 JOB 完成狀況
  * 使用 errChan 顯示 JOB 發生錯誤並且跳出 main 主程式
  * 使用 finishChan 通知全部 JOB 已經完成
  * 設定 Timeout 機制 (1 秒之內要完成所有 job)

在看此文章之前，也許可以先理解什麼是『[buffer vs unbuffer channel][5]』。

<!--more-->

## 教學影片

更多實戰影片可以參考我的 Udemy 教學系列

  * Go 語言實戰課程: <http://bit.ly/golang-2019>
  * Drone CI/CD 自動化課程: <http://bit.ly/drone-2019>

## 實戰範例

針對上述的問題，先透過 Sync 套件的 WaitGroup 來確保 20 個 JOB 處理完成後才結束 main 函式。

```go
package main

import (
    "fmt"
    "math/rand"
    "sync"
    "time"
)

func main() {
    wg := sync.WaitGroup{}
    wg.Add(100)
    for i := 0; i < 100; i++ {
        go func(val int, wg *sync.WaitGroup) {
            time.Sleep(time.Duration(rand.Int31n(1000)) * time.Millisecond)
            fmt.Println("finished job id:", val)
            wg.Done()
        }(i, &wg)
    }

    wg.Wait()
}
```

大家可以先拿上面的範例來練習看看如何達到需求，而不是在 go func 內直接印出結果。

## 處理多個 Channel 通道

首先在 main 宣告三個 Channel 通道

```go
    outChan := make(chan int)
    errChan := make(chan error)
    finishChan := make(chan struct{})
```

接著要在最後直接讀取這三個 Channel 值，可以透過 Select，由於 outChan 會傳入 20 個值，所以需要搭配 for 迴圈方式來讀取多個值

```go
Loop:
    for {
        select {
        case val := <-outChan:
            fmt.Println("finished:", val)
        case err := <-errChan:
            fmt.Println("error:", err)
            break Loop
        case <-finishChan:
            break Loop
        }
    }
```

這邊我們看到需要加上 `Loop` 自定義 Tag，來達到 break for 迴圈，而不是 break select 函式。但是有沒有發現程式碼會一直卡在 `wg.Wait()`，不會進入到 for 迴圈內，這時候就必須將 `wg.Wait()` 丟到背景。

```go
    go func() {
        wg.Wait()
        fmt.Println("finish all job")
        close(finishChan)
    }()
```

也就是當 20 個 job 都完成後，會觸發 `close(finishChan)`，就可以在 for 迴圈內結束整個 main 函式。最後需要設定 timout 機制，請把 select 多補上一個 `time.After()`

```go
Loop:
    for {
        select {
        case val := <-outChan:
            fmt.Println("finished:", val)
        case err := <-errChan:
            fmt.Println("error:", err)
            break Loop
        case <-finishChan:
            break Loop
        case <-time.After(100000 * time.Millisecond):
            break Loop
        }
    }
```

來看看 go func 內怎麼將值丟到 Channel

```go
    for i := 0; i < 20; i++ {
        go func(outChan chan<- int, errChan chan<- error, val int, wg *sync.WaitGroup) {
            defer wg.Done()
            time.Sleep(time.Duration(rand.Int31n(1000)) * time.Millisecond)
            fmt.Println("finished job id:", val)
            outChan <- val
            if val == 11 {
                errChan <- errors.New("error in 60")
            }

        }(outChan, errChan, i, &wg)
    }
```

宣告 `chan<- int` 代表在 go func 只能將訊息丟到通道內，而不能讀取通道。

## 心得

希望透過上述簡單的例子，讓大家初學 Go 的時候有個基礎的理解。用法其實不難，但是請參考專案內容特性來決定如何使用 Channel，最後附上完整的程式碼:

```go
package main

import (
    "errors"
    "fmt"
    "math/rand"
    "sync"
    "time"
)

func main() {
    outChan := make(chan int)
    errChan := make(chan error)
    finishChan := make(chan struct{})
    wg := sync.WaitGroup{}
    wg.Add(100)
    for i := 0; i < 100; i++ {
        go func(outChan chan<- int, errChan chan<- error, val int, wg *sync.WaitGroup) {
            defer wg.Done()
            time.Sleep(time.Duration(rand.Int31n(1000)) * time.Millisecond)
            fmt.Println("finished job id:", val)
            outChan <- val
            if val == 60 {
                errChan <- errors.New("error in 60")
            }

        }(outChan, errChan, i, &wg)
    }

    go func() {
        wg.Wait()
        fmt.Println("finish all job")
        close(finishChan)
    }()

Loop:
    for {
        select {
        case val := <-outChan:
            fmt.Println("finished:", val)
        case err := <-errChan:
            fmt.Println("error:", err)
            break Loop
        case <-finishChan:
            break Loop
        case <-time.After(100000 * time.Millisecond):
            break Loop
        }
    }
}
```

也可以在 [Go Playground 試試看][6]。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://golang.org
 [3]: https://blog.golang.org/pipelines
 [4]: https://tour.golang.org/concurrency/1
 [5]: https://blog.wu-boy.com/2019/04/understand-unbuffered-vs-buffered-channel-in-five-minutes/
 [6]: https://play.golang.org/p/gMwNVc4Ve8b