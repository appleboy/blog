---
title: 版本控制 svn move 移動或更名
author: appleboy
type: post
date: 2011-09-27T06:06:25+00:00
url: /2011/09/svn-mv-vs-git-mv/
dsq_thread_id:
  - 426954065
categories:
  - Git
  - Git
  - SVN
  - 版本控制
tags:
  - git
  - svn
  - 版本控制

---
公司採用 svn 當作版本控制，而我最近在整理 svn 上面全部的 source code。基本上我都會將 git 跟 svn 也一起搭配著用，因為個人比較熟悉 git 的操作方式，然而跟同事討論了專案目錄的架構，進而要把一些目錄轉換大小寫，本來的 App 就改成 app，這個在 git 底下(OS: Linux)操作非常容易，直接 git mv App app，之後看 git status 可以發現底下輸出： 

<pre class="brush: bash; title: ; notranslate" title=""># On branch develop
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#       renamed:    nav/hacks.txt -> Nav/hacks.txt
#       renamed:    nav/moo.fx.js -> Nav/moo.fx.js
#       renamed:    nav/moo.fx.pack.js -> Nav/moo.fx.pack.js
#       renamed:    nav/nav.js -> Nav/nav.js
#       renamed:    nav/prototype.lite.js -> Nav/prototype.lite.js
#       renamed:    nav/user_guide_menu.js -> Nav/user_guide_menu.js
#</pre> 可是在 svn 的流程不是這樣喔，首先 svn 會將原本的目錄先刪除，再來新增一個新目錄。這樣就算了，在 Windows 底下還不讓你這樣操作，請先裝 

<a href="http://www.sliksvn.com/en/download" target="_blank">Subversion Client</a>，然後請在"開始"->"執行" 打入 cmd，可以透過 svn mv 方式來操作 

<pre class="brush: bash; title: ; notranslate" title="">svn mv App app2
svn mv app2 app</pre> 如果裡面檔案目錄又很多的話，那就有的等了，畢竟對於 svn 而言都是在複製檔案，而不是像 git 是紀錄檔案差異。 

<a href="http://jdev.tw/blog/1493/subversion-move-folders-and-files" target="_blank">Subversion的搬移(Move)操作</a>