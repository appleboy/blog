---
title: 用 Go 語言 buffered channel 實作 Job Queue
author: appleboy
type: post
date: 2019-11-02T14:53:39+00:00
url: /2019/11/implement-job-queue-using-buffer-channel-in-golang/
dsq_thread_id:
  - 7702246273
categories:
  - Golang
tags:
  - golang
  - golang channel

---
[![][1]][1]

上個月在高雄 mopcon 講了一場『[Job Queue in Golang][2]』，裡面提到蠻多技術細節，但是要在一場 40 分鐘的演講把大家教會，或者是第一次聽到 [Go 語言][3]的，可能都很難在 40 分鐘內吸收完畢，所以我打算分好幾篇部落格來分享細部的實作，本篇會講解投影片第 19 ~ 25 頁，透過本篇你可以清楚學到什麼是 [buffered channel][4]，以及實作的注意事項。

<!--more-->

## 投影片及教學影片

本篇的實作，也有錄製成教學影片，請參考如下:

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][5]
  * [一天學會 DevOps 自動化測試及部署][6]

## 實際案例

怎麼透過 buffered channel 來建立簡單的 Queue 機制。請看底下程式碼:

<pre><code class="language-go">func worker(jobChan <-chan Job) {
    for job := range jobChan {
        process(job)
    }
}

// make a channel with a capacity of 1024.
jobChan := make(chan Job, 1024)

// start the worker
go worker(jobChan)

// enqueue a job
jobChan <- job</code></pre>

上面很清楚看到把 worker 丟到背景，接著將 Job 丟進 Channel 內，就可以在背景做一些比較複雜的工作。但是大家看到 **jobChan <- job** 是不是會想到一個問題，這邊會不會 blocking 啊？答案是會的，那你會說可以把 **1024** 調整大一點啊，這我不否認這是一種解法，但是你還是無法保證不會 blocking 啊。底下用一個簡單的例子來說明問題:

<pre><code class="language-go">package main

import (
    "fmt"
    "time"
)

func worker(jobChan <-chan int) {
    for job := range jobChan {
        fmt.Println("current job:", job)
        time.Sleep(3 * time.Second)
        fmt.Println("finished job:", job)
    }
}

func main() {
    // make a channel with a capacity of 1.
    jobChan := make(chan int, 1)

    // start the worker
    go worker(jobChan)

    // enqueue a job
    fmt.Println("enqueue the job 1")
    jobChan <- 1
    fmt.Println("enqueue the job 2")
    jobChan <- 2
    fmt.Println("enqueue the job 3")
    jobChan <- 3

    fmt.Println("waiting the jobs")
    time.Sleep(10 * time.Second)
}</code></pre>

可以到 [playground][7] 執行上面的例子會輸出什麼？答案如下:

<pre><code class="language-sh">enqueue the job 1
enqueue the job 2
enqueue the job 3
current job: 1 <- 程式被 blocking
finished job: 1
waiting the jobs
current job: 2
finished job: 2
current job: 3
finished job: 3</code></pre>

大家應該都知道這個 main 被 blocking 在 **jobChan <- 3**，因為我們只有設定一個 channel buffer，所以當我們送第一個數字進去 channel 時 (channel buffer 從 0 -> 1)，會馬上被 worker 讀出來 (buffer 從 1 -> 0)，接著送第二個數字進去時，由於 worker 還正在處理第一個 job，所以第二個數字就會被暫時放在 buffer 內，接著送進去第三個數字時 **jobChan <- 3** 這時候會卡在這邊，原因就是 buffer 已經滿了。

這邊有兩種方式來解決主程式被 blocking 的問題，第一個方式很簡單，把丟 Job 的程式碼用 goroutine 丟到背景。也就是改成如下：

<pre><code class="language-go">    fmt.Println("enqueue the job 3")
    go func() {
        jobChan <- 3
    }()</code></pre>

另一種方式透過 select 來判斷 Channel 是否可以送資料進去

<pre><code class="language-go">func enqueue(job int, jobChan chan<- int) bool {
    select {
    case jobChan <- job:
        return true
    default:
        return false
    }
}</code></pre>

有了 **enqueue** 之後，就可以知道目前的 Channel 是否可以送資料，也就是可以直接回應給 User，而不是等待被送入，這邊大家要注意的是使用情境，假設你的 Job 是需要被等待的，那這個方式就不適合，如果 Job 是可以丟棄的，就是用此方式回傳 503 或是其他 error code 告訴使用者目前 Queue 已滿。上面例子改寫如下:

<pre><code class="language-go">    fmt.Println(enqueue(1, jobChan)) // true
    fmt.Println(enqueue(2, jobChan)) // true
    fmt.Println(enqueue(3, jobChan)) // false</code></pre>

可以很清楚知道當程式拿到 **false** 時，就可以做相對應處理，而不會卡到主程式，至於該做什麼處理，取決於商業邏輯。所以 buffer channel 要設定多大，以及達到限制時，該做哪些處理，這些都是在使用 buffer channel 時要考慮進去，來避免主程式或者是 goroutine 被 blocking。上述如果不了解的話，可以參考上面 Youtube 影片，會有很詳細的講解。

 [1]: https://lh3.googleusercontent.com/7QKuBYqzmOWPCbAnS6EMG2ypPSeUYU7VEl9sF66zv9cIUCWwErs4CF1qNkWcwKdM7TmR-ygyqWkBvGhPnPQemG1bJl6bxj6ZcNNcS_uecl2xXFXp9qRFJyCqUzYnCfneOPgRPrInO8U=w1920-h1080
 [2]: https://www.slideshare.net/appleboy/job-queue-in-golang-184064840
 [3]: https://golang.org
 [4]: https://tour.golang.org/concurrency/3
 [5]: https://www.udemy.com/course/golang-fight/?couponCode=GOLANG201911
 [6]: https://www.udemy.com/course/devops-oneday/?couponCode=DEVOPS201911
 [7]: https://play.golang.org/p/FWEP93eCaj2