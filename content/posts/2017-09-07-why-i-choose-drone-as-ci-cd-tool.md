---
title: 為什麼我用 Drone 取代 Jenkins 及 GitLab CI
author: appleboy
type: post
date: 2017-09-07T02:58:44+00:00
url: /2017/09/why-i-choose-drone-as-ci-cd-tool/
dsq_thread_id:
  - 6125240585
categories:
  - DevOps
  - Docker
  - Golang
tags:
  - devops
  - drone
  - GitLab
  - Jenkins

---
[![Logo-DevOpsDays](https://farm5.staticflickr.com/4382/36906030282_f489c96be3_z.jpg)](https://www.flickr.com/photos/appleboy/36906030282/in/dateposted-public/ "Logo-DevOpsDays")

終於有機會正式跟大家介紹為什麼我會捨棄 [Jenkins][2] 跟 [GitLab CI][3]，取而代之的是用 [Go](https://golang.org) 語言寫的 [Drone][1]。今年很高興錄取台灣第一屆 [DevOps Day](https://devopsdays.tw/) 講師，在今年主題是『用 Drone 打造輕量級容器持續交付平台』，主要推廣這套 [Drone][1] CI/CD 工具，會議內容圍繞在 [Jenkins][2], [GitLab CI][3] 跟 Drone 的比較。也提到為什麼我不用 Jenkins 及 GitLab CI 的幾個原因。底下整理議程大綱。

___

* 為什麼選擇 Drone
* Drone 基礎簡介
* Drone 架構擴展
* Drone 安裝方式
* Drone 管理介面
* Drone 測試部署
* Drone 自訂套件

<!--more-->

在講為什麼不用 Jenkins 或 GitLab CI 之前我們來看看大家都用什麼工具來串 CI/CD 流程

[![Screen Shot 2017-09-07 at 10.50.39 AM](https://farm5.staticflickr.com/4374/36241356344_8cc1fc2ee8_z.jpg)](https://www.flickr.com/photos/appleboy/36241356344/in/dateposted-public/ "Screen Shot 2017-09-07 at 10.50.39 AM")

## 為什麼不用 Jenkins

有六個原因大家可以想看看是否有踩到身為工程師的痛點

___

1. 專案設定複雜 (連 DevOps 老手都這麼覺得)
2. 流程版本控制 (同事改個設定檔，流程就爆掉)
3. 無法擴充套件 (你會 Java 嗎？團隊內有人會嗎？)
4. 後續維護? (同事離職或請假該怎麼辦)
5. 學習困難? (新人完全不會啊)
6. 團隊成長? (團隊內只有特定同事才會?)


## 為什麼不用 GitLab CI

GitLab CI 已經改善了很多 Jenkins 遇到的問題，但是還有兩點是我看到的缺陷:

___

1. 只支援 GitLab 版本控制 (如果你用 [GitHub][4] 該怎麼辦)
2. 無法擴充 Yaml 檔案寫法

大家可以想想第二點，假設你今天要部署 10 台伺服器，**該如何將檔案同時丟到 10 台**?當然在 GitLab CI 可以做到，但是可以比較看看 Drone 透過 [drone-scp](https://github.com/appleboy/drone-scp)，而 GitLab CI 則是要自己自幹 Shell Script。所以可想而知，如果可以擴充 Yaml 寫法，就可以輕易簡化 Yaml 設定，讓流程更清楚。

## 導入 CI/CD 的瓶頸

在之前做過一份統計，大家對於導入 CI/CD 的瓶頸在哪邊，底下是統計圖

[![Screen Shot 2017-09-07 at 10.50.56 AM](https://farm5.staticflickr.com/4426/36241356214_f81a9c21d0_z.jpg)](https://www.flickr.com/photos/appleboy/36241356214/in/dateposted-public/ "Screen Shot 2017-09-07 at 10.50.56 AM")

可以看到前三名分別是:

___

1. 工具設定複雜
2. 團隊無法成長
3. 新人學習困難

如果您的團隊有以上困擾，歡迎使用 Drone，底下是我錄製的 [Udemy](https://www.udemy.com/) 線上課程。

## Drone 線上課程

如果你對 Drone 有興趣，且想改善上面我提到的問題，歡迎訂購，課程訂價是 4000 元，不過在 DevOps Day 開賣，現在特價 1600 元。Coupoon 優惠碼: **KUBERNETES** [購買網址][5]

底下是我的投影片，歡迎大家參考:

<iframe src="//www.slideshare.net/slideshow/embed_code/key/aM3SFokdjfULaI" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/secret/aM3SFokdjfULaI" title="用 Drone 打造 輕量級容器持續交付平台" target="_blank">用 Drone 打造 輕量級容器持續交付平台</a> </strong> from <strong><a href="https://www.slideshare.net/appleboy" target="_blank">Bo-Yi Wu</a></strong> </div>

[1]:https://github.com/drone/drone
[2]:https://jenkins.io/
[3]:https://about.gitlab.com/features/gitlab-ci-cd/
[4]:https://github.com
[5]:https://www.udemy.com/devops-oneday/?couponCode=KUBERNETES
