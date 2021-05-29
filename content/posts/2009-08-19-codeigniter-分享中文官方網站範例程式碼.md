---
title: '[CodeIgniter] 分享中文官方網站範例程式碼'
author: appleboy
type: post
date: 2009-08-18T16:04:18+00:00
url: /2009/08/codeigniter-分享中文官方網站範例程式碼/
views:
  - 16646
bot_views:
  - 1042
dsq_thread_id:
  - 249298188
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
之前在高雄開了一堂：<a title="Permanent Link to [CodeIgniter] Open Source PHP Web Framework 系列講座" rel="bookmark" href="http://blog.wu-boy.com/2009/07/20/1511/">[CodeIgniter] Open Source PHP Web Framework 系列講座</a>，在上課過程，我很強調大家可以多多參考網路上的範例來學習，所以找了官方網站的程式碼想分享給大家，希望大家看完程式碼，可以針對 [CodeIgniter][1] 的 Model Views Controller 有比較深入的瞭解，如果有不懂的地方，可以來[論壇][2]這邊提出問題，我會儘快回答大家，底下是程式碼的下載網址，包含論壇程式 PHPBB3，以及所有影片程式碼，大家可以參考看看： [檔案下載][3] 裡面有需要注意的，就是 .htaccess 檔案： 

<pre class="brush: bash; title: ; notranslate" title="">RewriteEngine on
RewriteBase /
RewriteCond $1 !^(videos|download_files|user_guide|forum|index\.php|admin|css|flash|images|img|includes|js|language|captcha|robots\.txt)
RewriteRule ^(.*)$ index.php/$1 [L,QSA]</pre> 裡面會附上 db.sql 檔案，這是資料庫檔案，請麻煩匯入到您的資料庫，然後修改 

<span style="color:green">system/application/config/database.php</span> 內容的資料庫相關資訊，這樣就可以了。

 [1]: http://codeigniter.com/
 [2]: http://www.codeigniter.org.tw/forum/
 [3]: http://www.codeigniter.org.tw/download_files/CodeIgniter.tar.gz