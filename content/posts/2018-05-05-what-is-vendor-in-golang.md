---
title: Go 語言的 vendor 目錄
author: appleboy
type: post
date: 2018-05-05T07:25:02+00:00
url: /2018/05/what-is-vendor-in-golang/
dsq_thread_id:
  - 6652702510
categories:
  - Golang

---
![cover](https://i1.wp.com/farm1.staticflickr.com/908/40093179410_53df4bb9e8_z.jpg)

很多朋友剛入門 [Go 語言時][2]，第一個會遇到的問題是，該如何設定專案配置，讓專案可以正常執行，在個人電腦該如何開發多個專案，這邊就會遇到該如何設定 `$GOPATH`，我在這邊跟大家講個觀念，開發環境只會有一個 `$GOPATH`，不管團隊內有多少專案，都是存放在同一個 GOPATH，避免每次開專案都要重新設定 `$GOPATH`，而專案內用到的相依性套件，請各自維護，透過[官方提供的 wiki][3]，請選一套覺得好用的來使用吧，沒有最好的工具，找一套適合團隊是最重要的。

<!--more-->

## 什麼是 vendor

這邊不多說了，直接看影片教學最快了。

{{< youtube DKqw_CvVklo >}}

* * *

Go 語言線上課程目前特價 $1600，持續錄製中，每週都會有新的影片上架，歡迎大家參考看看，請點選[購買連結][4]

[2]: https://golang.org
[3]: https://github.com/golang/go/wiki/PackageManagementTools
[4]: http://bit.ly/intro-golang
