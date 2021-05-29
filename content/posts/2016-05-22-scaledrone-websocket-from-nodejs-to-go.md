---
title: ScaleDrone Websocket 平台從 Node.js 轉換到 Golang
author: appleboy
type: post
date: 2016-05-22T07:51:03+00:00
url: /2016/05/scaledrone-websocket-from-nodejs-to-go/
dsq_thread_id:
  - 4847761764
categories:
  - Golang
  - javascript
  - NodeJS
tags:
  - golang
  - JavaScrpt
  - Node.js
  - websocket

---
[![][1]][1]

又看到一間網路平台公司從 [Node.js][2] 跳到 [Golang][3] 了。[ScaleDrone][4] 是一間提供了 [websocket][5] 服務的公司，讓 web 可以透過 ScaleDrone 即時將訊息傳播到各種瀏覽器，但是今天看到 ScaleDrone 即將把後端平台使用的語言從 [Node.js 轉換到 Golang][6]，為什麼要轉語言呢，官方提到大量的 Websocket 連線，讓伺服器記憶體快吃不消了，然而 ScaleDrone 用 Go 語言來實際測試，發現記憶體不但沒有增加，反而還降低了 response 及 connections 時間。底下是針對 Node.js vs Go 語言轉換比較。

<!--more-->

## Performance 效能

Node.js 使用了 event-driven, non-blocking I/O 模型，一種說法是程式設計師不需要考慮 concurrency，另一種說法是 JavaScript 及 Node.js 在 concurrency 是有效能限制的。ScaleDrone 實際拿了 Websocket 來做實驗，發現 Golang 在 Websocket 表現上足足快了 Node.js 三倍，當然這不代表 Node.js 是不好的語言，只是為了證明，如果針對 websocket 長期考量來說，Golang 會是一個比較好的選擇。

## Ease of use 使用上

相信寫 JavaScript 再來寫 Node.js 會是非常簡單，學一套語言前後端都可以適用，Node.js 語言讓程式設計師可以快速進入開發，所以也不用考慮 concurrency 狀況，然而在 Golang 則是提供另外一種 elegant patterns，讓你在寫 concurrency 語法時，需要考慮實際情境。

## Ecosystem 生態

不得不說在語言生態上 Node.js 還是贏過 Golang 許多，一個套件可能在 Node.js 上找到好多個不同的作者寫的，但是在 Golang 上可能連一個都沒有。在文件上 Node.js 靠的是 Readme，而 golang 則是靠 [godoc][7]，在沒有大量的 example 的狀態下，其實從 Readme 來看都是不好上手的，另外如果第一次接觸 golang，其實 godoc 看起來不是很友善。

## Conclusion 結論

每種語言都各有優缺點，並非說 Node.js 就是不好的語言，該 Blog 有說到，如果您還沒有處理過數千或數百萬的 concurrent connections 的話，會推薦使用 Node.js，反之則就是推薦 Golang。最後 Golang 有兩個套件專門主理 WebSocket，一個是 [x/net/websocket][8] 另一個是 [gorilla/websocket][9]，前者是 Golang 內建的套件，但是並非有很多功能，後者是 third party package 提供了更多 WebSocket 功能，如果要用在 Production 上，請使用後者，最後寫 Golang 可以使用 [pprof tool][10] 來追蹤記憶體變化。本篇翻譯自[原文出處][6]。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://nodejs.org/en/
 [3]: https://golang.org/
 [4]: http://www.scaledrone.com
 [5]: https://en.wikipedia.org/wiki/WebSocket
 [6]: http://blog.scaledrone.com/posts/nodejs-to-go
 [7]: https://godoc.org/
 [8]: https://godoc.org/golang.org/x/net/websocket
 [9]: https://godoc.org/github.com/gorilla/websocket
 [10]: https://golang.org/pkg/net/http/pprof/