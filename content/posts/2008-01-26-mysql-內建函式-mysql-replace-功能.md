---
title: '[MySQL] 內建函式 MySQL Replace 功能'
author: appleboy
type: post
date: 2008-01-27T05:16:51+00:00
url: /2008/01/mysql-內建函式-mysql-replace-功能/
views:
  - 2915
bot_views:
  - 552
dsq_thread_id:
  - 246785133
categories:
  - php
  - sql

---
今天老師寄信給我，說我轉移的 [journal.CN][1] 的文章，出現以前的文章，不能看到圖片，我去查了一下，發現 AMS 文章系統的編輯軟體，相當爛，它的插入圖片，竟然是用絕對網址，然後他會先讀取 mainfile.php 裡面的 

<pre class="brush: php; title: ; notranslate" title="">define('XOOPS_URL', 'http://journal.cn.ee.ccu.edu.tw');
</pre> 然後把圖片的網址寫死，而不是動態的，就是利用相對路徑，所以我利用了 replace 的功能來解決全部文章圖片的問題，語法如下 

<pre class="brush: sql; title: ; notranslate" title="">update `xoops_ams_text` set `hometext` = replace(`hometext`,'140.123.107.38/~cnews','journal.cn.ee.ccu.edu.tw');
</pre> 上面是說，取代 hometext 這個欄位的，找到 140.123.107.38/~cnews 取代成 journal.cn.ee.ccu.edu.tw 這語法相當好用，大家可以嘗試看看，畢竟如果用 php 的 replace 語法，還要利用陣列方式，比較麻煩

 [1]: http://journal.cn.ee.ccu.edu.tw/