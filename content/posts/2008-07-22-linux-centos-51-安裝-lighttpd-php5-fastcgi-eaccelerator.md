---
title: '[Linux] CentOS 5.1 安裝 Lighttpd + PHP5 + FastCgi + eaccelerator'
author: appleboy
type: post
date: 2008-07-22T07:56:09+00:00
url: /2008/07/linux-centos-51-安裝-lighttpd-php5-fastcgi-eaccelerator/
views:
  - 9209
bot_views:
  - 1140
dsq_thread_id:
  - 246767198
categories:
  - Lighttpd
  - Linux
  - www
tags:
  - apache
  - eaccelerator
  - lighttpd
  - Linux
  - php

---
昨天網站無緣無故被擋掉，原因是我的流量網站太大，囧，因為是架設 web site，測試一下效能，我發現 [=http://httpd.apache.org][1]apache[/url] 沒辦法撐住流量跟線上人數，所以只好換成 [=http://www.lighttpd.net][2]Lighttpd[/url] 發現效果不錯，所以又去安裝了 CentOS 版本，我是去參考底下這篇：[Installing Lighttpd With PHP5 And MySQL Support On CentOS 5.0][3]，這一篇我覺得寫的還ok，但是因為 Centos 如果你想用 yum 安裝 [=http://www.lighttpd.net][2]Lighttpd[/url] 就要先裝 rpmforge-release package 這個東西，這樣才可以找到。 首先先看你的版本再來抓： 

> RHEL5 / CentOS-5 i386: http://packages.sw.be/rpmforge-release/rpmforge-release-0.3.6-1.el5.rf.i386.rpm x86\_64: http://packages.sw.be/rpmforge-release/rpmforge-release-0.3.6-1.el5.rf.x86\_64.rpm RHEL4 / CentOS-4 i386: http://packages.sw.be/rpmforge-release/rpmforge-release-0.3.6-1.el4.rf.i386.rpm x86\_64: http://packages.sw.be/rpmforge-release/rpmforge-release-0.3.6-1.el4.rf.x86\_64.rpm RHEL3 / CentOS-3 i386: http://packages.sw.be/rpmforge-release/rpmforge-release-0.3.6-1.el3.rf.i386.rpm x86\_64: http://packages.sw.be/rpmforge-release/rpmforge-release-0.3.6-1.el3.rf.x86\_64.rpm RHEL2.1 / CentOS-2 i386: http://packages.sw.be/rpmforge-release/rpmforge-release-0.3.6-1.el2.rf.i386.rpm <!--more--> 就是找你的版本，然後下載安裝： 

<pre class="brush: bash; title: ; notranslate" title="">#
# 安裝
#
wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.3.6-1.el5.rf.i386.rpm 
rpm -ivh rpmforge-release-0.3.6-1.el5.rf.i386.rpm </pre> 安裝 lighttpd 

<pre class="brush: bash; title: ; notranslate" title="">#
# yum 安裝
#
yum install lighttpd
yum install lighttpd-fastcgi php-cli</pre> 然後編輯：/etc/php.ini 加上 

<pre class="brush: bash; title: ; notranslate" title="">cgi.fix_pathinfo = 1</pre> 然後修改 lighttpd.conf 

<pre class="brush: bash; title: ; notranslate" title="">#
# 修改
#
vi /etc/lighttpd/lighttpd.conf</pre>

<pre class="brush: bash; title: ; notranslate" title="">server.modules              = (
                                "mod_rewrite",
                                "mod_redirect",
                                "mod_alias",
                                "mod_access",
                                "mod_fastcgi",
                                "mod_proxy",
                                "mod_evhost",
                                "mod_userdir",
                                "mod_accesslog" )

server.document-root        = "/var/www/html/"

server.errorlog             = "/var/log/lighttpd/error.log"

index-file.names            = ( "index.php", "index.html",
                                "index.htm", "default.htm" )
fastcgi.server             = ( ".php" =>
                               ( "localhost" =>
                                 (
                                   "socket" => "/tmp/php-fastcgi.socket",
                                   "bin-path" => "/usr/bin/php-cgi"
                                 )
                               )
                            )
$HTTP["host"] == "mini101.twgg.org" {
  server.document-root = "/var/www/html/Mini/"
  #url.rewrite = ( "^/(archives|categories|comments|feed)/" => "/index.php" )
  url.rewrite = (
      "^/?$" => "/index.php",
      "^/(\?.*)$" => "/index.php$1",
      "^/(wp-.+)$" => "$0",
      "^/([^.]+)/?$" => "/index.php?$1",
  )
  accesslog.filename = "/var/log/lighttpd/mini101.twgg.org-access_log"
}</pre> 安裝：eaccelerator 

<pre class="brush: bash; title: ; notranslate" title="">#
# yum 安裝
#
yum install eaccelerator</pre> 設定 eaccelerator.ini 

<pre class="brush: bash; title: ; notranslate" title="">#
# 編輯
#
vi /etc/php.d/eaccelerator.ini
#
; Enable eAccelerator extension module
zend_extension = /usr/lib/php/modules/eaccelerator.so
; Options for the eAccelerator module
eaccelerator.cache_dir = /var/cache/php-eaccelerator
eaccelerator.shm_size = 128
eaccelerator.enable = 1
eaccelerator.optimizer = 1
eaccelerator.check_mtime = 1
eaccelerator.filter = ""
eaccelerator.shm_max = 0
eaccelerator.shm_ttl = 3600
eaccelerator.shm_prune_period = 0
eaccelerator.shm_only = 0
eaccelerator.compress = 1
eaccelerator.compress_level = 9
eaccelerator.keys = "shm_and_disk"
eaccelerator.sessions = "shm_and_disk"
eaccelerator.content = "shm_and_disk"
eaccelerator.debug = 0</pre> 這樣大概ok了，然後測試看看： # php -v 

> PHP 5.1.6 (cli) (built: Sep 20 2007 10:16:10) Copyright (c) 1997-2006 The PHP Group Zend Engine v2.1.0, Copyright (c) 1998-2006 Zend Technologies with eAccelerator v0.9.5.2, Copyright (c) 2004-2006 eAccelerator, by eAccelerator

 [1]: http://httpd.apache.org
 [2]: http://www.lighttpd.net
 [3]: http://www.howtoforge.com/lighttpd_php5_mysql_centos5.0