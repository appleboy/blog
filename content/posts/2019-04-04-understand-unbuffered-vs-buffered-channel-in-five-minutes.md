---
title: 用五分鐘了解什麼是 unbuffered vs buffered channel
author: appleboy
type: post
date: 2019-04-04T01:05:53+00:00
url: /2019/04/understand-unbuffered-vs-buffered-channel-in-five-minutes/
dsq_thread_id:
  - 7336239358
categories:
  - Golang
tags:
  - golang
  - golang channel

---
[![golang logo][1]][1]

本篇要跟大家聊聊在 [Go 語言][2]內什麼是『unbuffered vs buffered channel』，在初學 Go 語言時，最大的挑戰就是了解 Channel 的使用時機及差異，而 Channel 又分為兩種，一種是 buffered channel，另一種是 unbuffered channel，底下我來用幾個簡單的例子帶大家了解這兩種 channel 的差異，讓初學者可以很快的了解 channel 使用方式。

<!--more-->

## 教學影片

直接看影片比較快，五分鐘左右就可以初學了解 channel

  * 00:22 unbuffered channel
  * 02:32 buffered channel

更多實戰影片可以參考我的 Udemy 教學系列

  * Go 語言實戰課程: <http://bit.ly/golang-2019>
  * Drone CI/CD 自動化課程: <http://bit.ly/drone-2019>

## Unbuffered Channel

在 Go 語言內使用 goroutine 是很常見的，但是我們該如何透過 Channel 來解決同步問題，請看底下例子

<pre><code class="language-go">func main() {
    go func() {
        fmt.Println("GO GO GO")
    }()
    time.Sleep(1 * time.Second)
}</code></pre>

上面的例子在執行完 main 函數，就會直接跳出，所以後面設定了等待一秒可以解決此問題，但是一般開發模式不會加上 Timeout，這邊該如何透過 Unbuffered Channel 方式來達到一樣的效果。

<pre><code class="language-go">func main() {
    c := make(chan bool)
    go func() {
        fmt.Println("GO GO GO")
        c <- true
    }()
    <-c
}</code></pre>

可以看到上面我用了 make(chan bool) 來建立一個 channel，當在 main 函數最後用 <-c 代表需要等待讀出一個 channel 值，main 函數才會結束，這時候就達到了跟用 Sleep 一樣的效果，接著將程式碼改成如下:

<pre><code class="language-go">func main() {
    c := make(chan bool)
    go func() {
        fmt.Println("GO GO GO")
        <-c
    }()
    c <- true
}</code></pre>

你會發現得到同樣的結果，為什麼呢？因為 unbufferd channel 的用途就是，今天在程式碼內丟了一個值進去 channel，這時候 main 函式就需要等到一個 channel 值被讀出來才會結束，所以不管你在 goroutine 內讀或寫，main 都需要等到一個寫一個讀完成後才會結束程式。這就是用 unbuffered channel 來達到同步的效果，也就是保證讀寫都需要執行完畢才可以結束主程式。

## buffered Channel

那 buffered Channel 呢，差異在於宣告方式，請看底下例子

<pre><code class="language-go">func main() {
    c := make(chan bool, 1)
    go func() {
        fmt.Println("GO GO GO")
        <-c
    }()
    c <- true
}</code></pre>

可以很清楚知道 buffered channel 是透過 make(chan bool, 1) 後面有帶容量值，開發者可以一次宣告此 channel 可以容納幾個值，大家可以執行看看上述程式碼，會發現完全沒有輸出東西，原因是什麼，buffered channel 就是只要容量有多少，你都可以一直塞值進去，但是不用讀出來沒關係，所以當丟了 c <- true 進去後，主程式不會等到讀出來才結束，造成使用者沒有看到 fmt.Println("GO GO GO")，這就是最大的差異。

<pre><code class="language-go">func main() {
    c := make(chan bool, 1)
    go func() {
        fmt.Println("GO GO GO")
       c <- true
    }()
    <-c
} </code></pre>

## 結論

大家記住 unbuffered channel 就是代表在主程式內，需要等到讀或寫都完成，main 才可以完整結束 (讀跟寫 buffered channel 需要在不同的 goroutine 才不會被 block)，而 buffered channel 相反，你可以一直丟資料進去 Channel 內，但是不需要讀出來（前提是 buffered channel 空間夠大不會爆掉），所以 main 才提前結束。如果您想要用 channel 做到同步或異步的效果，這邊就需要注意了。希望本邊有幫助到大家初學 Channel。之後會有更多深入的文章來講解 Channel，如果要看更多 Go 影片可以[參考這邊][3]。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://golang.org "Go 語言"
 [3]: http://bit.ly/golang-2019