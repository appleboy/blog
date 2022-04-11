---
title: Git rebase + stash 小技巧
author: appleboy
type: post
date: 2013-08-18T03:37:01+00:00
url: /2013/08/git-rebase-stash-tip/
dsq_thread_id:
  - 1614174478
categories:
  - Git
  - 版本控制
tags:
  - git
  - git rebase
  - git stash

---

每天打開電腦，第一件事情就是將專案程式碼更新的最新，以便整合同事新開發的功能，免的跟自己寫的功能衝突，所以最常用用的就是 `git pull --rebase origin master`，此命令使用 `rebase` 來取代 `merge` 程式碼，也可以避免在 log 清單內出現 `merge branch master into master` 等字樣，但是如果在開發一半進度時，想同時將同事的程式碼先 merge 進來，會發現無法 merge，git 會請你先將 local 修改過的檔案 commit，才可以讓您更新，所以這時候我們可以用 git stash 方式來解決

如果你在 master 分支上，並且想 pull 最新的 commit，可以透過底下指令步驟

```bash
$ git stash --include-untracked
$ git pull --rebase origin master
$ git stash pop
```

<!--more-->

此方式一樣最後需要解決衝突，解決完成，可以將 stash 清空，透過再次執行 `git stash pop`，或 `git stash drop` 就可以了，但是這樣有點麻煩，可以不要使用 `git stash` 也達成這效果嘛？底下是更好的方式

```bash
git add .
git commit -m 'push to stash'
git pull --rebase origin master
git reset HEAD~1
```

基本上原理很簡單，我們先將 local 檔案 commit 到 local，接著一樣執行 `pull --rebase` 將遠端 commit 拉下來，接著執行 `git reset HEAD~1` 就是刪除最後一個 commit 但是保留最後 commit 修改的內容。
