---
title: '[FreeBSD] 安裝 PHP APC 加速網頁速度'
author: appleboy
type: post
date: 2008-06-05T01:00:23+00:00
url: /2008/06/freebsd-安裝-php-apc-加速網頁速度/
views:
  - 10150
bot_views:
  - 999
dsq_thread_id:
  - 247019355
categories:
  - FreeBSD
  - Linux
  - php
  - www
tags:
  - apache
  - APC
  - FreeBSD
  - Linux
  - php

---
最近在維護自己的機器，發現網站每秒 request 只要10幾次就會感覺吃很多資源，然後莫名 CPU 飆高到100%，後來只好去找怎麼去 tuning Apache，MySQL，PHP，至於改善 apache 跟 MySQL 我先不講了，我之後會在寫，我先處理了加速 PHP 的部份，我是安裝了 [APC][1]（Alternative PHP Cache），來改善執行 PHP 的速度，這個程式必須先安裝好 [PECL][2](PHP Extension Community Library)，再來安裝 APC 就沒問題了。 1. 首先安裝 APC 

<pre class="brush: bash; title: ; notranslate" title="">#
# 先切換到該軟體下面
#
cd /usr/ports/www/pecl-APC/; make install clean
</pre>

<!--more--> 2. 安裝好之後會出現底下訊息 

<pre class="brush: bash; title: ; notranslate" title="">You may edit /usr/local/etc/php.ini to change this variables:

apc.enabled="1"
            ^^^ -> Default value

apc.shm_size="30"
             ^^^^ -> Default value

* More information on /usr/local/share/doc/APC/INSTALL

Then restart your web server and consult the output of phpinfo().
If there is an informational section for APC, the installation was
successful.</pre> 3. 打開 /usr/local/etc/php/extensions.ini 

<pre class="brush: bash; title: ; notranslate" title="">#
# vi /usr/local/etc/php/extensions.ini
# 加入：
extension=apc.so</pre> 4. 打開 /usr/local/etc/php.ini 

<pre class="brush: bash; title: ; notranslate" title="">#
# vi /usr/local/etc/php.ini
# 最後加入：
#
# 啟動 apc
apc.enabled=1
apc.shm_segments=1
# 要讓 apc 使用多少記憶體
apc.shm_size=128
# ttl 設定成 300 second，這樣快取命中率比較高，增加自己網站速度，看自己網站調整喔
apc.ttl=300
apc.user_ttl=300
apc.num_files_hint=1024
# 這行請勿修改，後面的 XXXXX 系統會自己建立喔
apc.mmap_file_mask=/tmp/apc.XXXXXX
apc.enable_cli=1</pre> 5. 使用 apc.php 觀看系統資源 

<span style="color:green">cp /usr/local/share/doc/APC/apc.php /usr/local/www/apache22/data</span> 

<pre class="brush: php; title: ; notranslate" title="">#
# 新增 apc.conf.php
# 裡面加入
defaults('ADMIN_USERNAME','appleboy');
defaults('ADMIN_PASSWORD','xxxxx');</pre> 大致上是這樣，底下是安裝好的畫面，跟觀看 phpinfo 的畫面： 

[<img src="https://i1.wp.com/farm4.static.flickr.com/3079/2550799843_3512497334.jpg?resize=500%2C176&#038;ssl=1" title="APC_02 (by appleboy46)" alt="APC_02 (by appleboy46)" data-recalc-dims="1" />][3] 底下是 apc.php 畫面 [<img src="https://i0.wp.com/farm4.static.flickr.com/3112/2550799769_0d526e8240.jpg?resize=500%2C246&#038;ssl=1" title="APC_01 (by appleboy46)" alt="APC_01 (by appleboy46)" data-recalc-dims="1" />][4] 參考網站： [[FreeBSD] 加速你的 PHP &#8211; APC][5] [Debian PHP APC 安裝][6] http://pecl.php.net/package/APC

 [1]: http://pecl.php.net/package/APC
 [2]: http://pecl.php.net/
 [3]: https://www.flickr.com/photos/appleboy/2550799843/ "APC_02 (by appleboy46)"
 [4]: https://www.flickr.com/photos/appleboy/2550799769/ "APC_01 (by appleboy46)"
 [5]: http://twntwn.info/blog/ajer001/archives/1719
 [6]: http://plog.longwin.com.tw/my_note-unix/2007/04/05/debian_php_apc_setup_2007