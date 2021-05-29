---
title: Drone CI/CD 推出 Cloud 服務支援開源專案
author: appleboy
type: post
date: 2018-12-09T11:25:30+00:00
url: /2018/12/drone-cloud-service/
dsq_thread_id:
  - 7095453783
categories:
  - DevOps
  - Docker
  - Drone CI
tags:
  - drone
  - droneci

---
[<img src="https://i1.wp.com/farm2.staticflickr.com/1956/46191388892_1446150027_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2018-12-08 at 10.36.20 PM" data-recalc-dims="1" />][1] [Drone][2] 在上個月宣布推出 [Cloud 服務][3] 整合 [GitHub][4] 帳戶內的 Repo，只要登入後就可以跑 GitHub 上面的專案自動化整合及測試，原先在 GitHub 上面常見的就是 [Travis][5] 或 [CircleCI][6]，現在 Drone 也正式加入角逐行列，但是從文中內可以看到其實是由 [Packet][7] 這間公司獨家贊助硬體及網路給 Drone，兩台實體機器，一台可以跑 X86 另外一台可以跑 ARM，也就是如果有在玩 ARM 開發版，現在可以直接在 Drone Cloud 上面直接跑測試。底下是硬體規格: <!--more-->

[<img src="https://i1.wp.com/farm5.staticflickr.com/4881/46191481952_eafbd244a2_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2018-12-09 at 7.16.54 PM" data-recalc-dims="1" />][8] 最後大家一定會問 Drone 有支援 Matrix Builds 嗎？答案就是有的，也就是專案可以同時測試多版本的語言，或多版本的資料庫，甚至同時測試 X86 及 ARM 系統，這些功能在 Drone 都是有支援的。詳細設定方式可以參考『[Multi-Platform Pipelines][9]』。 

## 影片介紹

Drone Cloud 的簡介可以參考底下影片 Drone 新版 UI 介紹可以看底下影片:

{{< youtube Fh4yQhzXsWA >}}

 [1]: https://www.flickr.com/photos/appleboy/46191388892/in/dateposted-public/ "Screen Shot 2018-12-08 at 10.36.20 PM"
 [2]: https://github.com/drone/drone
 [3]: https://blog.drone.io/drone-cloud/
 [4]: https://github.com
 [5]: https://travis-ci.org/
 [6]: https://circleci.com/
 [7]: http://packet.net/
 [8]: https://www.flickr.com/photos/appleboy/46191481952/in/dateposted-public/ "Screen Shot 2018-12-09 at 7.16.54 PM"
 [9]: https://docs.drone.io/config/pipeline/multi-platform/
