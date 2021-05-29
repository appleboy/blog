---
title: 在本機端導入 Drone CLI 做專案測試
author: appleboy
type: post
date: 2017-12-24T03:16:33+00:00
url: /2017/12/drone-cli-local-testing/
dsq_thread_id:
  - 6368934527
categories:
  - DevOps
  - Drone CI
tags:
  - drone
  - Drone.io

---
[<img src="https://i1.wp.com/c1.staticflickr.com/5/4236/34957940160_435d83114f_z.jpg?w=840&#038;ssl=1" alt="drone-logo_512" data-recalc-dims="1" />][1]

[Drone][2] 是一套用 [Go 語言][3]所撰寫的 CI/CD 開源專案，透過 `.drone.yml` 檔案方式讓開發者可以自行撰寫測試及部署流程。大家一定會認為要先架設好 Drone 伺服器，才能透過 Git Push 方式來達到自動化測試及部署專案。現在跟大家介紹，如果你的團隊尚未架設 Drone 服務，但是又想要使用 Drone 透過 Yaml 方式所帶來的好處，很簡單，你只需要透過 Drone CLI 工具就可以完成，不需要架設任何一台 Drone 服務，只要學會 Yaml 方式如何撰寫，就可以透過 `drone exec` 指令來完成。好處是寫完 .drone.yml 檔案，未來圖隊如果正式架設了 Drone 服務，就可以無痛升級，沒有的話，也可以透過 CLI 工具在公司專案內單獨使用，這比寫 docker-compose.yml 方式還要快很多。本篇會介紹使用 `drone exec` 的小技巧。

<!--more-->

## 安裝 drone cli

請直到官方[下載頁面][4]下載相對應檔案，完成後請放到 `/usr/local/bin` 底下，目前支援 Windows, Linnx 及 MacOS。如果開發環境有 Go 語言，可以直接透過底下指令安裝

<pre><code class="language-bash">$ go get -u github.com/drone/drone-cli/drone</code></pre>

或是透過 tarbal 方式安裝

<pre><code class="language-bash">curl -L https://github.com/drone/drone-cli/releases/download/v0.8.0/drone_linux_amd64.tar.gz | tar zx
sudo install -t /usr/local/bin drone</code></pre>

## 撰寫 Yaml 檔案

用編輯器打開專案，並且初始化 `.drone.yml` 檔案

<pre><code class="language-yml">pipeline:
  backend:
    image: golang
    commands:
      - echo "backend testing"

  frontend:
    image: golang
    commands:
      - echo "frontend testing"</code></pre>

在命令列直接下 `drone exec` 畫面如下

<pre><code class="language-bash">[backend:L0:0s] + echo "backend testing"
[backend:L1:0s] backend testing
[frontend:L0:0s] + echo "frontend testing"
[frontend:L1:0s] frontend testing</code></pre>

可以發現今天就算沒有 drone server 團隊依然可以透過 drone exec 來完成測試。

## 使用 secret

在 drone 測試會需要使用 secret 來保存類似像 AWS API Key 隱秘資訊，但是這只能在 Drone server 上面跑才會自動帶入 secret。

<pre><code class="language-yml">pipeline:
  backend:
    image: golang
    secrets: [ test ]
    commands:
      - echo "backend testing"
      - echo $TEST

  frontend:
    image: golang
    commands:
      - echo "frontend testing"</code></pre>

執行 `drone exec` 後會發現結果如下

<pre><code class="language-bash">$ drone exec
[backend:L0:0s] + echo "backend testing"
[backend:L1:0s] backend testing
[backend:L2:0s] + echo $TEST
[backend:L3:0s]
[frontend:L0:0s] + echo "frontend testing"
[frontend:L1:0s] frontend testing</code></pre>

可以得知 `$TEST` 輸出是沒有任何資料，但是如果在 Drone server 上面跑是有資料的。那該如何在個人電腦也拿到此資料呢？其實很簡單，透過環境變數即可

<pre><code class="language-bash">$ TEST=appleboy drone exec
[backend:L0:0s] + echo "backend testing"
[backend:L1:0s] backend testing
[backend:L2:0s] + echo $TEST
[backend:L3:0s] appleboy
[frontend:L0:0s] + echo "frontend testing"
[frontend:L1:0s] frontend testing</code></pre>

這樣我們就可以正確拿到 secret 資料了。

## 忽略特定步驟

已經導入 drone 的團隊，一定會把很多部署的步驟都放在 `.drone.yml` 檔案內，但是在本機端只想跑前後端測試，後面的像是 Notification，或者是 SCP 及 SSH 步驟都需要忽略，這樣可以單純只跑測試，這時候該透過什麼方式才可以避免呢？很簡單只要在 `when` 條件子句加上 `local: false` 即可。假設原本 Yaml 寫法如下:

<pre><code class="language-yml">pipeline:
  backend:
    image: golang
    commands:
      - echo "backend testing"

  frontend:
    image: golang
    commands:
      - echo "frontend testing"

  deploy:
    image: golang
    commands:
      - echo "deploy"</code></pre>

這次我們想忽略掉 `deploy` 步驟，請改寫如下

<pre><code class="language-yml">pipeline:
  backend:
    image: golang
    commands:
      - echo "backend testing"

  frontend:
    image: golang
    commands:
      - echo "frontend testing"

  deploy:
    image: golang
    commands:
      - echo "deploy"
    when:
      local: false</code></pre>

再執行 `drone exec`，大家可以發現，最後一個步驟 `deploy` 就被忽略不執行了，這在本機端測試非常有用，也不會影響到 drone server 上的執行。大家可以參考此 [Yaml 檔案範例][5]，大量使用了 `local: false` 方式。

## 心得

我把本篇教學也錄製好放到 [Udemy][6] 免費讓大家觀看，在 **Drone Command Line 介紹**章節內，如果大家有興趣想學其他部分，也歡迎購買線上課程。本篇很適合想入門 Drone 但是又還沒導入 Drone 的團隊。可以透過 `drone exec` 方式來測試看看 drone 的優勢及好處，並且可以取代 [docker-compose][7] 無法做到的平行處理喔。

## [Udemy 課程][6]特價 $1600 只到 2017/12/31 日喔

## 影片

 [1]: https://www.flickr.com/photos/appleboy/34957940160/in/dateposted-public/ "drone-logo_512"
 [2]: https://github.com/drone/drone
 [3]: https://golang.org
 [4]: http://docs.drone.io/cli-installation/
 [5]: https://github.com/appleboy/gorush/blob/master/.drone.yml
 [6]: https://www.udemy.com/devops-oneday/?couponCode=KUBERNETES
 [7]: https://docs.docker.com/compose/