---
title: Go 語言的 init 函式
author: appleboy
type: post
date: 2018-04-19T03:17:00+00:00
url: /2018/04/init-func-in-golang/
dsq_thread_id:
  - 6621700067
categories:
  - Golang
tags:
  - golang

---
[<img src="https://i1.wp.com/farm2.staticflickr.com/1622/24407557644_36087ca6de.jpg?w=840&#038;ssl=1" alt="Go-brown-side.sh" data-recalc-dims="1" />][1]

本篇會帶大家認識 [Go 語言][2]的 init 函式，在了解 init func 之前，大家應該都知道在同一個 Package 底下是不可以有重複的變數或者是函式名稱，但是唯獨 init() 可以在同一個 package 內宣告多次都沒問題。底下看[例子][3]，可以發現的是不管宣告多少次，都會依序從最初宣告到最後宣告依序執行下來。

<pre><code class="language-go">package main

import (
    "fmt"
)

func init() {
    fmt.Println("init 1")
}

func init() {
    fmt.Println("init 2")
}

func main() {
    fmt.Println("Hello, playground")
}</code></pre>

<!--more-->

## 從其他 package 讀取 init func

有種狀況底下，主程式需要單獨讀取 package 內的 init func 而不讀取額外的變數，這時候就要透過 `_` 來讀取 package。假設要讀取 [lib/pq][4] 內的 [init][5]，一定要使用 `_`

<pre><code class="language-go">import(
    // Needed for the Postgresql driver
    _ "github.com/lib/pq
)</code></pre>

如果沒有加上 `_`，當編譯的時候就會報錯，原因就是 main 主程式內沒有用到 pq 內任何非 init() 的功能，所以不可編譯成功。如果有多個 package 的 init 需要同時引入，這邊也是會依照 import 的順序來讀取。

## init 執行時機

大家一定很好奇 init 的執行時間是什麼時候，底下舉個[例子][6]

<pre><code class="language-go">var global = convert()

func convert() int {
    return 100
}

func init() {
    global = 0
}

func main() {
    fmt.Println("global is", global)
}</code></pre>

或者是把 init() 放到最上面

<pre><code class="language-go">func init() {
    global = 0
}

var global = convert()

func convert() int {
    return 100
}

func main() {
    fmt.Println("global is", global)
}</code></pre>

兩種結果都是 0，這邊大家就可以知，init 執行的時機會是在執行 main func 之前，所以不管前面做了哪些事情，都不會影響 init 的執行結果。最後提醒大家，只要 package 內有 init 的 func，在引入 package 時都會被執行。

## 線上影片

* * *

Go 語言線上課程目前特價 $1600，持續錄製中，每週都會有新的影片上架，歡迎大家參考看看，請點選底下購買連結:

# [點我購買][7]

 [1]: https://www.flickr.com/photos/appleboy/24407557644/in/dateposted-public/ "Go-brown-side.sh"
 [2]: https://golang.org
 [3]: https://play.golang.org/p/AN-6MK4qVVL
 [4]: https://github.com/lib/pq
 [5]: https://github.com/lib/pq/blob/master/conn.go#L48-L50
 [6]: https://github.com/go-training/training/blob/990af0ec6605e1e5f9ce239cc9380d79d80ddbce/example16-init-func/main.go#L10-L22
 [7]: http://bit.ly/intro-golang