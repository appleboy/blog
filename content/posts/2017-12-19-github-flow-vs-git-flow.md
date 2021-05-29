---
title: GitHub Flow 及 Git Flow 流程使用時機
author: appleboy
type: post
date: 2017-12-19T03:48:08+00:00
url: /2017/12/github-flow-vs-git-flow/
dsq_thread_id:
  - 6357828940
categories:
  - Git
tags:
  - git
  - Github

---
[<img src="https://i2.wp.com/farm5.staticflickr.com/4726/39143290882_877ebfcf8e_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-12-20 at 11.45.04 AM" data-recalc-dims="1" />][1]

在 Facebook 上面看到這篇『[git flow 實戰經驗談][2]』，想說來寫一下對於團隊內該導入 [GitHub Flow][3] 還是 [Git Flow][4]，寫下自己的想法給大家參考看看。當你加入團隊，第一件事情就是嘗試了解目前團隊是走哪一種 Git 流程，但是在團隊內可能使用 [GitHub 流程][3]或者是傳統 [Git 流程][4]，在開始進入開發流程時，請務必先了解團隊整個 Release 流程。後者流程在筆者幾年前有發表一篇『[branch model 分支模組基本介紹][5]』，如果大家有興趣可以先看看，而我自己在團隊內使用這兩種流程，嘗試過幾個團隊，得到底下結論:

  * 公司內部請使用 [GitHub 流程][3]
  * 開源專案請使用 [GitHub 流程][3] + [Git 流程][4]

底下來探討為什麼我會有這些想法。首先先來看看公司團隊內部如果是走 Git 流程會有哪些缺陷。

<!--more-->

## 學習困難

[<img src="https://i2.wp.com/farm5.staticflickr.com/4600/39117139792_235d81dd9e_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-12-19 at 11.10.58 AM" data-recalc-dims="1" />][6]

很多開發者對於 branch 分支不是很了解，也常常下錯指令，首先在 Git Flow 內，需要先了解什麼時候在 develop 開分支，什麼時候該對 release 開分支。另外什麼時候該將 commit 拉到 develop，什麼時候該拉到 release 內。這些種種環境都圍繞在團隊內部，如果你不知道該將目前的分支 merge 到正確的地方，這會是團隊開發速度的瓶頸，尤其是在處理釋出下一版功能情況下。多個分支只會造成大家對於軟體流程的困擾，也讓剛加入團隊的新人需要一段時間去適應，團隊內也需要一位開發者去輔導大家，那何不導入簡易的 GitHub Flow 來改善這問題呢？

## 管理不易

多個分支造成大家不小心拉了不對的 commit 進到任何分支，這邊要如何避免此狀況，那就只能用 Protected 分支方式，讓團隊全部成員都需要發 Pull Request 狀態下才可以將修改的內容合併到正確分支，但是這也不是一個很好的解法，今天假設要釋出軟體 v1.0.0 版本時，會將 develop 的全部 commit 都合併到 release 分支，這邊有兩種做法，一種是不打 Tag，也就是 CI/CD 服務是監聽 release 分支，只要 release 有變動，CI/CD 服務就開始部署到 Production，另一種是在 Release 分支上下 Tag，透過 CI/CD 來監聽 Tag 事件，這兩種我都有看過團隊使用。但是前者的缺陷是，如果沒走 Tag 的話，你怎麼知道現在 Production 機器上面是哪一個版本，以及該如何知道此版跟上一版本的差異在哪邊。而後者雖然解決了版本差異的問題，但是 Tag 基本上不該限制只能在單一特定分支。

## 如何解決

[<img src="https://i1.wp.com/farm5.staticflickr.com/4734/38293804325_af60a2715e_o.png?w=840&#038;ssl=1" alt="Screen Shot 2017-12-20 at 11.40.21 AM" data-recalc-dims="1" />][7]

為了解決上述兩大問題，我建議在公司團隊內使用 GitHub Flow 來減少流程步驟，讓工程師可以更專心在開發上面，而不是花更多時間在 Git 分支操作上面。GitHub Flow 只需要記住主分支 `master` 其他分支都是從主分支在開出來，所以新人很容易理解，不管是解 Issue 還是開發新功能，都是以 `master` 分支為基底來建立新的分支，開發團隊也只需要懂到這邊就可以了。接下來 Deploy 到 Production 則是透過 Tag 方式來解決。由開發團隊主管來下 Tag，這樣可以避免團隊內部成員不小心合併分支造成 Deploy 到正式環境的錯誤狀況。另外大家會遇到上線後，如何緊急上 Patch 並且發佈下一個版本，底下是最簡單的操作步驟。

<pre><code class="language-bash"># 抓取遠端所有 tag
$ git fetch -t origin

