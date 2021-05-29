---
title: 用 Go 語言實作 Job Queue 機制
author: appleboy
type: post
date: 2019-10-19T13:54:34+00:00
url: /2019/10/job-queue-in-golang/
dsq_thread_id:
  - 7683116341
categories:
  - Golang
tags:
  - Docker
  - golang

---
[![golang logo][1]][1]

很高興可以在 [Mopcon][2] 分享『用 [Go 語言][3]實現 Job Queue 機制』，透過簡單的 [goroutine][4] 跟 [channel][5] 就可以實現簡單 Queue 機制，並且限制同時可以執行多少個 Job，才不會讓系統超載。最後透過編譯放進 Docker 容器內，就可以跑在各種環境上，加速客戶安裝及部署。

<!--more-->

## 議程大綱

本次大致上整理底下幾個重點:

  1. What is the different unbuffered and buffered channel?
  2. How to implement a job queue in golang?
  3. How to stop the worker in a container?
  4. Shutdown with Sigterm Handling.
  5. Canceling Workers without Context.
  6. Graceful shutdown with worker.
  7. How to auto-scaling build agent?
  8. How to cancel the current Job?

由於在投影片內也許寫得不夠詳細，所以我打算錄製一份影片放在 Udemy 教學影片上，如果有興趣可以參考底下影片連結:

  * [Go 語言基礎實戰 (開發, 測試及部署)][6]
  * [一天學會 DevOps 自動化測試及部署][7]

之前的教學影片也可以直接參考底下連結:

  * [15 分鐘學習 Go 語言如何處理多個 Channel 通道][8]
  * [用五分鐘了解什麼是 unbuffered vs buffered channel][9]

## 投影片

<div style="margin-bottom:5px">
  <strong> <a href="//www.slideshare.net/appleboy/job-queue-in-golang-184064840" title="Job Queue in Golang" target="_blank">Job Queue in Golang</a> </strong> from <strong><a href="https://www.slideshare.net/appleboy" target="_blank">Bo-Yi Wu</a></strong>
</div>

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://mopcon.org/2019/
 [3]: https://golang.org
 [4]: https://tour.golang.org/concurrency/1
 [5]: https://tour.golang.org/concurrency/2
 [6]: https://www.udemy.com/course/golang-fight/?couponCode=GOLANG201911
 [7]: https://www.udemy.com/course/devops-oneday/?couponCode=DEVOPS201911
 [8]: https://blog.wu-boy.com/2019/05/handle-multiple-channel-in-15-minutes/
 [9]: https://blog.wu-boy.com/2019/04/understand-unbuffered-vs-buffered-channel-in-five-minutes/