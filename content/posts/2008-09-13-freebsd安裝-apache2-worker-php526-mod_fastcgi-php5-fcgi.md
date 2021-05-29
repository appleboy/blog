---
title: '[FreeBSD]安裝 apache2 (worker) + PHP5.2.6 + mod_fastcgi + php5-fcgi'
author: appleboy
type: post
date: 2008-09-13T12:24:26+00:00
url: /2008/09/freebsd安裝-apache2-worker-php526-mod_fastcgi-php5-fcgi/
bot_views:
  - 1100
views:
  - 11297
dsq_thread_id:
  - 246754436
categories:
  - apache
  - FreeBSD
  - Lighttpd
  - Linux
  - Network
  - php
  - Ubuntu
  - www
  - 電腦技術
tags:
  - apache
  - fastcgi
  - FreeBSD
  - lighttpd
  - Linux
  - php
  - php-cgi

---
今天把 [FreeBSD][1] web 改成了 [apache][2] [worker][3] 其實之前就已經這麼做了，只是今天加上 mod_fastcgi 我是參考 [DarkKiller 大神 apache22 (worker) + mod_fastcgi + php5-fcgi][4]，之前就把 Server 換成了 php5-fcgi，只不過我是搭配 [Lighttpd][5]，效能方面還不錯，可以參考這篇：[[FreeBSD] Lighttpd + PHP + mod_proxy + FastCGI][6]，那因為用 [lighttpd][5] 的外掛模組真的太少，不像 apache 支援這麼多 module，重點是還缺少了 .htaccess 這個功能，所以大大降低大家使用 [lighttpd][5]，近期內會把全部 server 換成 apache2 搭配 [mod_fastcgi][7]，那底下寫一下作法了： <!--more--> 基本上利用 FreeBSD 的 ports 安裝就可以了： 1. 先安裝 apache with MPM = worker 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/www/apache22
make WITH_MPM=worker install clean 
pkg_info | grep apache
#
# 會出現
#
apache-worker-2.2.9_5 Version 2.2.x of Apache web server with worker MPM.</pre> 2. 安裝 PHP5 跟 PHP5-extensions 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/lang/php5; make install clean
cd /usr/ports/lang/php5-extensions; make install clean</pre> 3. 安裝 mod_fastcgi 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/www/mod_fastcgi
make install clean</pre> 全部安裝完成，先修改 httpd.conf 

<pre class="brush: bash; title: ; notranslate" title="">#
# 把下面這行 umark 掉
#
# Server-pool management (MPM specific)
Include etc/apache22/extra/httpd-mpm.conf</pre> 修改 Include etc/apache22/extra/httpd-mpm.conf mpm\_worker\_module 那段： 

<pre class="brush: bash; title: ; notranslate" title="">ThreadLimit 512
    StartServers 1
    MaxClients 512
    MinSpareThreads 1
    MaxSpareThreads 512
    ThreadsPerChild 512
    MaxRequestsPerChild 0</pre> 這樣 MPM worker 就設定完成了，接下來設定 mod_fastcgi 到 /usr/local/etc/apache22/httpd.conf 把底下這一段的註解拿掉 

<pre class="brush: bash; title: ; notranslate" title="">LoadModule fastcgi_module     libexec/apache22/mod_fastcgi.so</pre> 新增設定檔：/usr/local/etc/apache22/Includes/fastcgi.conf，內容如下： 

<pre class="brush: bash; title: ; notranslate" title="">#
FastCgiConfig -maxClassProcesses 1
ScriptAlias /fcgi-bin/ "/usr/local/www/fcgi-bin/"
<Directory /usr/local/www/fcgi-bin/>
    SetHandler fastcgi-script
    AllowOverride All
    Order allow,deny
    Allow from all
</Directory>
#
AddHandler php-fastcgi .php
Action php-fastcgi /fcgi-bin/php</pre> 這裡設定只能跑一隻 

[fastcgi][8] 配合前面的 MPM worker，這樣確保所有的 apache 只會透過這個 fastcgi socket 跑 php。 然後再建立： /usr/local/www/fcgi-bin 這個資料夾，裡面擺入執行檔 php 內容是： 

<pre class="brush: bash; title: ; notranslate" title="">#!/bin/sh
PHPRC="/usr/local/etc"
export PHPRC
PHP_FCGI_CHILDREN=128
export PHP_FCGI_CHILDREN
exec /usr/local/bin/php-cgi</pre> 之後在安裝 

[APC][9] ([www/pecl-APC][10]) 這樣就可以了，底下引述 gslin 的講解： 

> 這個架構下，httpd 會產生 512 threads 處理連線，並產生一個 fastcgi 的 socket 處理 PHP 程式，這個 socket 會由 128 隻 php-cgi 聽，且這 128 隻的 cache 會共用。 參考網站：[gslin 大神][11] ：[apache22 (worker) + mod_fastcgi + php5-fcgi][4]

 [1]: http://www.freebsd.org
 [2]: http://www.apache.org/
 [3]: http://httpd.apache.org/docs/2.0/mod/worker.html
 [4]: http://blog.gslin.org/archives/2008/08/17/1624/
 [5]: http://www.lighttpd.net/
 [6]: http://blog.wu-boy.com/2008/07/10/291/
 [7]: http://www.fastcgi.com/
 [8]: http://www.fastcgi.com
 [9]: http://pecl.php.net/package/APC
 [10]: http://www.freshports.org/www/pecl-APC/
 [11]: http://blog.gslin.org/