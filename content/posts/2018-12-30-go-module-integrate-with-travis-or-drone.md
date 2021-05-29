---
title: Go Module 導入到專案內且搭配 Travis CI 或 Drone 工具
author: appleboy
type: post
date: 2018-12-30T03:07:54+00:00
url: /2018/12/go-module-integrate-with-travis-or-drone/
dsq_thread_id:
  - 7135974786
categories:
  - DevOps
  - Drone CI
  - Golang
tags:
  - drone
  - go module
  - golang
  - Travis

---
[![][1]][2]

相信各位 [Go 語言][3]開發者陸陸續續都將專案從各種 [Vendor 工具][4]轉換到 [Go Module][5]，本篇會帶大家一步一步從舊專案轉換到 Go Module，或是該如何導入新專案，最後會結合 CI/CD 著名的兩套工具 [Travis][6] 或 [Drone][7] 搭配 Go Module 測試。

<!--more-->

## 影片介紹

  1. 舊專案內 vendor 轉換成 go module 設定 (1:15)
  2. 新專案如何啟用 go module (6:20)
  3. 在 Travis CI 或 Drone 如何使用 go module (8:31)
  4. 在開源專案內並存 vendor 及 go module (介紹 Gin 如何使用 vendor 及 go module) (15:00)

更多實戰影片可以參考我的 [Udemy 教學系列][8]

## 舊專案

假設原本的專案有導入 vendor 工具類似 [govendor][9] 或 [dep][10]，可以在目錄底下找到 `vendor/vendor.json` 或 `Gopkg.toml`，這時候請在專案目錄底下執行

<pre><code class="language-bash">$ go mod init github.com/appleboy/drone-line
$ go mod download</code></pre>

您會發現 go module 會從 `vendor/vendor.json` 或 `Gopkg.toml` 讀取相關套件資訊，接著寫進去 `go.mod` 檔案，完成後可以下 `go mod dowload` 下載所有套件到 `$HOME/go/pkg/mod`

## 新專案

新專案只需要兩個步驟就可以把相關套件設定好

<pre><code class="language-bash">$ go mod init github.com/appleboy/drone-line
$ go mod tidy</code></pre>

其中 tidy 可以確保 `go.mod` 或 `go.sum` 裡面的內容都跟專案內所以資料同步，假設在程式碼內移除了 package，這樣 tidy 會確保同步性移除相關 package。

## 整合 Travis 或 Drone

go module 在 1.11 版本預設是不啟動的，那在 Travis 要把 `GO111MODULE` 環境變數打開

<pre><code class="language-yaml">matrix:
  fast_finish: true
  include:
  - go: 1.11.x
    env: GO111MODULE=on</code></pre>

完成後可以到 [Travis 的環境][11]看到底下 `go get` 紀錄

[![][12]][13]

而在 [Drone 的設定][14]如下:

<pre><code class="language-yaml">steps:
  - name: testing
    image: golang:1.11
    pull: true
    environment:
      GO111MODULE: on
    commands:
      - make vet
      - make lint
      - make misspell-check
      - make fmt-check
      - make build_linux_amd64
      - make test</code></pre>

[![][15]][16]

## 結論

在開源專案內為了相容 Go 舊版本，所以 [Gin][17] 同時支援了 govendor 及 go module，其實還蠻難維護的，但是可以透過 travis 環境變數的判斷來達成目的:

<pre><code class="language-yaml">language: go
sudo: false
go:
  - 1.6.x
  - 1.7.x
  - 1.8.x
  - 1.9.x
  - 1.10.x
  - 1.11.x
  - master

matrix:
  fast_finish: true
  include:
  - go: 1.11.x
    env: GO111MODULE=on

git:
  depth: 10

before_install:
  - if [[ "${GO111MODULE}" = "on" ]]; then mkdir "${HOME}/go"; export GOPATH="${HOME}/go"; fi

install:
  - if [[ "${GO111MODULE}" = "on" ]]; then go mod download; else make install; fi
  - if [[ "${GO111MODULE}" = "on" ]]; then export PATH="${GOPATH}/bin:${GOROOT}/bin:${PATH}"; fi
  - if [[ "${GO111MODULE}" = "on" ]]; then make tools; fi</code></pre>

詳細設定請[參考 .travis 設定][18]

 [1]: https://lh3.googleusercontent.com/Q5CP9S-xtRHxnDRvxDpWWkvBsEVw5C5uRyb5EiBh-UpYkrp_dkZp_oN8yi1WtqwruhSgnwNMB5QjJPxO94ABjG9oLBqmcRjlouNTNmrChIWbQcsAAbuV9eWB1wbsK-x-OY6iolb5ahc=w2400
 [2]: https://photos.google.com/share/AF1QipPZ8MkcLAazbfRWwBrT1CQpipCL8N_1uAcYosJmJ-o6du2XRRHNEokVarxey5Bp8w?key=clctLU9JYVMzcEdHYWR2dUlVTVZ6YnZUUjlYRG9B&source=ctrlq.org
 [3]: http://golang.org
 [4]: https://github.com/golang/go/wiki/PackageManagementTools
 [5]: https://github.com/golang/go/wiki/Modules
 [6]: https://travis-ci.org/
 [7]: https://drone.io/
 [8]: https://www.udemy.com/golang-fight/?couponCode=GOLANG-TOP "Udemy 教學系列"
 [9]: https://github.com/kardianos/govendor "govendor"
 [10]: https://github.com/golang/dep "dep"
 [11]: https://travis-ci.org/gin-contrib/expvar/jobs/473545874http:// "Travis 的環境"
 [12]: https://lh3.googleusercontent.com/GRLzV6tA4qUB7kBMqf4jJ341-cRfgzVz-0PhhrtO-shEP2S7fijs3gTzdlWHkX8wLUOtYaguHbIUWjYihnXg8G2-w6LJG9V92g1pZlmatre1ZyY6uh5ChPU-CszxUWm1uDxo-Lc6oMI=w2400
 [13]: https://photos.google.com/share/AF1QipOdciWDnbJ3B9GsdYMXJqZbjtNE6rVMSvPSSFavowykZXxvZsATX_aA_Tib3q88aw?key=eWFTcDNIeGhjWlRJSzFaVjhKRFZ3a0YyMXlqcm5B&source=ctrlq.org
 [14]: https://github.com/appleboy/drone-facebook/blob/082f8901c8d56cf485ef7709466de56468f0b5cf/.drone.yml#L11-L21 "Drone 的設定"
 [15]: https://lh3.googleusercontent.com/90qm06Jcs6b8C1eJFlky1gWk_jXuPZpnYhElFTZMlmyP37olX0lOet0w4XCrgRVZyr8Cftb0nKqmBNYIkYNlGy1TK26-8OYQJXPbVJObY4RdGfmrsEXq3lHOZVfXp-puQGHTbwWSsYM=w2400
 [16]: https://photos.google.com/share/AF1QipOqJHtB3zHBNRz5ulb7yqtzeh7QVA0EZjlzGrzEN1CVbMntlM-bPaPl3TZCUpquAg?key=QW9WTF9xYzFlcmN0WE9ab0FqZXUtNHJrd2FjaHpB&source=ctrlq.org
 [17]: https://github.com/gin-gonic/gin "Gin"
 [18]: https://github.com/gin-gonic/gin/blob/master/.travis.yml