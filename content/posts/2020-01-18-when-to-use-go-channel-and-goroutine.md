---
title: 使用 Go Channel 及 Goroutine 時機
author: appleboy
type: post
date: 2020-01-18T06:11:54+00:00
url: /2020/01/when-to-use-go-channel-and-goroutine/
dsq_thread_id:
  - 7823531388
categories:
  - Golang
tags:
  - golang
  - golang channel

---
[![golang logo][1]][1]

相信不少開發者肯定聽過 Go 語言之所以讓人非常喜歡，就是因為 Go concurrency，如果您對於 concurrency 不了解的朋友們，可以直接參考[官網的範例][2]開始了解，範例會帶您一步一步了解什麼是 Channel 什麼是 Go concurrency？本篇會介紹 Channel 使用時機，在大部分寫 application 時，老實說很少用到 Channel，所以很多人其實不知道該在哪種場景需要使用 Channel，底下這句名言大家肯定聽過:

> Do not communicate by sharing memory; instead, share memory by communicating.

本篇會用簡單的例子來帶大家理解上述名言。

<!--more-->

## 教學影片

更多實戰影片可以參考我的 Udemy 教學系列

  * [Go 語言實戰課程][3]
  * [Drone CI/CD 自動化課程][4]

## Channel 基本知識

Channel 分成讀跟寫，如果在實戰內用到非常多 Channel，請注意在程式碼任何地方對 Channel 進行讀寫都有可能造成不同的狀況，所以為了避免團隊內濫用 Channel，通常我都會限定在哪個情境只能寫，在哪個情境只能讀。如果混著用，最後會非常難除錯，也造成 Reviewer 非常難閱讀跟理解。

<pre><code class="language-go">Write(chan&lt;- int)
Read(&lt;-chan int)
ReadWrite(chan int)</code></pre>

分辨讀寫非常容易，請看 <- 符號放在哪邊，chan<- 指向自己就是寫，<-chan 離開自己就是讀，相當好分辨，如果 func 內讀寫都需要使用，則不需要使用任何箭頭符號，但是我會建議把讀寫的邏輯都拆開不同的 func 處理，對於閱讀上非常有幫助。

## Communicating by sharing memory

其實不管在哪一個語言都會有類似範例，底下用 Go 來[舉例][5]

<pre><code class="language-go">package main

import (
    "fmt"
    "sync"
)

func addByShareMemory(n int) []int {
    var ints []int
    var wg sync.WaitGroup

    wg.Add(n)
    for i := 0; i &lt; n; i++ {
        go func(i int) {
            defer wg.Done()
            ints = append(ints, i)
        }(i)
    }

    wg.Wait()
    return ints
}

func main() {
    foo := addByShareMemory(10)
    fmt.Println(len(foo))
    fmt.Println(foo)
}</code></pre>

請直接將程式碼放到您的電腦執行，原本 ints 應該可以正常拿到 10 個值，但是你會發現每次拿到的結果都是不同的，原因就是在 func 內宣告 ints 是 []int，而在 goroutine 內是共享這變數，但是有可能在同一時間點對同位址 memory 進行讀寫，所以可以看到每次執行出來的結果都是不同的。用 goroutine 進行變數讀寫時，盡量不要用 share memory 來共享，有時候出錯真的蠻難 debug 的。

底下講幾個解決方式，有些方式不適合用在專案內。第一個就是透過修改 **GOMAXPROCS**:

<pre><code class="language-go">package main

import (
    "fmt"
    "runtime"
    "sync"
)

func init() {
    runtime.GOMAXPROCS(1)
}
</code></pre>

原本會根據 CPU 有多少顆，做多少平行處理，但是可以透過 GOMAXPROCS 設定使用的 CPU 數量，這樣執行出來的結果就可以符合預期，但是誰會在 application 內使用 GOMAXPROCS，完全不合邏輯啊。另一種方式就是使用 **sync** 來解決:

<pre><code class="language-go">func addByShareMemory(n int) []int {
    var ints []int
    var wg sync.WaitGroup
    var mux sync.Mutex

    wg.Add(n)
    for i := 0; i &lt; n; i++ {
        go func(i int) {
            defer wg.Done()
            mux.Lock()
            ints = append(ints, i)
            mux.Unlock()
        }(i)
    }

    wg.Wait()
    return ints
}</code></pre>

只要是讀寫 ints 前面就放上 Lock，變數就不會被覆蓋，寫完之後就可以使用 Unlock 來解除，更簡單一點，可以使用 defer 來 Unlock。由於丟到 goroutine 方式來平行處理，所以需要使用 **WaitGroup** 確保全部 goroutine 拿到資料後，才結束 func。

## Share memory by communicating

上面的例子可以看到使用了 **sync.WaitGroup** 及 **sync.Mutex** 才能完成 goroutine 拿到正確資料，如果是透過 Channel 方式是否可以避免上面提到的問題呢？

<pre><code class="language-go">func addByShareCommunicate(n int) []int {
    var ints []int
    channel := make(chan int, n)

    for i := 0; i &lt; n; i++ {
        go func(channel chan&lt;- int, order int) {
            channel &lt;- order
        }(channel, i)
    }

    for i := range channel {
        ints = append(ints, i)

        if len(ints) == n {
            break
        }
    }

    close(channel)

    return ints
}</code></pre>

從上面範例可以看到能夠寫入 **ints** 變數的只有一個 for 迴圈，這就是所謂的建立一個 channel 當作 share memory by communicating，而不是把一個變數丟進 goroutine 進行共享造成錯誤。

上面先使用了 goroutine 來進行寫入 channel，所以可以看到第一個參數使用 **chan<- int** 確保在此 goroutine 只能寫入 channel，而不能從 channle 讀資料出來。接著後面使用一個 for 迴圈，陸續將 channle 裡面的值讀出來。用了 channel 就再也不需要 WaitGroup 及 Lock 機制，只要確保最後讀取 channel 後，要把 channle 關閉。

## Benchmark

我們把上面兩種實作方式做 Benchmark，結果如下:

<pre><code class="language-bash">goos: darwin
goarch: amd64
BenchmarkAddByShareMemory-8        31131   38005 ns/op  2098 B/op  11 allocs/op
BenchmarkAddByShareCommunicate-8   22915   51837 ns/op  2936 B/op   9 allocs/op
PASS</code></pre>

可以發現其實第一種透過 waitGroup + Lock 方式會比用 Channel 效能還好。

## 結論

可以總結底下兩點是我個人覺得可以參考的依據:

  * 除非是兩個 goruoutine 之間需要交換訊息，否則還是使用一般的 waitGroup + Lock 效能會比較好。不要因為使用 channel 比較潮，而強制在專案內使用。在很多狀況底下一般的 Slice 或 callback 效能會比較好。
  * 如上面所說，使用了大量的 goroutine，中間需要交換資料，這時候就可以使用 Channel 來進行溝通，雖然如同上面的數據，效能也許會差一些，但是後續的 maintain 以及效能瓶頸，都不會是在交換 Channel 上面。

上面程式範例可以在[這邊找到][6]。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://tour.golang.org/concurrency/1
 [3]: https://www.udemy.com/course/golang-fight/?couponCode=202001
 [4]: https://www.udemy.com/devops-oneday/?couponCode=202001
 [5]: https://play.golang.org/p/GhFGWgq1YOa
 [6]: https://github.com/go-training/training/tree/master/example33-share-memory-by-communicating "這邊找到"