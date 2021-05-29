---
title: git cherry-pick 處理專案 pull request
author: appleboy
type: post
date: 2011-08-27T04:11:09+00:00
url: /2011/08/git-cherry-pick-處理專案-pull-request/
dsq_thread_id:
  - 397119510
categories:
  - CodeIgniter
  - Git
tags:
  - CodeIgniter
  - git

---
很高興最近有些網路上朋友想要加入<a href="https://github.com/appleboy/PHP-CodeIgniter-Framework-Taiwan" target="_blank">翻譯 CodeIgniter 的計畫</a>，本人在 2009 年開啟這計畫時，就打算用當時蠻熱門的 <a href="http://git-scm.com/" target="_blank">git</a> 來控管翻譯的進度，然而也選用了 <a href="https://github.com/" target="_blank">github</a> 來當作 Web 平台，可是大家對於入門 git 有很大的挫折，其實學習 git 沒有想像中這麼難，想要貢獻自己的程式碼都可以在 github 找到教學步驟，2009 年那時候 github 文件還尚未像現在這麼完整，入門之前可以先閱讀 <a href="http://help.github.com/" target="_blank">git help 教學</a>，貢獻程式碼之前可以先 <a href="http://help.github.com/fork-a-repo/" target="_blank">Fork 專案</a>，接著進行 <a href="http://help.github.com/send-pull-requests/" target="_blank">Pull request</a>，這些都是透過 Web 介面就可以做到了，但是大家在 pull request 之前記得先將專案程式碼更新，以及 pull request 時選取需要的 commit 阿，先看一個範例，有朋友發了一個 <a href="http://codeigniter.org.tw/user_guide/libraries/xmlrpc.html" target="_blank">XML-RPC Class</a> 翻譯的 <a href="https://github.com/appleboy/PHP-CodeIgniter-Framework-Taiwan/pull/3" target="_blank">Chinese Pull request</a> 來，但是大家有沒有看到內容，裡面還包含了先前 <a href="https://github.com/appleboy/PHP-CodeIgniter-Framework-Taiwan/pull/2" target="_blank">Html Table 翻譯</a>，所以這時候我就必須用 <a href="http://www.kernel.org/pub/software/scm/git/docs/git-cherry-pick.html" target="_blank">git cherry-pick</a> 來挑選需要的 commit。

### git cherry-pick 使用方法

我們如何 Merge 別人的 pull request，首先新增 remote add branch:

<div>
  <pre class="brush: bash; title: ; notranslate" title=""># gname 可以自己自訂
git remote add gname https://github.com/gname/PHP-CodeIgniter-Framework-Taiwan.git
# fetch 程式碼下來
git fetch gname
# 選取您要合併的 commit
# -n 代表多個 commit
git cherry-pick -n bf0246c8 ab3f4943
# 可以修改 commit log 內容
git commit -c bf0246c8</pre>
</div>

這樣就可以不用 merge 全部的內容，也相當方便 ^^