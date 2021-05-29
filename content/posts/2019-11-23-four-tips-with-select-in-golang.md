---
title: Go 語言使用 Select 四大用法
author: appleboy
type: post
date: 2019-11-23T01:36:32+00:00
url: /2019/11/four-tips-with-select-in-golang/
dsq_thread_id:
  - 7729404781
categories:
  - Golang

---
[![photo][1]][1]

本篇教學要帶大家認識 [Go 語言][2]的 [Select][3] 用法，相信大家對於 switch 並不陌生，但是 `select` 跟 `switch` 有個共同特性就是都過 case 的方式來處理，但是 select 跟 switch 處理的事情完全不同，也完全不相容。來看看 switch 有什麼特性: 各種類型及型別操作，接口 `interface{}` 型別判斷 `variable.(type)`，重點是會依照 case **順序依序執行**。底下看個例子:

<!--more-->

<pre><code class="language-go">package main

var (
    i interface{}
)

func convert(i interface{}) {
    switch t := i.(type) {
    case int:
        println("i is interger", t)
    case string:
        println("i is string", t)
    case float64:
        println("i is float64", t)
    default:
        println("type not found")
    }
}

func main() {
    i = 100
    convert(i)
    i = float64(45.55)
    convert(i)
    i = "foo"
    convert(i)
    convert(float32(10.0))
}</code></pre>

跑出來的結果如下:

<pre><code class="language-sh">i is interger 100
i is float64 +4.555000e+001
i is string foo
type not found</code></pre>

而 `select` 的特性就不同了，只能接 channel 否則會出錯，`default` 會直接執行，所以沒有 `default` 的 select 就會遇到 blocking，假設沒有送 value 進去 Channel 就會造成 panic，底下拿幾個實際例子來解說。

## 教學影片

此篇部落格內容有錄製成影片放在 Udemy 平台上面，有興趣的可以直接參考底下:

  * [Go 語言基礎實戰 (開發, 測試及部署)][4]
  * [一天學會 DevOps 自動化測試及部署][5]

## Random Select

同一個 channel 在 select 會隨機選取，底下看個例子:

<pre><code class="language-go">package main

import "fmt"

func main() {
    ch := make(chan int, 1)

    ch <- 1
    select {
    case <-ch:
        fmt.Println("random 01")
    case <-ch:
        fmt.Println("random 02")
    }
}</code></pre>

執行後會發現有時候拿到 `random 01` 有時候拿到 `random 02`，這就是 select 的特性之一，case 是隨機選取，所以當 select 有兩個 channel 以上時，如果同時對全部 channel 送資料，則會隨機選取到不同的 Channel。而上面有提到另一個特性『假設沒有送 value 進去 Channel 就會造成 panic』，拿上面例子來改:

<pre><code class="language-go">func main() {
    ch := make(chan int, 1)

    select {
    case <-ch:
        fmt.Println("random 01")
    case <-ch:
        fmt.Println("random 02")
    }
}</code></pre>

執行後會發現變成 deadlock，造成 main 主程式爆炸，這時候可以直接用 `default` 方式解決此問題:

<pre><code class="language-go">func main() {
    ch := make(chan int, 1)

    select {
    case <-ch:
        fmt.Println("random 01")
    case <-ch:
        fmt.Println("random 02")
    default:
        fmt.Println("exit")
    }
}</code></pre>

主程式 main 就不會因為讀不到 channel value 造成整個程式 deadlock。

## Timeout 超時機制

用 select 讀取 channle 時，一定會實作超過一定時間後就做其他事情，而不是一直 blocking 在 select 內。底下是簡單的例子:

<pre><code class="language-go">package main

import (
    "fmt"
    "time"
)

func main() {
    timeout := make(chan bool, 1)
    go func() {
        time.Sleep(2 * time.Second)
        timeout <- true
    }()
    ch := make(chan int)
    select {
    case <-ch:
    case <-timeout:
        fmt.Println("timeout 01")
    }
}</code></pre>

