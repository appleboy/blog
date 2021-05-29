---
title: Go 語言效能檢查工具 pprof
author: appleboy
type: post
date: 2020-06-07T04:50:11+00:00
draft: true
url: /?p=7712
dsq_thread_id:
  - 8063357561
categories:
  - Golang
tags:
  - golang
  - pprof

---
[![golang logo][1]][1]

Go 語言除了內建強大的測試工具 ([go test][2]) 之外，也提供了效能評估的工具 ([go tool pprof][3])，整個生態鏈非常完整，這也是我推薦大家使用 Go 語言的最大原因，這篇會介紹如何使用 pprof 來找出效能瓶頸的地方。假設開發者在寫任何邏輯功能時，發現跑出來的速度不是想像的這麼快，或者是在串接服務流程時，整個回覆時間特別久，這時候可以透過 benchmark 先找出原因。

<pre><code class="language-sh">go test -bench=. -benchtime=3s ./lexer/</code></pre>

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://golang.org/pkg/testing/
 [3]: https://blog.golang.org/pprof