---
title: Drone CI/CD 支援 Auto cancellation 機制
author: appleboy
type: post
date: 2019-10-20T02:27:53+00:00
url: /2019/10/auto-cancellation-in-drone-ci-cd/
dsq_thread_id:
  - 7683823694
categories:
  - DevOps
  - Docker
  - Drone CI
tags:
  - drone
  - Travis

---
[![][1]][1]

大家一定會問什麼是『Auto cancellation』呢？中文翻作自動取消，這機制會用在 CI/CD 的哪個流程或步驟呢？我們先來探討一個情境，不知道大家有無遇過在同一個 branch 陸續發了 3 個 commit，會發現在 CI/CD 會依序啟動 3 個 Job 來跑這 3 個 commit，假設您有設定同時間只能跑一個 Job，這樣最早的 commit 會先開始啟動，後面兩個 commit 則會處於 `Penging` 的狀態，等到第一個 Job 完成後，後面兩個才會繼續執行。

<!--more-->

這邊就會有個問題出現，假設後續團隊又 commit 了 10 個 job，這樣 Pending 狀態則會越來越多，不會越來越少，這時候開發者一定會想，有沒有辦法只保留最新的 Job，而舊有的 Pending Job 系統幫忙取消呢？這個功能在 [Travis CI][2] 已經有後台可以啟動，新專案也是預設啟動的，也就是假設現在有一個 job 正在執行，有九個 job 正在 pending 時，新的 job 一進來後，CI/CD 服務就會自動幫忙取消舊有的九個 Job，只保留最新的，確保系統不會浪費時間在跑舊的 Job。Drone 在 1.6 也支持了此功能，底下來看看如何設定 [Drone][3] 達到此需求。

## 影片教學

更多實戰影片可以參考我的 Udemy 教學系列

  * Go 語言實戰課程: <http://bit.ly/golang-2019>
  * Drone CI/CD 自動化課程: <http://bit.ly/drone-2019>

## 設定 Drone

Drone 在 1.6 版才正式支援『Auto cancellation』，而且每個專案預設是不啟動的，需要透過 [Drone CLI][4] 才能正確啟動。底下來看看如何透過 CLI 啟動：

```bash
# 啟用 pull request
drone repo update \
  --auto-cancel-pull-requests=true 
  appleboy/go-hello
# 啟用 push event
drone repo update \
  --auto-cancel-pushes=true \
  appleboy/go-hello
```

目前還沒有辦法透過後台 UI 介面啟用，請大家使用上述指令來開啟 Auto Cancellation 功能。

 [1]: https://lh3.googleusercontent.com/RK0neP9RNsD1P5N5zGL0BqgvUFnDDb1YuzyIUKLlD01ejmM87JNaU29bweqw_CyD0v39FYfi5wAh6wCls1CIxaMMiOdHX6WQ4p7hFU5Qlt052uya0NZ6pjJJAA24rfhbpDFDwKmivfU=w1920-h1080
 [2]: https://travis-ci.org/
 [3]: https://drone.io/ "Drone"
 [4]: https://docs.drone.io/cli/install/ "Drone CLI"