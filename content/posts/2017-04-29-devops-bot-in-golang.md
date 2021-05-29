---
title: 用 Go 語言打造 DevOps Bot
author: appleboy
type: post
date: 2017-04-29T03:33:49+00:00
url: /2017/04/devops-bot-in-golang/
dsq_thread_id:
  - 5769723584
categories:
  - DevOps
  - Golang
tags:
  - bot
  - Go
  - golang

---
[<img src="https://i0.wp.com/c1.staticflickr.com/5/4173/34200999131_48c1b84dd2_z.jpg?w=840&#038;ssl=1" alt="18190989_10210525473186864_1567687746_n" data-recalc-dims="1" />][1]

在 4/27 參加 [iThome][2] 舉辦的第一屆 [ChatBot Day][3]，我分享了如何用 [Go 語言][4] 實作 DevOps Bot，可以透過 [Facebook Messenger][5] 或 [Line Messenger API][6] 來主動通知開發者。此議程希望可以幫助想玩 Bot 但是又不知道如何入門的開發者。如果不懂程式語言，也可以直些下載 Binary 來玩玩看。

<!--more-->

## DevOps Bot 需要哪些功能

  * 支援 Command Line Flag 參數功能
  * 支援 Bot API WebHook 功能
  * 支援 Https for WebHook Tunnel
  * 支援自動更新 https 憑證功能 ([Let’s Encrypt][7])
  * 支援監控 WebHook 服務功能
  * 支援多種訊息格式 (圖片, 影片, 表情符號 … 等)
  * 支援跨平台編譯執行檔
  * 支援透過 [Docker][8] 發送訊息
  * 支援高並發 (處理大量發送訊息)

有興趣可以直接看投影片說明:

<script async class="speakerdeck-embed" data-id="fce9dfe844924cf6b88dcea5afcd502f" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>

大家可以直接下載 [drone-line](https://github.com/appleboy/drone-line/releases) 或 [drone-facebook](https://github.com/appleboy/drone-facebook/releases) 執行檔來玩玩。

 [1]: https://www.flickr.com/photos/appleboy/34200999131/in/dateposted-public/ "18190989_10210525473186864_1567687746_n"
 [2]: http://www.ithome.com.tw/
 [3]: http://chatbot.ithome.com.tw/
 [4]: https://golang.org
 [5]: https://developers.facebook.com/docs/messenger-platform
 [6]: https://developers.line.me/messaging-api/overview
 [7]: https://letsencrypt.org/
 [8]: https://www.docker.com/
