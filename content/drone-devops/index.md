---
title: DevOps 課程
author: appleboy
type: page
date: 2017-11-16T02:07:36+00:00
dsq_thread_id:
  - 6549720181

---

[<img src="https://i1.wp.com/c1.staticflickr.com/5/4236/34957940160_435d83114f_z.jpg?w=840&#038;ssl=1" alt="drone-logo_512" data-recalc-dims="1" />][1]

## 課程緣由

當初想開這課程的原因是，希望可以造福全台灣的朋友，之前跟 [iThome 合作開了一堂實體課程][2]，但是很多人卡在假日無法出門，再來是實體課程成本比較高，有時候上課沒聽懂，回家也沒有老師可以討論，造成學習效果不是很好，所以我就來錄製線上課程，讓不能北上的朋友們也可以學習到基本的 DevOps 技巧。希望能透過線上課程可以跟學員有些互動，把 DevOps 推廣到各大公司及新創。如果正要創業，或是在 DevOps 上有些困擾，不知道該如何導入及選擇工具，都可以來跟我聊聊。團隊內原本使用 [Bamboo][3] 之後跳到 [Jenkins][4] 最後又跳到 [Drone][5]，本課程會介紹為什麼我們放棄 Bamboo 及 Jenkins，它們所帶來的缺陷，以及為什麼最後選擇 Drone。

## 課程簡介

[Drone][6] 是一套以 Docker 容器為基礎的 CI/CD 伺服器。每次執行編譯時，都是運作在 Docker 容器內，可以確保開發者都在獨立環境執行，避免每次編譯狀況都不同。傳統企業在導入 DevOps 流程都會以 Jenkins 或者是 Gitlab CI 為主流，前者是 Java 語言開發，後者是 Ruby 語言開發，維運人員會發現這兩套其實都蠻吃重系統資源，然而 Drone 是一套由 [Go 語言][7]開發的伺服器，啟動 Drone 時，只需要不到 20 MB 的記憶體就可以跑此服務，大幅降低維運成本，也讓維運人員更好維護伺服器。Drone 的出現就是為了讓團隊可以像 [Github 一樣持續開發持續部署][8]，另外開發者可以輕易的用自己喜歡的語言(像是 Node.js, Python 甚至 Bash Script)撰寫 Plugin 整合進 Drone，取代傳統的 Jenkins 思維。 本課程您會學到:

  1. 如何製作 Docker 映像檔並且自動上傳到 Docker Hub
  2. 如何將 Drone 導入團隊取代傳統 Jenkins 服務
  3. 如何用其他語言撰寫 Plugin 整合進 Drone 服務
  4. 如何用 Drone 整合團隊部署測試流程 (如下圖)

[<img src="https://c1.staticflickr.com/5/4185/34309691871_65d36545a5_c.jpg" alt="Screen Shot 2017-05-04 at 11.50.29 AM" data-recalc-dims="1" />][9]

