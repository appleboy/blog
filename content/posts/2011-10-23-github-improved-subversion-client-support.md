---
title: Github 支援 SVN Client
author: appleboy
type: post
date: 2011-10-23T05:43:00+00:00
url: /2011/10/github-improved-subversion-client-support/
dsq_thread_id:
  - 450962163
categories:
  - Git
  - SVN
  - 版本控制
tags:
  - git
  - Github
  - svn

---
<a href="https://github.com/" target="_blank">Github</a> 一年前宣佈開始<a href="https://github.com/blog/626-announcing-svn-support" target="_blank">支援 SVN Client</a>，不過這是必須透過 <span style="color: red;">https://svn.github.com</span> 才可以取得資料，跟一般 git 的網址不一樣，然而就在最近宣佈了<a href="https://github.com/blog/966-improved-subversion-client-support" target="_blank">同步支援 svn</a> 也可以存取 <span style="color: green;"><strong>https://github.com/</strong></span>，並且過不久的將來會移除 <del datetime="2011-10-23T05:26:31+00:00">https://svn.github.com/</del> 網域。 

### URL 處理 git 方式: 

<pre class="brush: bash; title: ; notranslate" title="">$ git clone https://github.com/appleboy/PHP-CodeIgniter-Framework-Taiwan git-ds
Cloning into git-ds...
remote: Counting objects: 4177, done.
remote: Compressing objects: 100% (665/665), done.
remote: Total 4177 (delta 3544), reused 4140 (delta 3509)
Receiving objects: 100% (4177/4177), 2.65 MiB | 239 KiB/s, done.
Resolving deltas: 100% (3544/3544), done.</pre> svn 方式: 

<pre class="brush: bash; title: ; notranslate" title="">$ svn checkout https://github.com/appleboy/PHP-CodeIgniter-Framework-Taiwan svn-ds
A    svn-ds/branches
A    svn-ds/branches/develop
A    svn-ds/branches/develop/README
A    svn-ds/branches/develop/changelog.html
A    svn-ds/branches/develop/index.html
A    svn-ds/branches/develop/license.html
.......</pre> 官網還陸續介紹了 svn 如何在 github 上面的使用，如果對 svn 熟悉的朋友們我想也不陌生了，還沒熟悉 git 之前，我想可以先用 svn 玩 github 功能。底下是 github 打算將來支援的 svn 功能 

  * 支援 branch merging 和 rebasing
  * better mapping of Subversion <=> GitHub user names in commits
  * 支援 annotate/blame
  * 讓 trunk 可以對應到 git branch 除了 master 之外 參考: 

<a href="https://github.com/blog/966-improved-subversion-client-support" target="_blank">Improved Subversion Client Support</a>