# 從上一版本建立 branch (0.2.4 代表上一個版本)
$ git checkout -b patch-1 origin/0.2.4

# 把修正個 commit 抓到 patch-1 branch
$ git cherry-pick commit_id

# 打上新的 Tag 觸發 Deploy 流程
$ git tag 0.2.5
$ git push origin 0.2.5

# 將 patch 也同步到 master 分支
$ git checkout master
$ git cherry-pick commit_id
$ git push origin master</code></pre>

有沒有覺得跟 Git Flow 流程差異很多，大家只需要記住兩件事情，第一是專案內只會有 `master` 分支需要受到保護。第二是部署流程一律走 Tag 事件，這樣可以避免工程師不小心 Merge commit 造成提前部署，因為平常開發過程，不會有人隨便下 Git Tag，所以只要跟團隊同步好，Git Tag 都由團隊特定人士才可以執行即可。底下附上團隊內的流程:

[<img src="https://i0.wp.com/farm5.staticflickr.com/4588/38293694275_87406c7438_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-12-20 at 11.36.30 AM" data-recalc-dims="1" />][8]

## 開源專案

為什麼開源專案需要走 Github Flow + Git Flow 呢？原因其實很簡單，假設現在要釋出 1.0.0 版本，那肯定會從 `master` 上單一節點去下 tag 標記為 `1.0.0`，這沒問題，這版本釋出之後，CI/CD 服務會自動依照 Tag 事件來自動化部署軟體到 GitHub Release 頁面。但是軟體哪有沒 bug 的，一但發現 Bug，這時候想發 Pull Request 回饋給開源專案，會發現只能針對 master 發 Pull Request，該專案團隊這時候就需要在下完 Tag 同時建立 `release/v1.0` 分支，方便其他人在發 PR 時，在 review 完成後合併到 master 內，接著團隊會告知這 PR 需要被放到 `release/v1.0` 內方便釋出下一個版本 `v1.0.1`，所以我才會下這個結論，一個好的開源專案是需要兩個 Flow 同時使用。而在開源專案上的好處是，你不用擔心別人不會 Git 流程或指令。基本上不會用 Git 的開發者，也不會發 Pull Request 了。

## 結論

兩者流程各有優缺點，在選擇流程時，請務必考量 CI/CD 的串接方式，以及團隊成員的狀況來決定流程，而這篇最主要提出我在公司團隊內，以及在開源專案上看到的流程。最終都是找到一個最佳流程來讓專案執行的更順利，希望此篇能對要導入 Git 服務的朋友們有點幫助。歡迎大家隨時留言討論。

## 問與答

整理朋友提出來的一些疑問，歡迎大家參考看看。

#### Q1: 選擇 GitHub flow 都是因為怕自動部署造成錯誤。如果在部署到 production 前，都先部署到測試環境，還會有這樣的問題嗎？

其實我最主要不是怕自動部署造成錯誤，反而是我帶人的時候，不管是不是資深的工程師都有這問題，不熟悉 Git 整個流程，需要依賴 [SourceTree][9] 這工具，然而這工具真的害死一堆剛入門的朋友，不好好學 command，一開始就碰 SourceTree，你根本不知道 SourceTree 在背景做了哪些事情。至於部署流程，這牽扯到跟 CI/CD 相關，我個人覺得只要權限設定對，把可以 release 產品的開發者都設定好，理論上不會出什麼錯誤才是。而我用 Tag 的原因是方便記錄版本差異。當然先部署到 Staging 上面測試，這是必經流程，沒人可以在還沒測試過的狀態下，部署到正式環境。

 [1]: https://www.flickr.com/photos/appleboy/39143290882/in/dateposted-public/ "Screen Shot 2017-12-20 at 11.45.04 AM"
 [2]: http://blog.hellojcc.tw/2017/12/14/the-flaw-of-git-flow/
 [3]: https://guides.github.com/introduction/flow/
 [4]: http://nvie.com/posts/a-successful-git-branching-model/
 [5]: https://blog.wu-boy.com/2011/03/git-%E7%89%88%E6%9C%AC%E6%8E%A7%E5%88%B6-branch-model-%E5%88%86%E6%94%AF%E6%A8%A1%E7%B5%84%E5%9F%BA%E6%9C%AC%E4%BB%8B%E7%B4%B9/
 [6]: https://www.flickr.com/photos/appleboy/39117139792/in/dateposted-public/ "Screen Shot 2017-12-19 at 11.10.58 AM"
 [7]: https://www.flickr.com/photos/appleboy/38293804325/in/dateposted-public/ "Screen Shot 2017-12-20 at 11.40.21 AM"
 [8]: https://www.flickr.com/photos/appleboy/38293694275/in/dateposted-public/ "Screen Shot 2017-12-20 at 11.36.30 AM"
 [9]: https://www.sourcetreeapp.com/