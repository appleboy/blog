---
title: '[FreeBSD]Lighttpd + php5 + 解決 wordpress Permalinks mod_write'
author: appleboy
type: post
date: 2008-07-03T08:55:50+00:00
url: /2008/07/freebsdlighttpd-php5-解決-wordpress-permalinks-mod_write/
views:
  - 6284
bot_views:
  - 805
dsq_thread_id:
  - 246829683
categories:
  - apache
  - FreeBSD
  - Lighttpd
  - Linux
  - php
  - wordpress
  - www
tags:
  - apache
  - lighttpd
  - php
  - wordpress

---
今天轉換跑道了，最近玩 Apache 玩的很不順，因為只要線上人數一多，就會吃很多記憶體，導致必須重新開 Apache，所以今天來玩看看 [lighttpd][1]試試看，看看結果如何，其實轉換到 [lighttpd][1] 需要注意很多事情，那就是 Lighttpd 並不支援 .htaccess 檔案，所以 mode_rewrite 功能要設定到 Lighttpd.conf 裡面，然後也去找看看 Lighttpd 的 virtual host 的寫法，然後還有一點就是 wordpress 的 Permalinks 的問題，算是今天都解決了，底下來寫一下作法： <!--more-->

<pre class="brush: bash; title: ; notranslate" title="">#
# 安裝 lighttpd
#
cd /usr/ports/www/lighttpd; make install clean
#
# 安裝 php5
#
cd /usr/ports/lang/php5; make install clean
#
# 記得把 [X] FASTCGI    Enable fastcgi support (CGI only) 打勾
#
</pre> 不然會出現底下錯誤訊息： 

<pre class="brush: bash; title: ; notranslate" title="">2008-07-03 10:44:06: (mod_fastcgi.c.1036) If you're trying to run PHP as a FastCGI backend, make sure you're using the   FastCGI-enabled version.
You can find out if it is the right one by executing 'php -v' and it should display '(cgi-fcgi)' in the output, NOT      '(cgi)' NOR '(cli)'.</pre> 底下是 php-cgi -v 

<pre class="brush: bash; title: ; notranslate" title="">PHP 5.2.6 with Suhosin-Patch 0.9.6.2 (cgi-fcgi) (built: Jul  3 2008 10:49:48)
Copyright (c) 1997-2008 The PHP Group
Zend Engine v2.2.0, Copyright (c) 1998-2008 Zend Technologies</pre> 那如果你沒有支援的話，那就是在 update php5 

<pre class="brush: bash; title: ; notranslate" title="">#
# 利用 portupgrade 指令
#
portupgrade -rf php5-5.2.6</pre> 裝好之後呢，其實就差不多了，接下來就是設定 Lighttpd.conf 部份，這部份比較複雜一點，那可以參考官網所提供的說明：

[lighttpd wiki][2]，那其實我要做到的就是在web上面擋圖片盜連的功能，所以需要用到 [mod_rewrite][3] 的功能，在 apache 作法相當簡單，可以在本站搜尋一下就一堆了，那網路上也很多，那我底下就是在 lighttpd 上面的寫法： 1.首先解決 apache virtual host 的問題：設定如下： 

<pre class="brush: bash; title: ; notranslate" title="">#
# 其實看起來不難，設定 log檔案
#
$HTTP["host"] == "www.ee.ccu.edu.tw" {
  server.document-root = "/usr/local/www/apache22/data/www.ee.ccu.edu.tw/"
  server.errorlog = "/var/log/lighttpd/www.ee.ccu.edu.tw-error_log"
  accesslog.filename = "/var/log/lighttpd/www.ee.ccu.edu.tw-access_log"
  server.error-handler-404 = "/index.php"
}</pre> log檔案，最好是自己建立一個 lighttpd 的目錄，不然根本沒有權限啟動 lighttpd 2.解決 wordpress 的 Permalinks 的問題： 

<pre class="brush: bash; title: ; notranslate" title="">$HTTP["host"] == "blog.wu-boy.com" {
  server.document-root = "/usr/local/www/apache22/data/Blog/"
  url.rewrite = (
      "^/?$" => "/index.php",
      "^/(\?.*)$" => "/index.php$1",
      "^/(wp-.+)$" => "$0",
      "^/([^.]+)/?$" => "/index.php?$1",
  )
  server.errorlog = "/var/log/lighttpd/blog.wu-boy.com-error_log"
  accesslog.filename = "/var/log/lighttpd/blog.wu-boy.com-access_log"
}</pre> 這設定相當簡單，大家可以參考看看 3.解決圖片防止盜連的問題： 

<pre class="brush: bash; title: ; notranslate" title="">$HTTP["referer"] !~ "^($|http://(.*\.wu-boy\.com|mini101\.twgg\.org))" {
    url.access-deny = ( ".JPG", ".JPEG", ".PNG" , ".GIF" , ".jpg" , ".jpeg" , ".png" , ".gif")
  }</pre> 這就是要比對 referer 的網址了，其實這樣就可以達到我想要的結果了，可是 lighttpd 好像沒有像是 apache 可以吐出盜連的圖片，也就是把 403 導向一張圖片，lighttpd 好像只可以導向哪一個網頁，這部份還要查查看。 

[Installing Lighttpd With PHP5 And MySQL Support On CentOS 5.0][4] [Lighttpd-輕量級 Web Server][5] [gslin 大大：在 lighttpd 上擋圖片盜連][6] [Lighttpd 防止圖片盜連][7] [lighttpd rewrite rules for WordPress permalink][8]

 [1]: http://www.lighttpd.net/
 [2]: http://trac.lighttpd.net/trac/wiki/Docs
 [3]: http://trac.lighttpd.net/trac/wiki/Docs%3AModRewrite
 [4]: http://www.howtoforge.com/lighttpd_php5_mysql_centos5.0
 [5]: http://www.weithenn.idv.tw/cgi-bin/wiki.pl/Lighttpd-%E8%BC%95%E9%87%8F%E7%B4%9A_Web_Server
 [6]: http://blog.gslin.org/archives/2006/09/28/753/
 [7]: http://lightyror.wordpress.com/2006/09/27/lighttpd-%E9%98%B2%E6%AD%A2%E5%9C%96%E7%89%87%E7%9B%9C%E9%80%A3/
 [8]: http://tzangms.com/blog/lighttpd/1055