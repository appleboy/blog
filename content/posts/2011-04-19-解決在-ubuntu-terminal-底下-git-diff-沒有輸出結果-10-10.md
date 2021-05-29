---
title: '解決在  Ubuntu Terminal 底下 git diff 沒有輸出結果 10.10'
author: appleboy
type: post
date: 2011-04-19T12:35:52+00:00
url: /2011/04/解決在-ubuntu-terminal-底下-git-diff-沒有輸出結果-10-10/
views:
  - 218
bot_views:
  - 118
dsq_thread_id:
  - 283302597
categories:
  - Git
  - Ubuntu
tags:
  - git
  - Ubuntu

---
自從把筆電安裝成 [Ubuntu 10.10 maverick][1] 後，把所有 <a href="http://github.com" target="_blank">github</a> 上面程式碼都用 [git][2] clone 下來，最近遇到一個非常奇怪的問題，那就是修改檔案之後，正常來講，可以用 git diff 來查看修改過的程式碼，但是非常奇怪的事情就發生了，『完全沒有輸出』，後來在網路上找到一篇解法 [git diff shows no output][3]，原來是 $LESS 這個環境變數搞的鬼，其實可以用 <span style="color:green"><strong>git diff | cat</strong></span> 方式看到 diff 結果。 我們打開 .bashrc 發現底下設定 

<pre class="brush: bash; title: ; notranslate" title="">export EDITOR="vim"
export GIT_PAGER="less"
export LESS="-XEfmrSw"
export PAGER="most"</pre> 重點就在於 $LESS 必須加上 

<span style="color:red"><strong>-X</strong></span>，並且請裝上 most 這指令 

<pre class="brush: bash; title: ; notranslate" title="">apt-get install most</pre>

 [1]: http://www.ubuntu-tw.org/
 [2]: http://git-scm.com/
 [3]: http://git.661346.n2.nabble.com/git-diff-shows-no-output-td5444443.html