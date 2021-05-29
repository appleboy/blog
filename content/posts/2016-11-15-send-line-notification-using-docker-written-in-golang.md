---
title: 用 Docker 發送 Line 訊息
author: appleboy
type: post
date: 2016-11-15T08:48:18+00:00
url: /2016/11/send-line-notification-using-docker-written-in-golang/
dsq_thread_id:
  - 5305393866
categories:
  - DevOps
  - Docker
  - Golang
tags:
  - bot
  - devops
  - Docker
  - drone
  - golang
  - Line Bot API

---
[<img src="https://i2.wp.com/farm2.staticflickr.com/1600/25660808075_c8190290f7_z.jpg?w=840&#038;ssl=1" alt="docker" data-recalc-dims="1" />][1]

今年各家網路公司 ([Facebook][2], [Line][3] 和 [Telegram][4]...) 分別推出 Bot 服務，看起來 Bot 會是未來趨勢，對 Bot 不是很了解的話，可以參考 Eric ShangKuan 寫了一篇: [關於寫對談機器人 (bot) 的兩三事][5]。本篇會介紹如何透過 [Docker][6] 整合 [Line Message API][7]，下面所有指令都會跟 Docker 有關，但是程式碼都是用 [Golang][8] 撰寫，想說順便在台灣推廣 ^__^。就在今年四月 Line 推出第一版 SDK，但是到了九月，突然收到 Line 的通知，說舊版的不支援了，請大家換到[新板 API][9]，最近更動到新版本時，踩到官網 UI 的雷就是原來 Line 有分 Developer 跟一般帳號，這兩種差別就是在於有無`主動 Push Message` 功能，後來在 [Line-Go-SDK][10] 發問才找到[解答][11]。底下會一步一步教大家如何透過 Docker 發送 Line 訊息。

<!--more-->

## 步驟一: 申請 Line Developer 帳號

如果已經有帳戶請略過此步驟。請先到 [LINE Business Center][7]，點選 `Developer Trial`，建立組織及建立帳號，如下圖

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/25358962539/in/dateposted-public/" title="Screen Shot 2016-11-15 at 1.45.18 PM"><img src="https://i1.wp.com/c4.staticflickr.com/6/5773/25358962539_da16f9041c_b.jpg?resize=745%2C851&#038;ssl=1" alt="Screen Shot 2016-11-15 at 1.45.18 PM" data-recalc-dims="1" /></a>

完成後，點選 Line Manager，啟動 API

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/30693057720/in/dateposted-public/" title="Screen Shot 2016-11-15 at 1.50.52 PM"><img src="https://i0.wp.com/c1.staticflickr.com/6/5602/30693057720_f8ea304022_b.jpg?resize=681%2C902&#038;ssl=1" alt="Screen Shot 2016-11-15 at 1.50.52 PM" data-recalc-dims="1" /></a>

請務必啟動底下設定

  * Use webhooks
  * Allow Bot to join group chats

如果有看到 Usable APIs 包含底下:

  * REPLY_MESSAGE
  * `PUSH_MESSAGE`

有 `PUSH_MESSAGE` 權限，Bot 才可以主動發訊息給使用者

## 步驟二: 取 Line Token 和 Secret

回到 [LINE Business Center][7] 頁面，`Tools` 底下選 `Line Developers`，就可以看到 `Channel Secret` 及 `Channel Access Token`，要取 Token 請點選右邊的 `Issue` 按鈕就可以顯示了

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/30693161460/in/dateposted-public/" title="Screen Shot 2016-11-15 at 1.59.12 PM"><img src="https://i1.wp.com/c5.staticflickr.com/6/5517/30693161460_dab6304d0f_b.jpg?resize=769%2C838&#038;ssl=1" alt="Screen Shot 2016-11-15 at 1.59.12 PM" data-recalc-dims="1" /></a>

表單內的 Webhooks URL 是要填寫 `https` 開頭的 URL，下個步驟會教大家如何透過 Docker 架設 Line Webhook 服務。

## 步驟三: 用 Docker 啟動 Line Webhook 服務

此步驟是教大家如何取得使用者 ID，前提是使用者必須加 Bot 為好友。要啟動 webhook 服務有兩種方式，一種是透過 docker，另一種則是透過 Golang 方式，我們先來試試看 Docker 方式。

### 下載程式碼

```bash
$ git clone https://github.com/appleboy/drone-line.git
$ cd drone-line
```

### 編譯 Docker Image

進入 example 目錄後，會發現有 server.go 跟 Dockerfile 兩檔案

```bash
$ docker build -t line example
```

上面的 `line` 可以自行換掉，換成自己想要的名字，接著啟動編譯好的 Image。

### 啟動 Webhook 服務

