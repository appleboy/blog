---
title: 用 drone-line 架設 Line webhook 及發送訊息
author: appleboy
type: post
date: 2016-12-18T07:57:16+00:00
url: /2016/12/send-line-message-using-drone-line/
dsq_thread_id:
  - 5389290816
categories:
  - Golang
  - Linux
  - Mac
  - Ubuntu
  - windows
tags:
  - bot
  - drone
  - golang
  - Line
  - Line Bot API

---
[<img src="https://i2.wp.com/c5.staticflickr.com/1/318/31555289732_f79a194057_c.jpg?w=840&#038;ssl=1" alt="" data-recalc-dims="1" />][1]

之前寫了一篇教學『[用 Docker 發送 Line 訊息][2]』，但是前提是你要先學會 [Docker][3]，對於完全沒有 Docker 經驗的初學者來說，學習起來相當不容易，所以我將 drone-line 編譯出 Linux, Mac OS X 或 Windows 都可以執行的 Binary 檔案，方便初學者可以直接下載執行檔，在任何環境都可以運作，請直接參考 [v1.4.0 Release][4] 頁面，如果還是想用 Docker 版本的，可以直接參考 [Docker Hub][5] 上的 [drone-line repo][6]，底下會教大家如何執行 Line webhook service 及發送訊息，尚未申請 Line Developer 帳號，請直接參考[前一篇教學][2]

<!--more-->

## 使用執行檔

不用學習 Docker 只需要下載執行檔就可以，支援底下環境

  * Windows adm64/386
  * Linux amd64/386
  * Darwin (Mac OS X) amd64/386

### 下載 drone-line 執行檔

不管是 Windows 64/32 位元的作業系統，都可以直接在 drone-line [release 頁面][7] 找到相對應的下載點。下載後，直接在 Windows 執行 cmd 指令，跳出命令提示列視窗，鍵入:

<pre><code class="language-bash">$ drone-line-v1.4.0-windows-amd64.exe -h</code></pre>

看到底下畫面就代表成功了

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/31555161842/in/dateposted-public/" title="Screen Shot 2016-12-17 at 11.58.28 PM"><img src="https://i2.wp.com/c3.staticflickr.com/1/656/31555161842_97d67daf9c_c.jpg?resize=775%2C800&#038;ssl=1" alt="Screen Shot 2016-12-17 at 11.58.28 PM" data-recalc-dims="1" /></a>

### 架設 Webhook Service

透過 Webhook Service 才可以跟 Line Server 互相溝通，拿到使用者專屬 ID，請直接底下指令就可以架設 Webhook service。

<pre><code class="language-bash">$ drone-line-v1.4.0-windows-amd64.exe \
  --secret xxxx \
  --token xxxx \
  webhook</code></pre>

其中 `--secret` 及 `--token` 請自行替換，預設會跑在 `8088` port，如果要換連接埠，請使用 `--port` 參數

<pre><code class="language-bash">$ drone-line-v1.4.0-windows-amd64.exe \
  --port 2001 \
  --secret xxxx \
  --token xxxx \
  webhook</code></pre>

### 傳送訊息

拿到使用者 ID 就可以透過指令直接發送訊息

<pre><code class="language-bash">$ drone-line-v1.4.0-windows-amd64.exe \
  --secret xxxx \
  --token xxxx \
  --to xxxx \
  --message "Test Message"</code></pre>

其中 `--to` 是代表使用者 ID，如果要傳給多個人，請用 `,` 符號隔開。

## 使用 Docker

還是可以用 Docker 完成跟執行檔相同的結果，本篇是透過 [appleboy/drone-line][6] 映像檔來完成

### 架設 Webhook Service

一行指令完成 webhook service 架設

<pre><code class="language-bash">docker run --rm \
  -e PLUGIN_CHANNEL_SECRET=xxxxxxx \
  -e PLUGIN_CHANNEL_TOKEN=xxxxxxx \
  appleboy/drone-line webhook</code></pre>

如果要換預設連接埠 (8088) 請加上 `PLUGIN_PORT` 全域變數

<pre><code class="language-bash">docker run --rm \
  -e PLUGIN_CHANNEL_SECRET=xxxxxxx \
  -e PLUGIN_CHANNEL_TOKEN=xxxxxxx \
  -e PLUGIN_PORT=2001 \
  appleboy/drone-line webhook</code></pre>

### 傳送訊息

一樣很簡單，一行指令搞定

<pre><code class="language-bash">docker run --rm \
  -e PLUGIN_CHANNEL_SECRET=xxxxxxx \
  -e PLUGIN_CHANNEL_TOKEN=xxxxxxx \
  -e PLUGIN_TO=xxxxxxx \
  -e PLUGIN_MESSAGE=test \
  appleboy/drone-line</code></pre>

## 後記

上個月在[線上 docker 讀書會][8]，有教大家如何用 Docker 發送 Line 訊息，影片檔如下，不過本篇主要是提供了各 OS 版本的 Binary 檔案，方便大家直接下載使用，連 Docker 都不用安裝了。

對於執行檔或 Docker 有其他問題，可以直接到 [drone-line][9] 開 [Issue][10] 給我吧。如果喜歡的話，也可以直接 Star 追蹤。

 [1]: https://i2.wp.com/c5.staticflickr.com/1/318/31555289732_f79a194057_c.jpg?ssl=1
 [2]: https://blog.wu-boy.com/2016/11/send-line-notification-using-docker-written-in-golang/
 [3]: https://www.docker.com/
 [4]: https://github.com/appleboy/drone-line/releases/tag/v1.4.0
 [5]: https://hub.docker.com
 [6]: https://hub.docker.com/r/appleboy/drone-line/
 [7]: https://github.com/appleboy/drone-line/releases
 [8]: https://www.facebook.com/groups/750311598438135/
 [9]: https://github.com/appleboy/drone-line
 [10]: https://github.com/appleboy/drone-line/issues