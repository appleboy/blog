---
title: 該如何寫好 git commit message
author: appleboy
type: post
date: 2015-09-18T07:09:49+00:00
url: /2015/09/how-to-write-git-commit-message/
dsq_thread_id:
  - 4140753567
categories:
  - Git
  - 版本控制
tags:
  - git

---
[<img src="https://i0.wp.com/farm3.staticflickr.com/2238/13158675193_2892abac95_n.jpg?w=840" alt="github-logo" data-recalc-dims="1" />][1]

[Git][2] 已經是每天必用的工具，也是團隊間互相合作的重要角色。要寫好 Git commit message，讓團隊成員可以知道每一個 Commit 代表什麼意思，這是非常重要的。網路上看到一篇[教您如何寫好 Git commit message][3]，好的 Commit Log 可以讓其他同事快速知道這個 Pull Request 包含了哪些異動，該作者寫了七點，分別如下

  1. 將標題與內容中間多一行空白
  2. 標題限制 50 字元
  3. 標題第一個字必須為大寫
  4. 標題最後不要帶上句號
  5. 標題內容可以使用強烈的語氣
  6. 內容請用 72 字元來斷行
  7. 內容可以解釋 what and why vs. how

要強制大家有共通的 commit format 其實很難，所以團隊內會使用 issue track 系統，大家把 issue 或 feature 都開好，在標題列裡面就要強制將 issue number 寫入，然後在 issue 那邊把內容及作法詳細寫清楚，方便追蹤，這樣也是可以的。

PS. 該是強迫自己把 commit log 寫好會比較好，通常在追問題，也時候也會發現自己寫的 Log 不是很清楚。

 [1]: http://www.flickr.com/photos/appleboy/13158675193/ "github-logo by appleboy46, on Flickr"
 [2]: https://git-scm.com/
 [3]: http://chris.beams.io/posts/git-commit/