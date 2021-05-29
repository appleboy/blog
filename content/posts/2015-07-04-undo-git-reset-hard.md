---
title: git tips 找尋遺失的 commit 紀錄
author: appleboy
type: post
date: 2015-07-04T11:58:32+00:00
url: /2015/07/undo-git-reset-hard/
dsq_thread_id:
  - 3903961571
categories:
  - Git
  - 版本控制
tags:
  - git
  - git rebase
  - git reflog
  - git reset

---
[<img src="https://i0.wp.com/farm3.staticflickr.com/2238/13158675193_2892abac95_n.jpg?w=840&#038;ssl=1" alt="github-logo" data-recalc-dims="1" />][1]

個人每天常用的常用的三大 Git 指令分別是 `git reset`, `git pull`, `git rebase`，但是呢有時候手殘，常常把 git reset `--soft` 打成 git reset `--hard` 造成不可預期的錯誤，朋友圈內也有人常常問我該如何救不見的 commit，其實很容易，git 對於每隔操作後產生的 commit 都會存放在 Local 端，所以基本上不用擔心 commit 記錄會不見，有一種狀況會永遠消失，那就是假設尚未 commit 目前修正過的檔案，然後下 git reset `--hard` HEAD，這樣的話我想誰都無法幫忙把已修正過的檔案找回來了，原因是連 git 都不知道你改了什麼啊。所以為了避免這情況方生，個人建議開發者，只要開發到一定的階段，務必要下一個 commit 當作記錄，但是你會說，這樣功能開發完後，就會有很多個 commit 非常不好看，這時候可以嘗試 git rebase 將整個功能合併成一個 commit，這樣其他開發者 review 時就會非常清楚。

現在的問題是如果開發者不小心下了 `git reset --hard HEAD^`，上一個 commit 就會消失了，這時候該如何救回來呢？答案可以使用 `git reflog` 指令然觀看開發者全部 git 的操作記錄，裡面詳細記載你曾經下過的 git 指令

<pre><code class="language-bash">$ git reflog
794be8b HEAD@{0}: reset: moving to HEAD^
5e2be6f HEAD@{1}: commit (amend): update
bfa593c HEAD@{2}: cherry-pick: update
794be8b HEAD@{3}: reset: moving to 649c658
794be8b HEAD@{4}: reset: moving to HEAD^
649c658 HEAD@{5}: commit: update
794be8b HEAD@{6}: commit (initial): addd</code></pre>

上面可以看到之前 commit 的記錄，接著可以透過 `git reset --hard xxxxx`，或者是用 `git cherry-pick xxxxx` 將上一個 commit ID 記錄抓回來即可。

 [1]: https://www.flickr.com/photos/appleboy/13158675193/ "github-logo by appleboy46, on Flickr"