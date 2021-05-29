---
title: Drone 發佈 0.8.0-rc.1 版本
author: appleboy
type: post
date: 2017-07-21T06:44:42+00:00
url: /2017/07/drone-release-0-8-0-rc-1/
dsq_thread_id:
  - 6004063990
categories:
  - DevOps
tags:
  - drone

---
[<img src="https://i1.wp.com/c1.staticflickr.com/5/4236/34957940160_435d83114f_z.jpg?w=840&#038;ssl=1" alt="drone-logo_512" data-recalc-dims="1" />][1]

[Drone][2] 作者在昨天晚上發佈了 [0.8.0-rc.1][3]，此版本有兩個重大變更，第一是 Server 跟 Angent 之間溝通方式轉成 [GRPC][4]，另一個變更則是將原本單一執行擋 drone 拆成兩個，也就是之後會變成 `drone-server` 及 `drone-agent`，拆成兩個好處是，通常 Server 端只會有一台，但是隨著專案越來越多，團隊越來越龐大，Agent 肯定不只有一台機器，所以把 Agent 拆出來可以讓維運人員架設新機器時更方便。

<!--more-->

## 執行畫面

此版本的 UI 也有不同的改變，但是還是以簡單為主，也支援手機端瀏覽，首先看到在單一 Build 的狀態，現在可以顯示每一個步驟的**執行時間**

[<img src="https://i1.wp.com/farm5.staticflickr.com/4307/35669765300_c947039c7b_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-07-21 at 2.16.30 PM" data-recalc-dims="1" />][5]

點選任意一個步驟後，可以看到該步驟詳細紀錄，右邊則會顯示步驟列表

[<img src="https://i2.wp.com/farm5.staticflickr.com/4316/36059184715_195d07fc81_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-07-21 at 2.18.15 PM" data-recalc-dims="1" />][6]

### Secret 設定頁面

不需要透過 Command Line 也可以將 Secret (像是 Docker 帳號密碼等) 透過此頁面設定，不過這邊有個缺陷，不能指定 Image，在 Command line 可以設定 Secret 綁定在特定 Docker image 身上。

[<img src="https://i0.wp.com/farm5.staticflickr.com/4312/36059184835_64eec862d6_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-07-21 at 2.17.20 PM" data-recalc-dims="1" />][7]

### Registry 設定頁面

如果在公司內部有架設 Docker Registry 的話，可以透過此頁面將帳號密碼設定

[<img src="https://i2.wp.com/farm5.staticflickr.com/4327/36059184765_b29e1a3e63_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-07-21 at 2.17.30 PM" data-recalc-dims="1" />][8]

### Project 設定頁面

此頁面可以設定專案狀態，包含執行幾分鐘後就直接停止等。

[<img src="https://i2.wp.com/farm5.staticflickr.com/4327/35888339012_96b0caef00_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-07-21 at 2.17.37 PM" data-recalc-dims="1" />][9]

## 結論

此版的 UI 畫面實在是太讚了，尤其是執行步驟畫面，可以看到每個步驟執行時間，早上跟作者聊一下，說下週六我要拿 Drone 現在最新版來教大家，他回說那他會保證這週到下週的修改不會影響到我上課。底下是上課時間跟內容，歡迎大家報名參加『[用一天打造團隊自動化測試及部署][10]』。

* * *

  * 時間: 2017/07/29 09:30 ~ 17:30
  * 地點: CLBC 大安館 (台北市大安區區復興南路一段283號4樓)
  * 價格: 3990 元

 [1]: https://www.flickr.com/photos/appleboy/34957940160/in/dateposted-public/ "drone-logo_512"
 [2]: https://github.com/drone/drone
 [3]: http://docs.drone.io/release-0.8.0
 [4]: https://grpc.io/
 [5]: https://www.flickr.com/photos/appleboy/35669765300/in/dateposted-public/ "Screen Shot 2017-07-21 at 2.16.30 PM"
 [6]: https://www.flickr.com/photos/appleboy/36059184715/in/dateposted-public/ "Screen Shot 2017-07-21 at 2.18.15 PM"
 [7]: https://www.flickr.com/photos/appleboy/36059184835/in/dateposted-public/ "Screen Shot 2017-07-21 at 2.17.20 PM"
 [8]: https://www.flickr.com/photos/appleboy/36059184765/in/dateposted-public/ "Screen Shot 2017-07-21 at 2.17.30 PM"
 [9]: https://www.flickr.com/photos/appleboy/35888339012/in/dateposted-public/ "Screen Shot 2017-07-21 at 2.17.37 PM"
 [10]: http://learning.ithome.com.tw/course/9cT5RF2vOMMrCfx