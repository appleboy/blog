---
title: 用 Go 語言實戰 Limit Concurrency 方法
author: appleboy
type: post
date: 2020-09-06T02:31:59+00:00
url: /2020/09/limit-concurrency-in-golang/
dsq_thread_id:
  - 8191961358
categories:
  - Golang
tags:
  - concurrency
  - golang

---
[![golang logo][1]][1]

最近看到一篇文章討論的非常熱烈，就是『[concurrency is still not easy][2]』這篇文章甚至上了 [Hack News][3]，大家有興趣可以點進去看看，而本篇會用一個實際案例介紹為什麼作者會說寫 Concurrency 不是這麼容易。大家都知道在 [Go 語言][4]內，要寫 Concurrency 只要透過一個關鍵字 `go` 就可以輕易寫出，而多個 Goroutine 要溝通就是需要透過 Channel 方式，而網路上有一堆 Concurrency Pattern 提供給各位開發者，但是官方 Go 的標準庫內並沒有包含這些 Pattern，所以實作之後，說實在很難看出問題。文章內提到 [gops][5] 實作 Limit Concurrency 遇到系統整個 hang 住的問題？什麼是 Limit Concurrency，就是當系統有多個工作需要同時執行，但是需要限制 Concurrency 數量，避免整個資源都被吃光。底下來介紹文章內遇到的問題。

<!--more-->

## 教學影片

{{< youtube jA7aYSRKVTQ >}}

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][6]
  * [一天學會 DevOps 自動化測試及部署][7]
  * [DOCKER 容器開發部署實戰][8]

如果需要搭配購買請直接透過 [FB 聯絡我][9]，直接匯款（價格再減 **100**）

## Limit Concurrency 問題

Gops 是一套 CLI 工具，可以列出系統上正在用 Go 跑的全部 Process。要怎樣複製問題呢？很簡單，先安裝好 gops 指令後，先執行 `gops` 會看到底下結果

```shell=
$ gops
98   1    com.docker.vmnetd  go1.13.14 com.docker.vmnetd
2319 2275 gopls              go1.15    /Users/appleboy/go/bin/gopls
4083 452  gops               go1.15    /Users/appleboy/go/bin/gops
```

接著用底下程式碼繼續將 process 塞滿到 10 個，這時候在執行 `gops` 會發現系統完全不顯示了，也沒辦法結束。

```go
package main

import (
    "fmt"
    "time"
)

func main() {

    timer1 := time.NewTicker(1 * time.Second)

    for v := range timer1.C {
        fmt.Println(v)
    }
}
```

這問題發生在 8/5 有網友提出了 [PR 去限制 Concurrency][10]，這寫法造成了上述出現的問題，導致 CLI 整個無法繼續運作，需要用 `ctrl + c` 才可以結束執行。底下是[修改過後的程式碼][11]:

```go
// FindAll returns all the Go processes currently running on this host.
func FindAll() []P {
    const concurrencyProcesses = 10 // limit the maximum number of concurrent reading process tasks
    pss, err := ps.Processes()
    if err != nil {
        return nil
    }

    var wg sync.WaitGroup
    wg.Add(len(pss))
    found := make(chan P)
    limitCh := make(chan struct{}, concurrencyProcesses)

    for _, pr := range pss {
        limitCh <- struct{}{}
        pr := pr
        go func() {
            defer func() { <-limitCh }()
            defer wg.Done()

            path, version, agent, ok, err := isGo(pr)
            if err != nil {
                // TODO(jbd): Return a list of errors.
            }
            if !ok {
                return
            }
            found <- P{
                PID:          pr.Pid(),
                PPID:         pr.PPid(),
                Exec:         pr.Executable(),
                Path:         path,
                BuildVersion: version,
                Agent:        agent,
            }
        }()
    }
    go func() {
        wg.Wait()
        close(found)
    }()
    var results []P
    for p := range found {
        results = append(results, p)
    }
    return results
}
```

我將上面的例子簡化寫成單一 main 函式來執行，效果是一樣的:

```go
package main

import (
    "fmt"
    "math/rand"
    "sync"
    "time"
)

func main() {
    const concurrencyProcesses = 10 // limit the maximum number of concurrent reading process tasks
    const jobCount = 100

    var wg sync.WaitGroup
    wg.Add(jobCount)
    found := make(chan int)
    limitCh := make(chan struct{}, concurrencyProcesses)

    for i := 0; i < jobCount; i++ {
        limitCh <- struct{}{}
        go func(val int) {
            defer func() {
                wg.Done()
                <-limitCh
            }()
            waitTime := rand.Int31n(1000)
            fmt.Println("job:", val, "wait time:", waitTime, "millisecond")
            time.Sleep(time.Duration(waitTime) * time.Millisecond)
            found <- val
        }(i)
    }
    go func() {
        wg.Wait()
        close(found)
    }()
    var results []int
    for p := range found {
        fmt.Println("Finished job:", p)
        results = append(results, p)
    }

    fmt.Println("result:", results)
}
```

