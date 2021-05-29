---
title: svn 恢復略過衝突檔案 (conflict file)
author: appleboy
type: post
date: 2011-05-04T02:27:58+00:00
url: /2011/05/svn-恢復略過衝突檔案-conflict-file/
views:
  - 167
bot_views:
  - 99
dsq_thread_id:
  - 294699926
categories:
  - SVN
  - 版本控制
tags:
  - svn
  - 版本控制

---
當我們利用 svn up 更新程式碼，如果遇到修改相同檔案的相同地方，就會發生衝突 (conflict) 此時就必須修改或者是略過，當選擇略過此檔案就會出現底下訊息 

> Skipped 'lib/logs/logDB.txt' Skipped 'lib/confs/Conf.php' At revision 912. Summary of conflicts: Skipped paths: 2 之後怎麼用 svn up 更新檔案，都會因此被略過，那該怎麼恢復被略過檔案的狀態，讓它們可以繼續被更新呢？網路上找到一篇 [svn local obstruction, incoming add upon merge][1] 解法，用 <span style="color:green"><strong>svn resolve</strong></span> 來解決問題，只要針對該檔案打入底下指令即可 

<pre class="brush: bash; title: ; notranslate" title="">svn resolve --accept working lib/confs/Conf.php
svn resolve --accept working lib/logs/logDB.txt</pre>

 [1]: http://little418.com/2009/05/svn-local-obstruction-incoming-add-upon-merge.html