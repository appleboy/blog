---
title: Go 語言目錄結構與實踐
author: appleboy
type: post
date: 2019-08-31T10:53:29+00:00
url: /2019/08/golang-project-layout-and-practice/
dsq_thread_id:
  - 7613330457
categories:
  - DevOps
  - Docker
  - Golang
tags:
  - golang

---
[![golang logo][1]][1]

很高興今年錄取 [Modernweb][2] 講師，又有機會去宣傳 [Go 語言][3]，這次的議程最主要跟大家介紹 Go 專案的目錄該如何設計，一個基本的專案該需要有哪些功能，以及如何實現。大家剛入門 Go 時，肯定會開始找是否有一套 Web Framework 可以參考實踐，可惜的是，在 Go 語言沒有定義任何的目錄結構，所有的結構都可以根據團隊的狀況而有所改變，而這邊我想強調的是如果能讓團隊看到結構後，一目瞭然知道什麼功能該放哪個目錄，或什麼目錄內大概有什麼功能，那其實就夠了。看了許多開源專案，每個設計方式都是不同，但是當你要找什麼功能時，其實從根目錄就可以很清楚的知道要進入哪個地方可以找到您想要的功能及程式碼。這次在 Moderweb 上面的議題，就是分享我在開源專案所使用的目錄結構，以及結構內都放哪些必要的功能。

<!--more-->

## Go 語言基礎實踐

除了講 Go 的目錄架構外，我還會提到很多小技巧及功能，讓大家可以知道更多相關要入門的 Go 基礎知識，底下是大致上的功能清單:

  1. 如何使用 Makefile 管理 GO 專案
  2. 如何用 [docker-compose][4] 架設相關服務
  3. [Go module][5] proxy 介紹及部署
  4. 專案版本號該如何控制
  5. 如何在 Go 語言嵌入靜態檔案
  6. 如何實現 [304 NOT Modified][6] 功能
  7. 簡易的 Healthy check API
  8. Command Line 撰寫
  9. 如何實現讀取 `.env` 及環境變數
 10. 整合 [Prometheus][7] 搭配 Token 驗證
 11. 如何測試 [Docker][8] 容器是否正確
 12. 實作 custome errors
 13. 用 yaml 來產生真實 DB 資料來測試 (支援 SQLite, MySQL 或 Postgres)
 14. 透過 [TestMain][9] 來實現 setup 或 teardown 功能
 15. 用 Go 語言 [Build Tags][10] 支援 SQLite
 16. 介紹如何撰寫 [Go 語言測試][11]

最後來推廣我的兩門課程，由於 modernweb 不會提供會後錄影，所以我打算把上面的部分在製作影片放到 Udemy 平台給學生學習。

  * Go 語言實戰課程: <http://bit.ly/golang-2019>
  * Drone CI/CD 自動化課程: <http://bit.ly/drone-2019>

## 投影片

{{< speakerdeck id="b8d34a236aa6419f8790dab2a845d1d7" >}}

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://modernweb.tw/
 [3]: https://golang.org
 [4]: https://docs.docker.com/compose/ "docker-compose"
 [5]: https://blog.wu-boy.com/2018/10/go-1-11-support-go-module/
 [6]: https://developer.mozilla.org/zh-TW/docs/Web/HTTP/Status/304 "304 NOT Modified"
 [7]: https://prometheus.io/
 [8]: https://www.docker.com/ "Dokcer"
 [9]: https://golang.org/pkg/testing/#hdr-Main "TestMain"
 [10]: https://golang.org/pkg/go/build/ "Build Tags"
 [11]: https://golang.org/pkg/testing/ "Go 語言測試"