建立 timeout channel，讓其他地方可以透過 trigger timeout channel 達到讓 select 執行結束，也或者有另一個寫法是透握 `time.After` 機制

<pre><code class="language-go">    select {
    case <-ch:
    case <-timeout:
        fmt.Println("timeout 01")
    case <-time.After(time.Second * 1):
        fmt.Println("timeout 02")
    }</code></pre>

可以注意 `time.After` 是回傳 `chan time.Time`，所以執行 select 超過一秒時，就會輸出 **timeout 02**。

## 檢查 channel 是否已滿

直接來看例子比較快:

<pre><code class="language-go">package main

import (
    "fmt"
)

func main() {
    ch := make(chan int, 1)
    ch <- 1
    select {
    case ch <- 2:
        fmt.Println("channel value is", <-ch)
        fmt.Println("channel value is", <-ch)
    default:
        fmt.Println("channel blocking")
    }
}</code></pre>

先宣告 buffer size 為 1 的 channel，先丟值把 channel 填滿。這時候可以透過 `select + default` 方式來確保 channel 是否已滿，上面例子會輸出 **channel blocking**，我們再把程式改成底下

<pre><code class="language-go">func main() {
    ch := make(chan int, 2)
    ch <- 1
    select {
    case ch <- 2:
        fmt.Println("channel value is", <-ch)
        fmt.Println("channel value is", <-ch)
    default:
        fmt.Println("channel blocking")
    }
}</code></pre>

把 buffer size 改為 2 後，就可以繼續在塞 value 進去 channel 了，這邊的 buffer channel 觀念可以看之前的文章『[用五分鐘了解什麼是 unbuffered vs buffered channel][6]』

## select for loop 用法

如果你有多個 channel 需要讀取，而讀取是不間斷的，就必須使用 for + select 機制來實現，更詳細的實作可以參考『[15 分鐘學習 Go 語言如何處理多個 Channel 通道][7]』

<pre><code class="language-go">package main

import (
    "fmt"
    "time"
)

func main() {
    i := 0
    ch := make(chan string, 0)
    defer func() {
        close(ch)
    }()

    go func() {
    LOOP:
        for {
            time.Sleep(1 * time.Second)
            fmt.Println(time.Now().Unix())
            i++

            select {
            case m := <-ch:
                println(m)
                break LOOP
            default:
            }
        }
    }()

    time.Sleep(time.Second * 4)
    ch <- "stop"
}</code></pre>

上面例子可以發現執行後如下:

<pre><code class="language-sh">1574474619
1574474620
1574474621
1574474622</code></pre>

其實把 `default` 拿掉也可以達到目的

<pre><code class="language-go">select {
case m := <-ch:
    println(m)
    break LOOP</code></pre>

當沒有值送進來時，就會一直停在 select 區段，所以其實沒有 `default` 也是可以正常運作的，而要結束 for 或 select 都需要透過 break 來結束，但是要在 select 區間直接結束掉 for 迴圈，只能使用 `break variable` 來結束，這邊是大家需要注意的地方。

 [1]: https://lh3.googleusercontent.com/CXyuE0Z1x4_dEciwiP9HRfXD2kHiola3SI-dAsU_HciuBxb3nA_NyZewO70gGlvA59eLapIRAEO0TZbAAx_z85Uqp-OGWx06-3lZ3HilrhnXvbr3nsilF1TcYIhSOtud_G7-wldkZNo=w1920-h1080 "photo"
 [2]: https://golang.org
 [3]: https://tour.golang.org/concurrency/5
 [4]: https://www.udemy.com/course/golang-fight/?couponCode=20191201
 [5]: https://www.udemy.com/course/devops-oneday/?couponCode=20191201
 [6]: https://blog.wu-boy.com/2019/04/understand-unbuffered-vs-buffered-channel-in-five-minutes/
 [7]: https://blog.wu-boy.com/2019/05/handle-multiple-channel-in-15-minutes/ "15 分鐘學習 Go 語言如何處理多個 Channel 通道"