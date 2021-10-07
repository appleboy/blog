---
title: "如何發佈高質量的 Pull Request (簡稱 PR)"
date: 2021-10-06T22:02:25+08:00
author: appleboy
type: post
url: /2021/10/how-to-write-high-quality-pull-request
share_img: https://i.imgur.com/iQ6TfHQ.png
categories:
  - GitHub
tags:
  - code review
  - pull request
  - github
  - gitea
  - bitbucket
  - gitlab
---

![code review](https://i.imgur.com/iQ6TfHQ.png)

除了在公司團隊內負責審核各專案 PR 之外，也在 [GitHub][12] 上面提交多個 PR，並且與全世界各地開發者一起共同維護大型專案，一個好的 PR 可以加速專案的進行，也可以省下多數 Reviewr 寶貴的時間，故我自己整理底下幾點，來確保團隊同事之前有個共同的標準外，也大大降低 Review 時間，提升專案品質。

<!--more-->

## 確保通過所有 CI 流程再發 PR

通常開發者開發新功能或解 Bug 時，會開立新的分支，而當這個分支進行第一個新的 Commit 後，後面的 CI (測試, 代碼質量驗證) 就會開始進行完整流程，確保此提交是可以正常運作，而在發 PR 之前，開發同仁務必確保 CI 是有通過驗證的，而不是發了 PR，通知 Reviewr 後，等到 Reviewr 收到信件，點開來看發現 CI 是 Failure，這樣就浪費雙方寶貴的時間。除了 CI 之外，也可以將一些常用的驗證流程，寫進 Makefile 讓團隊可以自己的開發環境進行驗證，加速開發流程。

![commit log](https://i.imgur.com/0m2P3LI.jpg)

## 務必撰寫 Unit Testing

當工程師開發功能或解決問題後，請務必撰寫 Unit Testing，這點可以大幅降低 Reviewer 時間，我自己個人在看 PR 時，都會優先看測試的邏輯是否有符合業務邏輯，如果符合的話，其實接下來 Review 就會非常的快，當開發者沒寫測試，這時候就會相當擔心，這個 PR 會不會影響到其他功能，或者是不符合業務邏輯。雖然我知道大部分開發者都不太習慣寫測試，但是有了這個良好的習慣，團隊也不用擔心開發者會改壞既有的功能或產生無法預期的錯誤。

## 每個 PR 只做一件事情

在開發功能時，請務必將功能拆細，並且不要有太大的相依性，這樣可以讓整個 PR 改動的幅度最小，Reivewer 在看的時候，才不會因為此提交牽扯到多個模組，而造成 Review 時間加長，最後可能造成 PR 被拒絕，所以在開發過程如果發現這次的異動是可以在拆開多個 PR 時，請務必找同事或 PM 進行討論，將功能拆成多個 Task 進行開發。

## PR 請務必連接 Issue Tracking 系統

不管是新功能或者是 Bugs 都會有 Issue Tracking (像是 Jira 或是 GitHub Project 或是 Trello 等平台) 來記錄，在發 PR 務必跟這些 Task 連結在一起，這樣開發者可以在 Issue 上面詳細描述開發過程，也可以讓 Reviewer 快速了解之前在 Issue 上面討論過哪些方向或做法，也讓未來其他開發者在功能開發上可以找到相關的紀錄。

![issue link](https://i.imgur.com/AL3qCuH.jpg)

## 審核 PR 過程盡量少用 rebase commit history

當 PR 發出後，Reviewer 開始給開發者建議修改的方向，而開發者只需要根據這些建議，繼續將 commit 持續 push 上來即可，盡量不要使用 `git rebase` 將所有 commit log 進行整理，因為只要整理過後，Reviewer 就不知道已經看完哪些 commit，因為也許 Reviewer 只要針對後來 push 的 commit 挑著看即可。以現在所有 Git 服務來說 ([Gitea][11], [GitHub][12], [Bitbucket][13] 或 [GitLab][14]) 其實都有支援 [Squash Commit](https://www.gitkraken.com/learn/git/git-squash)，所以現在發 PR 後不要再進行整理 commit log 了。

![commit history](https://i.imgur.com/qeiHdi5.png)

上面這張圖可以說明當有新的 commit 時，GitHub 會很貼心的紀錄 Reviewer 尚未看到的部分，減少 Code Review 時間。

[11]:https://gitea.io/en-us/
[12]:https://github.com/
[13]:https://bitbucket.org/
[14]:https://about.gitlab.com/

## 多寫註解及說明

想要更有效率的 Code Review，請在 PR 提交的代碼中，增加說明，`What, Why, How`，說明遇到什麼問題，為什麼會這樣想，以及最後如何實作出來，這些都有效的幫助 Reviewer 知道你的開發邏輯思維，加速討論，這是雙贏的局面，一方面紀錄開發的想法，這樣大家也許會有不同的思維來看這提交。

![code review](https://i.imgur.com/gyWn2Ej.jpg)

## 心得感想

完整做到上面條件，會讓團隊有更多時間創造更大的價值，好的 PR 更可以讓團隊成員有良好的習慣帶動其他單位。這些條件會隨著團隊在合作磨合上會再陸續增加，上述就是在公司團隊內很常遇到的問題，整理在這邊給大家參考，如果有任何建議，歡迎大家留言討論

## 參考連結

* [关于 Pull Request 的十个建议](https://www.infoq.cn/news/2015/02/pull-reques-ten-suggestion/)
