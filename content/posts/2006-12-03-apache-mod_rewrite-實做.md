---
title: '[Apache] mod_rewrite 實做 防盜圖'
author: appleboy
type: post
date: 2006-12-04T02:29:28+00:00
url: /2006/12/apache-mod_rewrite-實做/
bot_views:
  - 1018
views:
  - 5196
dsq_thread_id:
  - 246999928
categories:
  - apache
  - Network

---
PTT 的 php版 有人問到 

> 如何在URL隱藏&#8217;.php&#8217; 有時候會看到一些網站的URL沒有後面的.php .jsp .xxx 自己加上去反而無法開啟 像 http://www.google.com.tw/search?hl=zh-TW&q=abc 讓人無法得知該網站是使用哪種語言開發 請問要如何隱藏 我想這對網站的安全性應該有一些幫助 謝謝回覆 以下是我的回覆： 這是利用 mod_rewrite 作法達到的，其實不只隱藏 後面的php而已，還可以你隨便取呢 在根目錄底下新增 .htaccess[這個必須你的server有支援才行，有的不會讓你新增此檔 ] 然後在該檔裏面 寫下 <!--more--> RewriteEngine On RewriteBase / RewriteRule ^t=([0-9]+)$ board.php?t=$1 [L] RewriteRule ^f=([0-9]+)$ forum.php?f=$1 [L] 上面這個 是把 http://yourserver/board.php?t=1234 變成 http://yourserver/t=1234 縮短網址，非常方便~ 範例：拿我的論壇來舉例好了 http://forum.wu-boy.com/t=10428 這篇文章 跟 http://forum.wu-boy.com/board.php?t=10428 是不是都看到相同文章呢 &#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8211; RewriteCond %{HTTP\_REFERER} !^http://www.forum.wu-boy.com/.\*$ [NC] RewriteCond %{HTTP\_REFERER} !^http://forum.wu-boy.com/.\*$ [NC] RewriteCond %{HTTP\_REFERER} !^http://www.forum.wu-boy.com$ [NC] RewriteCond %{HTTP\_REFERER} !^http://forum.wu-boy.com$ [NC] RewriteRule .*\.(jpg|jpeg|gif|png|bmp)$ - [F,NC] alias /Big\_image/ "/backup02/Big\_file/" <Directory /backup02/Big\_file> Options -Indexes SetEnvIfNoCase Referer "^http://192\.168\.100\.244/dar/" local\_ref=1 <FilesMatch "\.(jpg|jpeg|gif|png|bmp)"> Order Allow,Deny Allow from env=local_ref Allow from 127.0.0.1 Allow from 192.168.100.244 #Allow from 163.29.208.22 </FilesMatch> </Directory> 上面這個 是我用來防止盜連圖片的，其實有很多種方法，這是其中一種而已~哈 問題2：無名小站網址 

> : ※ 引述《grassboy2 (天才小胖子-草兒活力花俏)》之銘言： : : 耶逗…這篇文章真的有shock到我… : : 看到這篇文章我在想… : : 像無名小站的http://www.wretch.cc/blog/UserName : : 是不是也是利用.htaccess去作 : : 然後自動將網址指定成http://www.wretch.cc/blog/index.php?id=UserName呢？ : : 另外…網路上有這方面的相關說明嗎@@~ : : 謝謝你分享了這篇有用的文章囉^^~ 我的解答： 恩 ～ 你要做到這樣也是可以～ 無名小站 也是這樣用的 RewriteEngine On RewriteBase /blog/ RewriteRule ^([A-Za-z_0-9-]+)/*$ /blog/index.php?id=$1 [L]</blockquote> 這樣就可以達到無名小站的功能～ http://httpd.apache.org/docs/2.0/mod/mod_rewrite.html