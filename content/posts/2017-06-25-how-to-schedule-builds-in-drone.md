---
title: Cronjob 搭配 Drone 服務
author: appleboy
type: post
date: 2017-06-25T05:32:08+00:00
url: /2017/06/how-to-schedule-builds-in-drone/
dsq_thread_id:
  - 5940263503
categories:
  - DevOps
  - Docker
  - Golang
tags:
  - Docker
  - drone
  - Jenkins

---
[<img src="https://i1.wp.com/c1.staticflickr.com/5/4236/34957940160_435d83114f_z.jpg?w=840&#038;ssl=1" alt="drone-logo_512" data-recalc-dims="1" />][1]

[Drone][2] 是一套基於 [Docker][3] Container 技術的 CI/CD 服務，它是用 [Go][4] 語言所開發，可以安裝在任何作業系統內，你可以把 Drone 當作是開源版的 [Travis][5] 服務。Drone 本身不支援排程任務，也就是說無法像 Jenkins CI 一樣可以設定每天幾點幾分執行單一 Job 任務。但是可以透過第三方工具像是 `cron` 來整合 Drone API 達成自動排程的效果，底下來看看該如何實作。

<!--more-->

## 安裝 Drone CLI

Drone 提供 CLI 工具，讓開發者可以快速跟 Drone 服務溝通，底下兩種方式來安裝 Drone CLI。從官網找相對應作業系統的[執行檔][6]

  * Linux x64
  * Windows x64
  * Darwin x64

另外一種方式則是透過 `go get` 方式來安裝，前提是您必須要安裝 [Go 語言環境][7]。

<pre><code class="language-bash">$ go get github.com/drone/drone-cli/drone</code></pre>

## Drone CLI 教學

下面指令是透過 CLI 呼叫 Drone 執行指定的專案 Job Number。如果沒有提供 Number 編號，則是執行該專案最後一個 Build Number。

<pre><code class="language-bash">$ drone build start --fork &lt;repository&gt; &lt;build&gt;</code></pre>

`--fork` 代表啟動**新的任務**，並非是重新啟動該編號任務。下面指令則是根據專案 Branch 名稱得到最後 Build Number。

<pre><code class="language-bash">$ drone build last --format="{{ .Number }}" \
  --branch=&lt;branch&gt; &lt;repository&gt;</code></pre>

拿到最後一個 Number 後，就可以開始寫 Cron job 任務

## 整合 cron job

從上面教學可以知道如何透過 Drone CLI 拿到專案最後執行的 Job 任務編號，以及如何重新執行專案任務，這時我們可以將指令合併成一行，變且寫進 `crontab -e` 檔案內

<pre><code class="language-bash">* 22 * * * drone build start --fork octocat/hello-world \
  $(drone build last --format="{{ .Number }}" \
  --branch=master octocat/hello-world)</code></pre>

將 `branch` 及 `octocat/hello-world` 換成您的專案名稱即可。

## 結論

用 crontab + drone cli 就可以完成 Jenkins 可以做到的事情。這樣真的可以完全捨棄 Jenkins 了。如果大家對 Drone 有興趣，想更深入了解，可以來報名『[用一天打造團隊自動化測試及部署][8]』，此課程會在一天內帶您進入自動化測試及部署，想從 Jenkins 或 GitLab CI 轉換到 Drone 的，歡迎報名參加。

  * 時間: 2017/07/29 09:30 ~ 17:30
  * 地點: CLBC 大安館 (台北市大安區區復興南路一段283號4樓)
  * 價格: 3990 元

# [報名連結][8]

 [1]: https://www.flickr.com/photos/appleboy/34957940160/in/dateposted-public/ "drone-logo_512"
 [2]: https://github.com/drone/drone
 [3]: https://www.docker.com/
 [4]: https://golang.org/
 [5]: https://travis-ci.org/
 [6]: http://docs.drone.io/cli-installation/
 [7]: https://golang.org/dl/
 [8]: http://learning.ithome.com.tw/course/9cT5RF2vOMMrCfx