---
title: 在 DigitalOcean 新竹社群簡介 Gitea 開源專案
author: appleboy
type: post
date: 2017-04-23T13:34:04+00:00
url: /2017/04/introduction-to-gitea-in-digitalocean-hsinchu/
dsq_thread_id:
  - 5752312890
categories:
  - DevOps
  - Golang
tags:
  - gitea
  - golang

---
[<img src="https://i2.wp.com/c1.staticflickr.com/1/306/32012549582_3de35c29c8_o.png?w=840&#038;ssl=1" alt="gitea" data-recalc-dims="1" />][1]

很高興受到 [DigitalOcean 新竹社群][2]邀請來介紹輕量級的 Git 服務: [Gitea][3]，在不久之前筆者已經寫過一篇 [Gitea 介紹][4]，這次到[交通大學][5]宣傳這套免費的開源專案，目的就是希望台灣有更多開發者或企業可以了解用 [Go 語言][6]也可以打造一套輕量級 Git 服務，並且導入台灣的新創團隊。這次分享是透過 [DigitalOcean][7] 最小機器 (512MB 記憶體，每個月五美金) 來 Demo 如何在 Ubuntu 16.04 快速架設 Gitea 及使用 [Caddy][8] 來自動申請 [Let's Encrypt][9] 憑證，最後搭配 [Jenkins][10] 串自動化部署及測試等...。

[<img src="https://i1.wp.com/c1.staticflickr.com/3/2945/33407490713_d58acb6239_z.jpg?w=840&#038;ssl=1" alt="2017-04-23-18-18-45" data-recalc-dims="1" />][11]

<!--more-->

## 投影片

底下是這次 Gitea 介紹投影片，使用底下服務或開源專案

  * [DigitalOcean][7] VPS
  * Ubuntu
  * [Caddy][8]
  * [Jenkins][10]

**[A painless self-hosted Git service: Gitea][12]** from **[Bo-Yi Wu][13]**

課程中上我也給大家看 Gitea 在 Ubuntu 底下耗了多少記憶體：大約在 **40 ~ 60 MB** 所以開個最小機器也是綽綽有餘。

[<img src="https://i2.wp.com/c1.staticflickr.com/3/2948/33356162664_da7395366d_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-04-22 at 11.17.41 PM" data-recalc-dims="1" />][14]

最後來個工商服務，如果大家想學習 Go 語言，可以報名我在 iThome 的課程: 『[Go 語言一天就上手][15]』，可以由此[連結][16]進行報名。

## 後記

這次聚會遇到好多大神，像是 [DK 大大][17]、[保哥][18]、[BlueT][19] 及 [Hackmd][20] 作者 [Max][21]，難得大家來到新竹聚聚，感覺真的很棒，最後感謝 [Peter][22] ([CDNJS][23] Maintainer) 的主辦及工作團隊，活動真的很棒。

 [1]: https://www.flickr.com/photos/appleboy/32012549582/in/dateposted-public/ "gitea"
 [2]: https://www.facebook.com/DigitalOceanHsinchu/
 [3]: https://gitea.io
 [4]: https://blog.wu-boy.com/2017/01/new-git-code-hosting-option-gitea/
 [5]: http://www.nctu.edu.tw/
 [6]: https://golang.org/
 [7]: https://www.digitalocean.com/
 [8]: https://caddyserver.com/
 [9]: https://letsencrypt.org/
 [10]: https://jenkins.io/
 [11]: https://www.flickr.com/photos/appleboy/33407490713/in/dateposted-public/ "2017-04-23-18-18-45"
 [12]: //www.slideshare.net/appleboy/a-painless-selfhosted-git-service-gitea "A painless self-hosted Git service: Gitea"
 [13]: https://www.slideshare.net/appleboy
 [14]: https://www.flickr.com/photos/appleboy/33356162664/in/dateposted-public/ "Screen Shot 2017-04-22 at 11.17.41 PM"
 [15]: http://bitly.com/oneday-golang
 [16]: http://learning.ithome.com.tw/course/JjojzNh9P1N9H
 [17]: https://github.com/gslin
 [18]: https://github.com/doggy8088
 [19]: https://github.com/BlueT
 [20]: https://hackmd.io/
 [21]: https://github.com/jackycute
 [22]: https://github.com/PeterDaveHello
 [23]: https://github.com/cdnjs/cdnjs