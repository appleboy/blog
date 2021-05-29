---
title: '[FreeBSD] update apache -> 2.2.15, PHP -> 5.3.2, and MySQL downgrade to 5.1.9'
author: appleboy
type: post
date: 2010-06-23T05:46:34+00:00
url: /2010/06/freebsd-update-apache-2-2-15-php-5-3-2-and-mysql-downgrade-to-5-1-9/
views:
  - 4426
bot_views:
  - 322
dsq_thread_id:
  - 246712815
categories:
  - CodeIgniter
  - FreeBSD
  - php
  - wordpress
tags:
  - apache
  - CodeIgniter
  - FreeBSD
  - MySQL
  - php

---
昨天升級了 [FreeBSD][1] 的 Apache, [PHP][2], and [MySQL][3]，遇到很多地雷阿，最多的就是 PHP 的部份，因為本來自己使用 5.2.11 版本，但是在 commit port 的時候發生去裝 5.3.2 版本，所以就直接砍掉全部重練，先是遇到 MySQL 問題，原先在 database/mysql60-server 已經被 FreeBSD 移除，任何關於 mysql60 的相關 port 都被 remove 掉了，只好 downgrade 到 mysql 5.1.48 版本，移除同時順手把 apache PHP 相關都拿掉了。 

### 移除 apache mysql php 相關 ports -rf 依序找尋相關 Mysql ports 移除 

<pre class="brush: bash; title: ; notranslate" title="">pkg_deinstall -rf mysql60-server</pre> 接下來安裝 MySQL 5.1.48 Server and Client，可以找到在 

<span style="color:green">databases/mysql51-server</span> and <span style="color:green">databases/mysql51-client</span>，直接安裝即可 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/databases/mysql51-server && make install</pre> 安裝 Apache 2.2.15 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/www/apache22 && make WITH_MPM=worker install</pre> 安裝 PHP 5.3.2，FreeBSD 把 5.2.X 跟 5.3.X 分開不同資料夾 

<span style="color:green">lang/php5</span>, <span style="color:green">lang/php52</span>，extension 也是分成兩個，所以要安裝 5.2 版本也是可以的 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/lang/php5 && make install
cd /usr/ports/lang/php5-extensions/ && make install</pre> 以上安裝好，就是苦難的開始，首先 MySQL 從原本的 6.0.9 降到 5.1.48，造成所有資料庫無法讀取，也沒辦法正確啟動 MySQL，馬上噴出底下問題： 

> 090205 11:14:24 mysqld\_safe Starting mysqld daemon with databases from /var/db/mysql /usr/local/libexec/mysqld: Unknown collation '#46' in table 'plugin' definition 090205 11:14:24 [ERROR] Can't open the mysql.plugin table. Please run mysql\_upgrade to create it. 090205 11:14:24 InnoDB: Started; log sequence number 0 46429 090205 11:14:24 [ERROR] Fatal error: Can't open and lock privilege tables: <span style="color:red"><strong>Unknown collation '#46' in table 'host'</strong></span> definition 為啥會出現紅色那段字，就是因為字元集不同，MySQL 6 有支援 <span style="color:green">utf8mb4</span>，但是 5.1.48 版本沒有，所以才會造成無法啟動，解決方法呢？就是把 <span style="color:green">/var/db/mysql/mysql</span> 砍掉，在重新啟動就可以了，當然您的資料庫也是無法使用，再去其他電腦裝上 MySQL 6.0.9 之後，把 <span style="color:green">/var/db/mysql/</span> 底下的資料庫 Copy 過去一份，利用 mysqldump 把全部資料庫 dump 下來，再 restore 回去原來的系統，大致上就可以了。 對於把 PHP 升級到 5.3 的時候，心裡就在想會遇到很多雷，果然是如此，很多 opensource 都尚未支援到 php 5.3，也因此很多函數都無法支援，<span style="color:red">ereg_</span> 系列都必須換成 <span style="color:red">preg_</span>，<span style="color:green">register_globals</span> 的移除，也不能使用 HTTP\_GET or HTTP\_POST，把 <span style="color:green">register_long_arrays</span> 拿掉，參考: <http://php.net/manual/en/ini.core.php>，[CodeIgniter][4] V 1.7.2 開始支援 PHP 5.3.0 版本，這樣大致上所有專案都可以順利啟動，底下是在 WordPress 遇到的問題： 

> Warning: strtotime() [function.strtotime]: It is not safe to rely on the system's timezone settings. <span style="color:red"><strong>You are *required* to use the date.timezone setting or the date_default_timezone_set() function.</strong></span> In case you used any of those methods and you are still getting this warning, you most likely misspelled the timezone identifier. We selected 'Europe/Helsinki' for 'EEST/3.0/DST' instead in /path/to/my/www/wp-includes/functions.php on line 35 這在 [WordPress][5] 官網也是有[提出此問題][6]，解決方式有兩種，一種是在 wp-config.php 加上 <span style="color:green">date_default_timezone_set('</span>UTC<span style="color:green">');</span> 或者是 <span style="color:green">date_default_timezone_set('</span>Asia/Taipei<span style="color:green">');</span>，另一種是修改 php.ini，修改 

<pre class="brush: php; title: ; notranslate" title="">; Defines the default timezone used by the date functions
date.timezone = Asia/Taipei</pre> 這樣大致上修補完成，其他程式的修改這裡就不補充了，底下是 PHP 網站所支援的 time zone，可以參考看看其他時區 Reference: 

[Php 5.3.0 & WP 2.8 (It is not safe to rely on the system's timezone)][6] [Description of core php.ini directives][7] [現在寫 PHP6-compatible 的一些技巧][8] [List of Supported Timezones][9]

 [1]: http://www.freebsd.org
 [2]: http://www.php.net
 [3]: http://www.mysql.com/
 [4]: http://codeigniter.com
 [5]: http://wordpress.org/
 [6]: http://wordpress.org/support/topic/285337
 [7]: http://php.net/manual/en/ini.core.php
 [8]: http://blog.gslin.org/archives/2007/09/25/1318/
 [9]: http://nl3.php.net/manual/en/timezones.php