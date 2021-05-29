---
title: '開發者另類的自架 Git 服務選擇: Gitea'
author: appleboy
type: post
date: 2017-01-07T14:31:52+00:00
url: /2017/01/new-git-code-hosting-option-gitea/
dsq_thread_id:
  - 5443334984
categories:
  - DevOps
  - Git
  - Golang
tags:
  - gitea
  - Github
  - gogs
  - golang

---
[<img src="https://i2.wp.com/c1.staticflickr.com/1/306/32012549582_3de35c29c8_o.png?w=840&#038;ssl=1" alt="" data-recalc-dims="1" />][1]

現在 Git 服務最有名的就是 [Github][2]，如果是開放原始碼，我很推薦 Github。如果是想要放大量私有專案或企業內及個人使用，想必大家會推薦 [Gitlab][3]，在這裡就不多介紹 Gitlab 了，可以從 [Google 找到許多相關資料][4]，本篇會介紹另類的 Git 自架服務選擇 [Gitea][5]，在介紹之前可以先參考我在 2014 年寫了一篇用 [Go 語言開發的 Git 服務叫做 Gogs][6]。

<!--more-->

## 緣起

[Gitea][7] 是 2016 下半年由 [@bkcsoft][8], [@lunny][9] 和 [@tboerger][10] 及[其他開發者][11]共同發起，從原本的 [Gogs][12] 專案在分支出來，在剛開始起來的時候，很多開發者一直詢問為什麼會有 Gitea，而不是持續開發 Gogs，於是 Gitea 官方寫了一篇文章關於 [Gitea 誕生][13]，裡面詳細介紹為什麼會有 Gitea，有興趣的可以去看看，最主要的原因就是為了讓專案可以持續發展，而不是受限於個人因素，大家都知道 Open Source 到最後最難持續的就是找到更多人來維護專案，所以 Gitea 為了避免 Issue 或 Pull Request 太久沒人處理，我們訂了一個機制，就是 PR 只要通過兩位 Reviewer 留言 `LGTM` 就可以直接 Merged，這也讓更多開發者願意貢獻到 Gitea。從去年 12 月到現在 2017 年 1 月，已經 Release 了兩個版本。

## 安裝

為了能讓 Gogs 用戶可以無痛轉換到 Gitea，我們寫了一篇[升級教學][14]，除此之外，也提供了各種安裝方式: [Docker 安裝][15]、[下載執行檔][16]、[用套件][17]、[Windows 安裝][18]、[自行編譯][19] .. 等各種方式。最簡單的方式就是透過[下載執行檔][20]，只要一個指令就可以看到歡迎畫面了

```bash
./gitea web
```

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/32013522942/in/dateposted-public/" title="安裝頁面   Gitea  Git with a cup of tea"><img src="https://i1.wp.com/c7.staticflickr.com/1/292/32013522942_76d7b1fa02_c.jpg?resize=579%2C800&#038;ssl=1" alt="安裝頁面   Gitea  Git with a cup of tea" data-recalc-dims="1" /></a>

將來如果要升級 gitea，更是容易，你不用停掉 gitea 服務，只要下載新的檔案，覆蓋掉原有的執行檔，接著下: (其中 `custom/run/app.pid` 是 gitea 執行的 pid 記錄檔)

```bash
kill -USR2 $(cat custom/run/app.pid)
```

就可以完成升級，原本的服務也不會因此而中斷。這要感謝 [Facebook][21] 開發的 [grace][22] 套件，這套件並不支援 Windows，所以上面的升級方式不適用在 Windows 平台，不過我相信很少人會把 Git 服務架在 Windows 系統。

## 總結

在這邊先跟大家聊一下為什麼要選 Gitea:

  1. Gitea 是用 [Golang][23] 所撰寫。
  2. 使用介面跟 Github 很類似，如果你已經很習慣 Github，那轉換到 Gitea 一定不會很陌生。
  3. 安裝及升級比其他服務來得容易 (Gitlab, Bitbucket)
  4. 如果家中有 [Raspberry Pi][24] 硬體，你可以輕易地將 Gitea 放在上面執行
  5. 跨平台: Gitea 可以運作在任何 Go 能夠編譯的平台: Windows, macOS, Linux, ARM 等等

現在官方有支援[繁體中文][25]，歡迎大家加入翻譯行列。

 [1]: https://i2.wp.com/c1.staticflickr.com/1/306/32012549582_3de35c29c8_o.png?ssl=1
 [2]: https://github.com/
 [3]: https://about.gitlab.com/
 [4]: https://www.google.com.tw/?gfe_rd=cr&ei=AO1wWPbPJMb48Aee1aqoBQ&gws_rd=ssl#q=gitlab&tbs=lr:lang_1zh-TW&lr=lang_zh-TW
 [5]: http://gitea.io/
 [6]: https://blog.wu-boy.com/2014/04/go-git-service-using-go-language/
 [7]: https://github.com/go-gitea
 [8]: https://github.com/bkcsoft
 [9]: https://github.com/lunny
 [10]: https://github.com/tboerger
 [11]: https://github.com/orgs/go-gitea/people
 [12]: https://github.com/gogits/gogs
 [13]: https://blog.gitea.io/2016/12/welcome-to-gitea/
 [14]: https://docs.gitea.io/zh-tw/upgrade-from-gogs/
 [15]: https://docs.gitea.io/zh-tw/install-with-docker/
 [16]: https://docs.gitea.io/zh-tw/install-from-binary/
 [17]: https://docs.gitea.io/zh-tw/install-from-package/
 [18]: https://docs.gitea.io/zh-tw/windows-service/
 [19]: https://docs.gitea.io/zh-tw/install-from-source/
 [20]: https://dl.gitea.io/gitea/
 [21]: https://facebook.com/
 [22]: https://github.com/facebookgo/grace
 [23]: https://golang.org/
 [24]: https://www.raspberrypi.org/
 [25]: https://gitea.io/zh-tw/