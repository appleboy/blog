---
title: 高雄 Mopcon 濁水溪以南最大研討會 – Drone CI/CD 介紹
author: appleboy
type: post
date: 2018-11-06T05:28:08+00:00
url: /2018/11/drone-ci-cd-platform-in-mopconf/
dsq_thread_id:
  - 7022779868
categories:
  - DevOps
  - Docker
  - Drone CI
tags:
  - AWS
  - drone
  - kubernetes

---
[<img src="https://i1.wp.com/farm2.staticflickr.com/1948/45693842842_d5fb6105b5_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2018-11-06 at 1.16.22 PM" data-recalc-dims="1" />][1] 今年又以講者身份參加 [Mopcon][2] 南區最大研討會，此次回高雄最主要推廣 [Drone][3] 這套 CI/CD 平台。大家可以從過去的 Blog 或影片可以知道我在北部推廣了很多次 Drone 開源軟體，唯獨南台灣還沒講過，所以透過 Mopcon 研討會終於有機會可以來推廣了。本次把 Drone 的架構圖畫出來，如何架設在 [Kubernetes][4] 上以及該如何擴展 drone agent，有興趣的可以參考底下投影片: <!--more-->

## 投影片

<div style="margin-bottom:5px">
  <strong> <a href="//www.slideshare.net/appleboy/drone-cicd-platform" title="Drone CI/CD Platform" target="_blank">Drone CI/CD Platform</a> </strong> from <strong><a href="https://www.slideshare.net/appleboy" target="_blank">Bo-Yi Wu</a></strong>
</div> 很高興 Drone 在今年宣佈支援 

[ARM][5] 及 Windows 兩大平台，而我也正在把一些 drone 的 plugin 支援 ARM 及 Windows，相信在 Drone 0.9 版正式推出後，就可以讓 Windows 使用者架設在 [Microsoft Azure][6]。

 [1]: https://www.flickr.com/photos/appleboy/45693842842/in/dateposted-public/ "Screen Shot 2018-11-06 at 1.16.22 PM"
 [2]: https://mopcon.org
 [3]: https://github.com/drone/drone
 [4]: https://kubernetes.io/
 [5]: https://www.arm.com/
 [6]: https://azure.microsoft.com/zh-tw/