## 課程大綱

  1. 什麼是 DevOps
  2. DevOps 帶來的好處及影響
  3. Docker 語法介紹 (製作 Image 及 Docker Hub 整合)
  4. Docker 語法介紹 (製作 Image 及 Docker Hub 整合)
  5. Drone 安裝 (整合 Gitlab, Github, Bitbucket)
  6. Drone 整合 Nginx, Caddy, Ngrok (設定 Let&#8217;s Encrypt)
  7. Drone 整合測試 Python, Node.js, 或 Golang 搭配 redis, mysql 等服務
  8. Drone 整合訊息通知 (Line, Facebook, Slack &#8230;)
  9. Drone 指令介紹 (設定 Secret，管理權限)
 10. Drone 套件實作 (Node.js, Python, Shell Script, Golang)
 11. Drone 部署到 AWS, Linode, DigitalOcean 等 &#8230;

## 講師資訊

Appleboy (吳柏毅) 目前服務於聯發科技，擔任 IoT 物聯網工程師。長期貢獻於 Open Source 專案，熱愛開發程式。

  * Mopcon 研討會講師 ([2020][17])
  * iTHome Cloud Summit 研討會講師 ([2020][17])
  * Mopcon 研討會講師 ([2019][16])
  * iThome Modern Web 研討會講師 ([2019][15])
  * iTHome Cloud Summit 研討會講師 ([2019][14])
  * Mopcon 研討會講師 ([2018][13])
  * iThome Modern Web 研討會講師 ([2018][12])
  * Mopcon 研討會講師 ([2017][11])
  * iThome Modern Web 研討會講師 (2017)
  * iThome Gopher Day 研討會講師 (2017)
  * iTHome Cloud Summit 研討會講師 (2017)
  * iTHome ChatBot 研討會講師 (2017)
  * iTHome DevOps 研討會講師 (2016, 2017)
  * PHPConf 研討會講師 (2012, 2013)
  * COSCUP 研討會講師 (2016, 2014)
  * JSDC 研討會講師 (2013)
  * OSDC 研討會講師 (2014)
  * 公司內部教育訓練講師 (Git, Docker 及相關程式語言)

[11]: https://mopcon.org/2017/
[12]: https://modernweb.tw/2018/
[13]: https://mopcon.org/2018/
[14]: https://cloudsummit.ithome.com.tw/2019/
[15]: https://modernweb.tw/2019/
[16]: https://mopcon.org/2019/
[17]: https://cloudsummit.ithome.com.tw/2020/
[18]: https://mopcon.org/2020/

目前為數個 Go 專案開發及維護者

  * [Gin][21]: 主流的 Web 框架，適合用來寫 API 服務，目前是擔任維護及開發角色。
  * [Gitea][22]: 輕量級 Git 伺服器，目前擔任維護及開發角色。
  * [Drone][23]: 用 Docker Container 來持續整和部署，可與上面 Gitea 串接，目前為貢獻者及數個 Plugin 作者。

[21]: https://github.com/gin-gonic/gin
[22]: https://gitea.io/zh-tw/
[23]: https://github.com/drone/drone

講師個人相關連結

  * Blog: <https://blog.wu-boy.com/>
  * Github: <https://github.com/appleboy>
  * Slide: <http://www.slideshare.net/appleboy>

## 適合對象

  * 系統管理者
  * 前端開發者
  * 後端開發者
  * 全端開發者

## 開發環境

  * 開發環境：[Docker][12] + 您的偏好語言 (Node.js, Python, Golang)
  * 開發工具：Visual Studio Code 或您偏好的編輯器 (Sublime, Vim ..)
  * 開發語言：您偏好的開發語言 (Node.js, Python, Golang ..)
  * 開發系統：Linux, MacOS

## 事前準備

請大家先安裝好 Docker 及相關開發工具及語言。

  * MacOS: [教學連結][13]
  * Linux: [教學連結][14]

## 為什麼不使用 Jenkins 或 GitLab CI

可以直接參考之前寫的一篇：『[為什麼我用 Drone 取代 Jenkins 及 GitLab CI][15]』

## 購買資訊

請直接點選這裡[線上購買][31]，優惠碼為: `{{< coupon >}}`，如果需要更優惠價錢，或者是搭配其他課程一起購買，請直接[聯絡我][32]，也可以透過線上匯款方式，匯款後一樣 FB 私訊丟我，我會開一個免費課程連結給您

* 富邦銀行: 012
* 富邦帳號: 746168268370
* 匯款金額: 台幣 `$2000` 元 (匯款優惠 200 元，網路優惠價為 `$2200` 元)

[31]: https://www.udemy.com/devops-oneday/
[32]: https://facebook.com/appleboy46

 [1]: https://www.flickr.com/photos/appleboy/34957940160/in/dateposted-public/ "drone-logo_512"
 [2]: http://learning.ithome.com.tw/course/9cT5RF2vOMMrCfx
 [3]: https://www.atlassian.com/software/bamboo
 [4]: https://jenkins.io/
 [5]: https://drone.io/
 [6]: https://github.com/drone/drone
 [7]: https://golang.org
 [8]: https://github.com/blog/1241-deploying-at-github#always-be-shipping
 [9]: https://www.flickr.com/photos/appleboy/34309691871/in/dateposted-public/ "Screen Shot 2017-05-04 at 11.50.29 AM"
 [10]: https://github.com/gin-gonic/gin
 [11]: https://gitea.io/zh-tw/
 [12]: https://docs.docker.com/engine/installation/
 [13]: https://docs.docker.com/docker-for-mac/install/
 [14]: https://docs.docker.com/engine/installation/linux/ubuntu/
 [15]: https://blog.wu-boy.com/2017/09/why-i-choose-drone-as-ci-cd-tool/
 [16]: https://www.udemy.com/devops-oneday/
