---
title: 安裝 XCache 加速 PHP 執行速度
author: appleboy
type: post
date: 2011-09-20T09:56:33+00:00
url: /2011/09/how-to-install-xcache-on-freebsd/
dsq_thread_id:
  - 420090285
categories:
  - FreeBSD
  - Lighttpd
  - php
  - www
tags:
  - APC
  - eaccelerator
  - FreeBSD
  - lighttpd
  - Xcache

---
  <a href="https://www.flickr.com/photos/appleboy/6034284842/" title="php-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm7.static.flickr.com/6186/6034284842_351ff33711_m.jpg?resize=240%2C127&#038;ssl=1" alt="php-logo" data-recalc-dims="1" /></a>

## 前言 

最近 <a href="http://www.freebsd.org" target="_blank">FreeBSD</a> 系統常常會當機，加上 <a href="https://www.varnish-cache.org/" target="_blank">Varnish cache</a> + <a href="http://pecl.php.net/package/APC" target="_blank">APC</a> 一直給我出包，所以這次就換了一套加速 PHP 執行的套件 <a href="http://xcache.lighttpd.net/" target="_blank">XCache</a>，這是一套由華人所開發的加速器，可以參考篇<a href="http://twpug.net/" target="_blank">台灣PHP聯盟論壇</a>所發表 <a href="http://twpug.net/modules/newbb/viewtopic.php?topic_id=1571&forum=14&post_id=8054" target="_blank">PHP 加速器 - xcache</a>，裡面可以看到<a href="http://forum.lighttpd.net/topic/880" target="_blank">這篇</a>裡面就有中文的對話，非常好玩，這次也順便把 PHP 升級到 5.3.8 版本，還有 Varnish 一次升級到 3.0.1 版本。 

## 各家 PHP 加速器 

大家都知道目前網路上知名的 PHP 加速器 <a href="http://pecl.php.net/apc" target="_blank">apc</a>, <a href="http://eaccelerator.sf.net/" target="_blank">eaccelerator</a>, <a href="http://www.php-accelerator.co.uk/" target="_blank">phpa</a>, <a href="http://turck-mmcache.sourceforge.net/index_old.html" target="_blank">truck-mmcache</a>，這幾套網路上資料很多，大家都可以試著玩看看，尤其是前面兩套 APC 及 eaccelerator，phpa 目前已經不再維護了，truck-mmcache 版本好像也沒啥在更新，距離上次更新是 2009-07-17，Xcache 作者研究 truck-mmcache 跟 APC 已經很長的時間，他發現 APC 的程式碼比起 truck-mmcache 還要簡單更容易瞭解，所以大家也可以研究 APC 相關程式碼。 <!--more-->

## Xcache 的由來 

大家一定很想知道作者為什麼想要開發一套新的 PHP 加速器 Xcache 呢？早期作者還沒開啟此專案以前，都是在使用 APC 跟 eaccelerator，如果碰到任何 bug，作者都會第一時間告訴官方，作者也跟 eaccelerator 其中一位開發者 <a href="http://blog.zoeloelip.be/" target="_blank">zoeloelip</a> 有互動，zoeloelip 是第一位看到 XCache 程式碼，也因為他看過了 Xcache，所以他參考 Xcache 作者 Disassembler idea 來改寫 ea_dasm.c 大部分程式碼。這部份作者也是猜測的，最後作者有提到他為什麼寫了這專案，其實很簡單。 

  * 作者有太多 idea 無法實做在 ea/apc
  * ea/apc 架構過於龐大，所以無法實際用在裡面
  * 作者用來練功 最後作者也認同 ea/apc 是不錯的加速器，大家可以實際用看看，感受一下加速過後的 PHP。也可以參考 

<a href="http://xcache.lighttpd.net/wiki/FeatureList" target="_blank">FeatureList</a> 看看 Xcache 有哪些功能。 

## 安裝 Xcache 

這邊環境是 FreeBSD 7.1 Release ports 安裝方式: 

