---
title: '[FreeBSD]Apache 噴出 signal Segmentation fault (11)'
author: appleboy
type: post
date: 2008-07-01T06:39:04+00:00
url: /2008/07/freebsdapache-噴出-signal-segmentation-fault-11/
views:
  - 7308
bot_views:
  - 937
dsq_thread_id:
  - 246785059
categories:
  - apache
  - FreeBSD
  - Linux
  - php
  - www
tags:
  - apache
  - FreeBSD
  - Linux
  - php

---
最近在玩 FreeBSD 伺服器的加強效能，其實我自己試了很多套：[eAccelerator][1]，[Pear APC][2]，跟 [Zend Optimizer][3]，這三套都是可以加速php的速度，當你的 apache 效能遇到瓶頸，就可以選用這三個來改善網頁瀏覽速度，不過應該沒有人三個都用吧，畢竟三個東西，感覺都是cache幫助，所以達成我們所想要的要求，有時候並不是全部安裝就是代表你的伺服器一定會超快，因為我的經驗是三個不能同時裝，只要裝了兩個都會出問題，這是我這幾天測試的結果，只要裝了Pear APC，就不能裝Zend Optimizer跟eAccelerator了，因為我的 httpd 的 log 會噴出底下訊息： 

> signal Segmentation fault (11) 跟 pid 15879 (httpd), uid 80: exited on signal 11<!--more--> 這三種的安裝方式都非常簡單，先找ports在哪，然後 make install clean 就可以了 

<pre class="brush: bash; title: ; notranslate" title="">#
#Zend Optimizer：
#
cd /usr/ports/devel/ZendOptimizer; make install clean
#
#eaccelerator：
#
cd /usr/ports/www/eaccelerator;make install clean
#加入 php.ini
zend_extension="/usr/local/lib/php/20060613-zts/eaccelerator.so"
eaccelerator.shm_size="500"
eaccelerator.cache_dir="/tmp/eaccelerator"
eaccelerator.enable="0"
eaccelerator.optimizer="1"
eaccelerator.log_file = "/var/log/eaccelerator_log"
eaccelerator.check_mtime="1"
eaccelerator.debug="0"
eaccelerator.filter=""
eaccelerator.shm_max="0"
eaccelerator.shm_ttl="0"
eaccelerator.shm_prune_period="0"
eaccelerator.shm_only="0"
eaccelerator.compress="1"
eaccelerator.compress_level="9"
eaccelerator.keys = "shm_and_disk"
eaccelerator.sessions = "shm_and_disk"
eaccelerator.content = "shm_and_disk"</pre> APC 安裝請參考 

[[FreeBSD] 安裝 PHP APC 加速網頁速度][4] PHP 加速器的調校(php-eaccelerator) 這一套，我就覺得相當好用，可是她會陸續噴出 signal Segmentation fault (11) 跟 uid 80: exited on signal，所以我自己又把它移除了，我參考網路上一篇 [PHP &#8211; PHP 加速器的調校(php-eaccelerator)][5]，裡面寫到： 

> 由於 PHP 屬於直譯語言，因此當放在 Web 伺器器上的 PHP 程式碼被瀏覽者所讀取時，系統為了要執行 PHP 程式碼就必須要使用直譯器(interpreter)，將 PHP 程式碼翻譯成電腦系統看得懂(或可以執行)的語言。這個直譯的動作是非常耗費系統資源的，而直譯語言的特性偏偏就是每次執行前都要先進行直譯的動作，因此當您放在 Web 伺服器上的 PHP 程式碼被 1000 個 client 讀取時，系統就要進行 1000 次的直譯動作。而 PHP 加速器的功能就是會把被這些 PHP 程式碼快取(Cache)起來，也就是同一支程式碼只要被直譯一次而已，藉此大幅降低系統的負載。自己個人的經驗是：若你的 Web 伺服器流量非常大，有沒有使用 PHP 加速器會有非常大的差別。 php-eaccelerator 的安裝很容易，但麻煩的是後續的調整。一般來講，若你會需要安裝加速器通常就代表你遇上了效能的瓶頸，也就是系統負載過大所以才需要安裝它；但是 php-eaccelerator 有 BUG，當系統負載過大，php-eaccelerator 需要消除 Share Memory 中的老舊資料時，會導致 apache 出現如下的錯誤訊息並使 CPU 使用率衝上 100%，最後終將致使伺服器當機。 如果沒有調整好，就會造成這個問題，可是我按照他們的系統參數調整，還是一樣會噴出這情形，我的系統： 

<pre class="brush: bash; title: ; notranslate" title="">apache-worker-2.2.9
php5-5.2.6</pre> 都算是最新版本了，他們系統參數如下： 

<pre class="brush: bash; title: ; notranslate" title="">eaccelerator.shm_size = "500"
#預設是32MB，這裡設為500MB

eaccelerator.cache_dir = "/var/cache/php-eaccelerator"
eaccelerator.enable = "1"
eaccelerator.optimizer = "0"
#預設是 1 (開啟)，這裡設為 0 (關閉)

eaccelerator.debug = "0"
eaccelerator.log_file = "/var/log/httpd/eaccelerator_log"
eaccelerator.name_space = ""
eaccelerator.check_mtime = "1"
eaccelerator.filter = ""
eaccelerator.shm_max = "0"
eaccelerator.shm_ttl = "0"
#預設是3600，這裡設為0，也就是不移除Share Memory中的任何資料。

eaccelerator.shm_prune_period = "0"
eaccelerator.shm_only = "0"
eaccelerator.compress = "1"
eaccelerator.compress_level = "9"
eaccelerator.keys = "shm_and_disk"
eaccelerator.sessions = "shm_and_disk"
eaccelerator.content = "shm_and_disk"</pre> 其實改成上面那樣也沒用，所以我又把它移除了，在裝一次 Pear APC 試試看，不過這次有加開三個選項： 

<pre class="brush: bash; title: ; notranslate" title="">Enable mmap memory support (default: IPC shm) 
Enable sysv IPC semaphores (default: fcntl())
Enable per request cache info</pre> 我把這三個選項勾起來，然後在重新編譯，在重新啟動 apache，竟然可以 work 了，完全沒有任何錯誤訊息了 參考網站： 

[Alternative PHP Cache (APC)][6]

 [1]: http://eaccelerator.net/
 [2]: http://pecl.php.net/package/APC
 [3]: http://www.zend.com/en/products/guard/optimizer/
 [4]: http://blog.wu-boy.com/2008/06/05/275/
 [5]: http://forum.slime.com.tw/thread210119.html
 [6]: http://ez.no/tw/developer/articles/the_ez_publish_web_server_environment/alternative_php_cache_apc