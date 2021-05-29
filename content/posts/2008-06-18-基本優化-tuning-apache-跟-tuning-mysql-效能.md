---
title: 基本優化 tuning apache 跟 tuning mysql 跟 php 效能
author: appleboy
type: post
date: 2008-06-18T13:42:57+00:00
url: /2008/06/基本優化-tuning-apache-跟-tuning-mysql-效能/
views:
  - 10674
bot_views:
  - 1011
dsq_thread_id:
  - 246766640
categories:
  - apache
  - FreeBSD
  - Linux
  - MySQL
  - php
tags:
  - apache
  - MySQL
  - php

---
最近在玩優化 Apache 跟 MySQL 部份，然後就在 google 上面找一些資料，當然對我自己的網站當然改變不少，速度有增快許多，所以來紀錄一下，其實都是還蠻基本的改 config 檔案就可以了 1. apache 部份 for FreeBSD 

<pre class="brush: bash; title: ; notranslate" title="">#
# 利用 ports 安裝
# 在安裝 Apache 時，加入此參數 WITH_MPM=XXXX 即可。 
#
cd /usr/ports/www/apache22 ; make WITH_MPM=worker install clean</pre> 如果是要裝在 Linux 機器的話，可能要自己編譯，在 Apache 2.0 有很多效能上得改變，所以原本預設是 prefork 

<pre class="brush: bash; title: ; notranslate" title="">#
# 編譯加上 
# 
./configure --with-mpm=worker</pre> 在 Ubuntu 底下作法很奇怪，利用 apt-get 方式不能安裝 mpm worker，因為你安裝 php 的時候他會幫你移除，然後裝上 prefork，所以很奇怪，這部份我還不知道怎麼解決。 

<!--more--> 接下來設定 httpd-mpm.conf，目前我使用的設備 1g ram CPU x 2 

<pre class="brush: bash; title: ; notranslate" title="">#
# 修改 httpd-mpm.conf
#
vi /usr/local/etc/apache22/extra/httpd-mpm.conf
# worker MPM
# StartServers: initial number of server processes to start
# MaxClients: maximum number of simultaneous client connections
# MinSpareThreads: minimum number of worker threads which are kept spare
# MaxSpareThreads: maximum number of worker threads which are kept spare
# ThreadsPerChild: constant number of worker threads in each server process
# MaxRequestsPerChild: maximum number of requests a server process serves
<IfModule mpm_worker_module>
# Apache 啟動時先開啟 5 個 Threads
    StartServers          5
# 最大的連線數
    MaxClients         1024
    ServerLimit          50
    MinSpareThreads      50
    MaxSpareThreads     200
    ThreadsPerChild      64
    MaxRequestsPerChild 200
    ThreadLimit          64
</IfModule>
</pre> 上面有很多參數，我不是很瞭解，所以還要去參考一下官方網站 

  * <a href="http://httpd.apache.org/docs/2.2/mod/mpm_common.html#startservers" target="_blank">StartServers</a>
  * <a href="http://httpd.apache.org/docs/2.2/mod/mpm_common.html#maxclients" target="_blank">MaxClients</a>
  * <a href="http://httpd.apache.org/docs/2.2/mod/mpm_common.html#serverlimit" target="_blank">ServerLimit</a>
  * <a href="http://httpd.apache.org/docs/2.2/mod/mpm_common.html#minsparethreads" target="_blank">MinSpareThreads</a>
  * <a href="http://httpd.apache.org/docs/2.2/mod/mpm_common.html#maxsparethreads" target="_blank">MaxSpareThreads</a>
  * <a href="http://httpd.apache.org/docs/2.2/mod/mpm_common.html#threadlimit" target="_blank">ThreadLimit</a>
  * <a href="http://httpd.apache.org/docs/2.2/mod/mpm_common.html#threadsperchild" target="_blank">ThreadsPerChild</a>
  * <a href="http://httpd.apache.org/docs/2.2/mod/mpm_common.html#maxrequestsperchild" target="_blank">MaxRequestsPerChild</a> 然後修改 httpd-default.conf 來減少不必要的負擔 

<pre class="brush: bash; title: ; notranslate" title="">#
# vi /usr/local/etc/apache22/extra/httpd-default.conf
#
# 連線超過 60 秒失敗就重試
Timeout 60
# 開啟 KeepAlive
KeepAlive On
# 設定同一時間可容許的 KeppAlive 量
MaxKeepAliveRequests 5000
# KeepAlive 多久要自動 Timeout 掉
KeepAliveTimeout 3
# 關掉那費時的 DNS 查尋
HostnameLookups Off</pre> 上面設定好的話，請重新啟動 apache 

<pre class="brush: bash; title: ; notranslate" title="">#
# 指令
#
/usr/local/etc/rc.d/apache22 restart</pre> 然後可以加上 php 模組：

[[FreeBSD] 安裝 PHP APC 加速網頁速度][1] 或者是加裝 Zend Optimizer ([www.zend.com][2]) 

<pre class="brush: bash; title: ; notranslate" title="">#
# 安裝
#
cd /usr/ports/devel/ZendOptimizer; make install clean
#
# 修改vi /usr/local/etc/php.ini 加入
#
[Zend]
zend_optimizer.optimization_level=15
zend_extension_manager.optimizer="/usr/local/lib/php/20060613-zts-debug/Optimizer"
zend_extension_manager.optimizer_ts="/usr/local/lib/php/20060613-zts-debug/Optimizer_TS"
zend_extension="/usr/local/lib/php/20060613-zts-debug/ZendExtensionManager.so"
zend_extension_ts="/usr/local/lib/php/20060613-zts-debug/ZendExtensionManager_TS.so"</pre> 在 MySQL 優化方面，其實在系統就有設定檔幫我們弄好了 FreeBSD 是放在 /usr/local/share/mysql 底下 

> \* my-huge.cnf: 適合 1GB &#8211; 2GB RAM的主機使用。 \* my-large.cnf: 適合 512MB RAM的主機使用。 \* my-medium.cnf: 只有 32MB &#8211; 64MB RAM 的主機使用，或者有 128MB RAM 但需要運行其他伺服器，例如 web server。 \* my-small.cnf: 記憶體少於 64MB 時適用這個，MySQL 會佔用較少資源。 選定好我們要的檔案之後，就把他移動到 mysql 設定的目錄底下 

<pre class="brush: bash; title: ; notranslate" title="">#
# 複製檔案
#
cp  /usr/local/share/mysql/my-huge.cnf /var/db/mysql/my.cnf</pre> 修改 my.cnf 檔案 

<pre class="brush: bash; title: ; notranslate" title="">#
# my.cnf 底下的 max_connections 跟 max_user_connections 
# 必須大於 apache 的 "MaxClients" 值
#
max_connections = 1024
max_user_connections = 1024
table_cache = 1200
#
# 因為 mysql 預設就是1個user就是用1個 connection
# MySQL defaults to 1 max connection, with 1 max connection per user</pre> 參考網站： http://ms.ntcb.edu.tw/~steven/article/apache-tuning.htm http://www-css.fnal.gov/dsg/external/freeware/mysqlTuning.html 

[Performance Tuning Apache for mod_perl and Cgi-Proxy][3] [Web Server Optimization Guide][4]

 [1]: http://blog.wu-boy.com/2008/06/05/275/
 [2]: http://www.zend.com
 [3]: http://forums.webmaster.idv.hk/archive/index.php/t-23.html
 [4]: http://blog.saycoo.com/archives/14