```bash
$ docker run --rm \
  -e CHANNEL_SECRET=xxxx \
  -e CHANNEL_TOKEN=xxxx \
  -p 8089:8089 \
  line
```

如果不是透過 Docker，請直接執行 Go 指令即可

```bash
$ go run server.go
```

### 用 ngrok 穿牆

這時候會發現系統聽 `8089` port，接著透過 [ngrok][12] 來做穿牆，並且提供 https 服務

```bash
$ ngrok http 8089
```

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/30961153696/in/dateposted-public/" title="Screen Shot 2016-11-15 at 4.08.47 PM"><img src="https://i2.wp.com/c1.staticflickr.com/6/5669/30961153696_893767bf41_z.jpg?resize=640%2C417&#038;ssl=1" alt="Screen Shot 2016-11-15 at 4.08.47 PM" data-recalc-dims="1" /></a>

拿到 `https://xxxx.ngrok.io` 後，請到 Line Develop Console 填到 Webhook URL 欄位 (請填入: `https://xxxx.ngrok.io/callback` )，最後透過 QRCODE 加 Bot 為好友，並且發送訊息測試，可以發現在 Console 端會顯示:

> 2016/11/15 08:04:22 User ID is U77234666b0313021f873b85xxxxxxx

這就是您專屬的 User ID，請記錄下來。

## 步驟四: 用 Docker 主動發送 Line 訊息

透過 **[drone-line][13]** 包好的 Docker Image ([appleboy/drone-line][14])來主動發送訊息，來到這邊，就是假設你已經取得 Line Secret, Token 及使用者 ID，透過下面 Docker 指令

```bash
docker run --rm \
  -e LINE_CHANNEL_SECRET=xxxxxxx \
  -e LINE_CHANNEL_TOKEN=xxxxxxx \
  -e PLUGIN_TO=xxxxxxx \
  -e PLUGIN_MESSAGE=test \
  appleboy/drone-line
```

其中 `LINE_CHANNEL_SECRET`, `LINE_CHANNEL_TOKEN` 和 `PLUGIN_TO` 請填入相對應設定。如果覺得指令太長，也可以把設定包在 `.env` 檔案內

```bash
LINE_CHANNEL_SECRET=xxxxxxx
LINE_CHANNEL_TOKEN=xxxxxxx
PLUGIN_TO=xxxxxxx
PLUGIN_MESSAGE=test
```

請務必將檔案放在執行指令的目錄底下，接著透過底下指令發送訊息

```bash
docker run --rm \
  -e ENV_FILE=your_env_file_path \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  appleboy/drone-line
```

## 總結

本來 [drone-line][13] 是 [drone ci server][15] 的 plugin，用來完成測試後，通知相關開發者，當然要整合其他 CI 像是 Jenkins 也是可以的，基本上都包成指令了，只要有 Bash 環境都可以運作。老實說 Line 的開發網站，介面不是很人性化，很多功能都不知道在哪邊，也蠻亂的，另外 Line Developer 也有提供綁定 Server IP 才可以發送訊息，這功能不是很即時性，所以大家盡量不要去用。目前也只有 Line 有提供這功能，應該是要避免 Token 跟 Secret 被偷走。最後要注意的是免費的 Developer 帳號一次只能發五則訊息。超過五則訊息，則會吐出底下錯誤:

> [messages] Size must be between 1 and 5

怎麼發送多個訊息呢？請用 `,` 來分隔 (**不要超過 5 個喔**)

    docker run --rm \
      -e LINE_CHANNEL_SECRET=xxxxxxx \
      -e LINE_CHANNEL_TOKEN=xxxxxxx \
      -e PLUGIN_TO=xxxxxxx \
      -e PLUGIN_MESSAGE=我,愛,你\
      appleboy/drone-line

 [1]: https://www.flickr.com/photos/appleboy/25660808075/in/dateposted-public/ "docker"
 [2]: https://www.facebook.com
 [3]: https://line.me/
 [4]: https://telegram.org/
 [5]: https://medium.com/@ericsk/%E9%97%9C%E6%96%BC%E5%AF%AB%E5%B0%8D%E8%AB%87%E6%A9%9F%E5%99%A8%E4%BA%BA-bot-%E7%9A%84%E5%85%A9%E4%B8%89%E4%BA%8B-f28f1a0ce7c4#.uuo64bw2e
 [6]: https://www.docker.com/
 [7]: https://business.line.me/en/services/bot
 [8]: https://golang.org/
 [9]: https://devdocs.line.me/en
 [10]: https://github.com/line/line-bot-sdk-go
 [11]: https://github.com/line/line-bot-sdk-go/issues/32#issuecomment-260235045
 [12]: https://ngrok.com/
 [13]: https://github.com/appleboy/drone-line
 [14]: https://hub.docker.com/r/appleboy/drone-line/
 [15]: https://github.com/drone/drone