```bash
$ cd /usr/ports/www/xcache/; make install clean
```
 安裝完成之後要進行設定，設定檔放在 

**<span style="color:green">/usr/local/share/examples/xcache/</span>**，裡面也包含了 admin 管理介面。 

```bash
$ cp /usr/local/share/examples/xcache/xcache.ini /usr/local/etc/php/ 
```
 接著附上我機器的設定檔 

```bash
[xcache-common]
extension = xcache.so

[xcache.admin]
xcache.admin.enable_auth = On
xcache.admin.user = "admin"
xcache.admin.pass = "xxxxxxx"

[xcache]
xcache.shm_scheme =        "mmap"
xcache.size  =               16M
xcache.count =                 1
xcache.slots =                8K
xcache.ttl   =                 0
xcache.gc_interval =           0
xcache.var_size  =            2M
xcache.var_count =             1
xcache.var_slots =            8K
xcache.var_ttl   =             0
xcache.var_maxttl   =          0
xcache.var_gc_interval =     300
xcache.test =                Off
xcache.readonly_protection = On
xcache.mmap_path =    "/tmp/xcache"
xcache.coredump_directory =   ""
xcache.cacher =               On
xcache.stat   =               On
xcache.optimizer =           Off

[xcache.coverager]
xcache.coverager =          Off
xcache.coveragedump_directory = ""
```
 這邊有要注意的地方就是在 Unix 系統設定 xcache.mmap_path 的時候，這是

**<span style="color:red">檔案</span>**而並非是目錄，這邊設定好之後，請先建立 /tmp/xcache 檔案 

```bash
$ touch /tmp/cache && chmod 777 /tmp/cache
```
 安裝完成之後請重新啟動 apache 或 lighttpd: 

```bash
$ /usr/local/etc/rc.d/apache22 restart
$ /usr/local/etc/rc.d/lighttpd restart

```
 最後直接可以看到 phpinfo 的相關訊息: 補個圖 

[<img src="https://i0.wp.com/farm7.static.flickr.com/6177/6165852252_d82447fd65.jpg?resize=464%2C500&#038;ssl=1" alt="phpinfo" data-recalc-dims="1" />][1] 或者是打看看 php -v 也可以看到訊息: 

```bash
PHP 5.3.8 (cli) (built: Sep 20 2011 14:37:25)
Copyright (c) 1997-2011 The PHP Group
Zend Engine v2.3.0, Copyright (c) 1998-2011 Zend Technologies
    with XCache v1.3.2, Copyright (c) 2005-2011, by mOo
```


## 安裝 Xcache 管理介面 

設定管理者帳號密碼 (**<span style="color:green">/usr/local/etc/php/xcache.ini</span>** 裡面) 請注意 

```bash
xcache.admin.enable_auth = On
xcache.admin.user = "admin"
xcache.admin.pass = "xxxxxxxxxxxx"
```
 密碼該如何產生呢？可以透過 php 指令去產生您要的 md5 密碼 

```bash
php -r "echo md5('admin');"

```
 或者是透過網頁 

```php
<?php
echo md5("password");
?>
```
 最後將 admin 目錄放到您網站根目錄底下即可 

```bash
$ cp -r /usr/local/share/examples/xcache/admin /usr/local/www/apache22/data/xcache
```
 網址列打入 http://xxxxx/xcache 並且輸入上面所設定好的帳號密碼即可 

[<img src="https://i1.wp.com/farm7.static.flickr.com/6161/6165864680_e5bb28d62a.jpg?resize=488%2C500&#038;ssl=1" alt="XCache 1.3.2 管理頁面" data-recalc-dims="1" />][2] 參考網站: <a href="http://xcache.lighttpd.net/wiki/InstallAdministration" target="_blank">http://xcache.lighttpd.net/wiki/InstallAdministration</a>

 [1]: https://www.flickr.com/photos/appleboy/6165852252/ "phpinfo by appleboy46, on Flickr"
 [2]: https://www.flickr.com/photos/appleboy/6165864680/ "XCache 1.3.2 管理頁面 by appleboy46, on Flickr"
