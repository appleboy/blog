---
title: FreeBSD + Lighttpd + php + mysql 安裝過程
author: appleboy
type: post
date: 2006-09-20T01:57:13+00:00
excerpt: |
  |
    http://gslin.org/2004/10/12/61/
url: /2006/09/freebsd-lighttpd-php-mysql-安裝過程/
views:
  - 6248
bot_views:
  - 865
dsq_thread_id:
  - 246720139
categories:
  - FreeBSD
  - Lighttpd
tags:
  - FreeBSD
  - lighttpd
  - MySQL
  - php

---
系統環境 ：FreeBSD 6.0-RELEASE 安裝過程如下： 

  1. mysql-server-5.0.24a
  2. php5-5.1.6
  3. lighttpd-1.4.11_1 先安裝 

[lighttpd][1] 

> cd /usr/ports/www/lighttpd/ make config [X] OPENSSL Enable SSL support [ ] OPENLDAP Enable LDAP support [X] MYSQL Enable MYSQL support [X] IPV6 Enable IPV6 support [X] CML Enable Cache Meta Language support make install clean  安裝 [mysql][2] cd /usr/ports/databases/mysql50-server make install clean WITH\_CHARSET=utf8 WITH\_LINUXTHREADS=yes 安裝 [php][3] cd /usr/ports/lang/php5 <a target="_blank" href="http://photobucket.com/"><img src="https://i0.wp.com/i108.photobucket.com/albums/n5/appleboy46/blog/1.gif?w=840" data-recalc-dims="1" /> </a> cd /usr/ports/lang/php5-extensions/ make config 選擇你想要的 extensions 灌好之後 就可以用了 然後打開 **家目錄設定** userdir.path = &#8220;public_html&#8221; userdir.basepath = &#8220;/home/&#8221; 重點來了 如果執行網頁 http://localhost/phpinfo.php 出現 550 error 則你忘記執行fastcgi php-cgi -v PHP 5.1.6 (**cgi-fcgi**) (built: Sep 19 2006 22:42:28) (DEBUG) Copyright (c) 1997-2006 The PHP Group Zend Engine v2.1.0, Copyright (c) 1998-2006 Zend Technologies 然後執行 php-cgi -b 127.0.0.1:81 & 即可 port部份 隨機bind一個即可 [lighttpd 設定檔][4]{#p83}

 [1]: http://www.lighttpd.net/ "lighttpd"
 [2]: http://www.mysql.com/ "mysql"
 [3]: http://www.php.net "php"
 [4]: http://blog.wu-boy.com/wp-content/uploads/2007/03/lighttpd.txt