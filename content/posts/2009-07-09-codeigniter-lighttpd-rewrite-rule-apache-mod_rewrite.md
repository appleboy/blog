---
title: '[CodeIgniter] lighttpd rewrite rule && apache mod_rewrite'
author: appleboy
type: post
date: 2009-07-09T04:05:43+00:00
url: /2009/07/codeigniter-lighttpd-rewrite-rule-apache-mod_rewrite/
views:
  - 14411
bot_views:
  - 851
dsq_thread_id:
  - 246729395
categories:
  - CodeIgniter
tags:
  - CodeIgniter
  - php

---
[CodeIgniter][1] 要移除網址列存在的 index.php，[apache][2] 必須使用 [mod_rewrite][3] 寫入 .htaccess 的方式來達成，[lighttpd][4] 也是有支援 rewrite，可以參考官方文件：[Module: mod_rewrite][5]，設定方法很容易。 

<pre class="brush: bash; title: ; notranslate" title="">$HTTP["host"] == "mimi.twgg.org" {
  server.document-root = "/var/www/html/MLB/"
  url.rewrite = (
        "^/images/.*$" => "$0",
        "^/includes/.*$" => "$0",
        "^/(.*)$" => "index.php/$1"

  )
  accesslog.filename = "/var/log/lighttpd/mimi.twgg.org-access_log"
}</pre>

<!--more--> images 跟 include 是您放圖片或者是 css js 的地方，您也可以開一個資料夾把全部靜態檔案放進去，就可以了，這樣不用設定太多的 rule，apache 的 .htaccess 設定方法如下： 

<pre class="brush: bash; title: ; notranslate" title="">RewriteEngine on
RewriteBase /
RewriteCond $1 !^(index\.php|images|includes)
RewriteRule ^(.*)$ index.php/$1 [L,QSA]</pre> 兩種作法很類似，都不難，筆記一下，將來會用到。 可以參考 CodeIgniter 官方文件：

[CodeIgniter URLs][6]

 [1]: http://codeigniter.com
 [2]: http://www.apache.org/
 [3]: http://httpd.apache.org/docs/2.0/mod/mod_rewrite.html
 [4]: http://www.lighttpd.net/
 [5]: http://redmine.lighttpd.net/wiki/lighttpd/Docs:ModRewrite
 [6]: http://codeigniter.com/user_guide/general/urls.html