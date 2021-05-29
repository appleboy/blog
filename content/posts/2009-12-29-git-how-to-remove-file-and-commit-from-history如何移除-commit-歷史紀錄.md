---
title: '[Git] how to remove file and commit from history(如何移除 commit 歷史紀錄)'
author: appleboy
type: post
date: 2009-12-29T12:59:40+00:00
url: /2009/12/git-how-to-remove-file-and-commit-from-history如何移除-commit-歷史紀錄/
views:
  - 5122
bot_views:
  - 401
dsq_thread_id:
  - 246696277
categories:
  - Git
tags:
  - git
  - 版本控制

---
今天在 commit 程式碼到 [github][1] 網站，不小心把 Plurk 帳號密碼給 commit 上去，發生這種事情，所以趕快上網查了一下如何移除 commit 歷史紀錄： 假設我們的 commit tree 如下： 

> R--A--B--C--D--E--HEAD 接下來要移除 B 跟 C 的 commit tree，變成 

> R--A--D'--E--HEAD 有兩種方式可以移除 B & C 

<pre class="brush: bash; title: ; notranslate" title=""># detach head and move to D commit
git checkout <SHA1-for-D>

# move HEAD to A, but leave the index and working tree as for D
git reset --soft <SHA1-for-A>

# Redo the D commit re-using the commit message, but now on top of A
git commit -C <SHA1-for-D>

# Re-apply everything from the old D onwards onto this new place 
git rebase --onto HEAD <SHA1-for-D> master

# push it
git push --force
</pre> 另一種方法是利用 cherry-pick 方式 

<pre class="brush: bash; title: ; notranslate" title="">git rebase --hard <SHA1 of A>
git cherry-pick <SHA1 of D>
git cherry-pick <SHA1 of E></pre> 這會直接忽略 B 跟 C 的 history，詳細資料可以查詢 git help cherry-pick 或者是 git help rebase 參考： 

[Git: removing selected commits from repository][2] [Git: how to remove file and commit from history][3] [Re: ! [rejected] master -> master (non-fast forward)][4]

 [1]: http://github.com/
 [2]: http://stackoverflow.com/questions/495345/git-removing-selected-commits-from-repository
 [3]: http://bogdan.org.ua/2009/02/13/git-how-to-remove-file-commit-from-history.html
 [4]: http://kerneltrap.org/mailarchive/git/2007/11/18/425729