我把 `ps.Processes()` 的資料，換成 Job 數量來代表，來解釋為什麼麼這段程式碼造成了系統直接 hang 住不動。重點原因在 for 迴圈內的 `limitCh <- struct{}{}`，先看到前面有設定了背景一次只能跑 10 個 Concurrency Processes

```go
    for i := 0; i < jobCount; i++ {
        limitCh <- struct{}{}
        go func(val int) {
            ....
        }(i)
    }
```

這是一個標準的 Limit Concurrency 問題，在讀取第一個 Job 後，先將空 struct 丟入 limitCh 通道，這時候 limitCh 就是剩下 9 個可以繼續處理，接著持續一樣的動作，但是到第 11 個 Job 需要處理時，就會直接停在 `limitCh <- struct{}{}`，在 for 迴圈後面的程式碼完全沒辦法執行，造成整個系統 deadlock，由此可知道，如果 Process 數量小於 10 的話，幾乎看不出來有任何問題，系統都可以正常運作 (大家可以把範例的 Job Count 換成 10)。下面會介紹兩種方式繞過此問題，大家可以參考看看

## 將 limitCh <- struct{}{} 丟到背景處理

相信很多開發者可能會想到，既然卡在 `limitCh <- struct{}{}`，那就將此段程式碼也一樣丟到 goroutine 內處理就可以了。

```go
    found := make(chan int)
    limitCh := make(chan struct{}, concurrencyProcesses)

    for i := 0; i < jobCount; i++ {
        go func() {
            limitCh <- struct{}{}
        }()
        go func(val int) {
            defer func() {
                <-limitCh
                wg.Done()
            }()
            waitTime := rand.Int31n(1000)
            fmt.Println("job:", val, "wait time:", waitTime, "millisecond")
            time.Sleep(time.Duration(waitTime) * time.Millisecond)
            found <- val
        }(i)
    }
```

很高興可以看到這方式解決掉系統 Hang 住的問題。但是你有沒有發現，程式碼沒辦法限制 Concurrency Processes，而是 100 個 Job 同時處理到結束。雖然這方式可以解決問題，但是回到問題的初衷，我們就是要寫 Limit Concurrency 啊。

## 使用 worker queue 寫法

這寫法算是蠻常見的，既然要限制背景能同時處理的數量，那相對的就是建立特定數量的 Worker，每個 Worker 內在讀取 Channle 內的資料出來。第一步驟建立 queue 通道，並將所有的內容都丟進 queue 內

```go
    found := make(chan int)
    queue := make(chan int)

    go func(queue chan<- int) {
        for i := 0; i < jobCount; i++ {
            queue <- i
        }
        close(queue)
    }(queue)
```

這邊一樣是透過 goroutine 方式丟到背景，避免 block 整個 main 程式。接著建立特定的 Worker 數量來消化全部的 Job

```go
    for i := 0; i < concurrencyProcesses; i++ {
        go func(queue <-chan int, found chan<- int) {
            for val := range queue {
                defer wg.Done()
                waitTime := rand.Int31n(1000)
                fmt.Println("job:", val, "wait time:", waitTime, "millisecond")
                time.Sleep(time.Duration(waitTime) * time.Millisecond)
                found <- val
            }
        }(queue, found)
    }
```

可以看到這邊的 for 迴圈就是以 `concurrencyProcesses` 為主了，裡面再用 goroutine 方式來讀取 Channel，直到全部的 Channel 都讀取完畢，整個 goroutine 就會結束。除了這解決方式之外，還是有其他方法可以實作，這邊就交由大家去發揮了。

## 心得

這篇文章為什麼這麼火紅的原因，我猜也因為是該 Repo 是 Google 官方自行開發，但是所有的 PR 都需要經過 Googler 嚴格 Review 過後才可以 Merge 進 Master 分支，但是像這種小細節，如果沒有真的實際測試，真的還蠻難發現問題。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://utcc.utoronto.ca/~cks/space/blog/programming/GoConcurrencyStillNotEasy
 [3]: https://news.ycombinator.com/item?id=24359650
 [4]: https://golang.org
 [5]: https://github.com/google/gops
 [6]: https://www.udemy.com/course/golang-fight/?couponCode=202008
 [7]: https://www.udemy.com/course/devops-oneday/?couponCode=202008
 [8]: https://www.udemy.com/course/docker-practice/?couponCode=202008
 [9]: http://facebook.com/appleboy46
 [10]: https://github.com/google/gops/pull/118
 [11]: https://github.com/google/gops/blob/6fb0d860e5fa50629405d9e77e255cd32795967e/goprocess/gp.go#L28-L74
