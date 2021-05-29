---
title: '2017 COSCUP 研討會: Gitea + Drone 介紹'
author: appleboy
type: post
date: 2017-08-07T06:23:26+00:00
url: /2017/08/2017-coscup-introduction-to-gitea-drone/
dsq_thread_id:
  - 6047112904
categories:
  - DevOps
  - Docker
  - Git
  - Golang
tags:
  - devops
  - drone
  - gitea
  - Jenkins

---
[<img src="https://i2.wp.com/farm5.staticflickr.com/4377/36020937670_fbcf1ee3d3_z.jpg?w=840&#038;ssl=1" alt="gitea-lg" data-recalc-dims="1" />][1]

今年很高興可以到 [COSCUP][2] 分享『**Gitea + Drone 介紹**』，我是在第二天的最後一場來做分享，最後還被大會進來趕人，講超過時間了。這次是我第一次到[台大社科院][3]，太陽真的好大，兩天下來流的汗水，大概已經是一年份的了。由於今年 COSCUP 不供應午餐，在第一天中午到科技站出口，左轉第一個店面就坐下來吃麵，店面不大，賣傳統小吃，我點了麻醬麵大碗 55 元，燙青菜 35 元，真的很大碗，不知道是不是因為在學校附近的關係，所以特別大碗，我心裡想說，這裡不是台北嗎？

<!--more-->

[<img src="https://i2.wp.com/farm5.staticflickr.com/4433/36242511851_daf577c7f4_z.jpg?w=840&#038;ssl=1" alt="P_20170805_123130_HDR.jpg" data-recalc-dims="1" />][4]

[<img src="https://i0.wp.com/farm5.staticflickr.com/4331/35982459200_b4d277e714_z.jpg?w=840&#038;ssl=1" alt="P_20170805_123141_HDR.jpg" data-recalc-dims="1" />][5]

## 講課內容

第二天講課，現場有 Demo 如何在十分鐘內快速安裝 \[Gitea\]\[11\] + \[Drone\]\[12\]，會議上大致介紹 Gitea 專案由來，以及提到最終我們希望是由 Gitea 來 host Gitea 這開源專案，當然目前還缺少幾項重大功能，可以參考[此列表][6]。底下是這次分享的投影片

<div style="margin-bottom:5px">
  <strong> <a href="//www.slideshare.net/appleboy/introduction-to-gitea-with-drone" title="Introduction to Gitea with Drone" target="_blank">Introduction to Gitea with Drone</a> </strong> from <strong><a target="_blank" href="https://www.slideshare.net/appleboy">Bo-Yi Wu</a></strong>
</div> ## 問與答 現在有兩位朋友提問，我就在這邊寫下 Q&A ### 問: Gitea 可以用在正式環境嗎？ 我這邊的想法是，如果團隊不至於很大，相信以 Gitea 都可以撐得住，我個人拿來放 Android 的 source code 或者是嵌入式系統專案的程式碼，含 Kernel 是幾 G 的大小，目前都還撐得住，對於一般的 Web 服務，我想代碼容量應該是更小才是。目前我知道有幾間新創團隊有開始使用 Gitea，用起來還算不錯，至少幫忙完成架設後，再也沒找過我了。相信穩定性及效能上基本上來說還算夠。 ### 問: Gitea 整合 Jenkins 有無問題？ 在課堂上有講到在今年初我拿 \[gogs plugin][22] 來搭配 Gitea，你可以看此 plugin 的教學是需要手動在每個專案的 Webhook 頁面設定上 [Jenkins\](https://jenkins.io/) Hook，透過 Hook 去觸發 Jenkins 的任務，我個人覺得不是很友善，畢竟每次開新專案都需要手動設定一次。我發現今年七月，Jenkins 團隊有寫了 \[Gitea Plugin\](https://github.com/jenkinsci/gitea-plugin)，所以只需要到 Jenkins 後台將外掛啟動就好，不過本人今天測試 Gitea + Jenkins，發現還是無法自動註冊 WebHook URL，所以不確定是哪邊有問題，如果大家有時間的話，可以幫忙測試看看。 \[11]:https://gitea.io/en-US/ [12]:http://docs.drone.io/ [22]:https://github.com/jenkinsci/gogs-webhook-plugin [23]:https://gogs.io/ ## 影片 今年 COSCUP 大會有現場播+錄影，沒來的朋友們，可以直接看底下影片，我是在最後半小時。 ## 後記 這次演講有帶到一些些 Drone，講的沒有很深入，也僅此於 Demo，如果對於 Drone 想深入了解，可以參加今年 9/04 - 9/06 台灣第一屆 [DevOpsDays Taipei 2017\](https://devopsdays.tw/)，當天會分享更深入的 Drone 流程，另外透過此\[投票\](https://ithomeonline.typeform.com/to/o6oQOD)，可以選擇你要聽的場次，我猜是越高票，就會到越大的會議廳。

 [1]: https://www.flickr.com/photos/appleboy/36020937670/in/dateposted-public/ "gitea-lg"
 [2]: http://coscup.org/2017
 [3]: http://www.coss.ntu.edu.tw/
 [4]: https://www.flickr.com/photos/appleboy/36242511851/in/datetaken/ "P_20170805_123130_HDR.jpg"
 [5]: https://www.flickr.com/photos/appleboy/35982459200/in/datetaken/lightbox/ "P_20170805_123141_HDR.jpg"
 [6]: https://github.com/go-gitea/gitea/issues/1029