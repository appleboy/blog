---
title: '[FreeBSD] 利用 portmaster 升級 PHP 5.26 -> 5.28'
author: appleboy
type: post
date: 2009-02-23T12:14:48+00:00
url: /2009/02/freebsd-利用-portmaster-升級-php-526-528/
views:
  - 9788
bot_views:
  - 627
dsq_thread_id:
  - 246824079
categories:
  - FreeBSD
  - Linux
  - php
tags:
  - FreeBSD
  - Linux
  - php
  - ports

---
之前在 [大神][1] 那邊看到一篇 升級 [PHP 5.2.8 的一些小細節][2]，就來把我的機器升級一下，發現 php 5.2.7 之後已經把 pcre extension 納入在裡面，參考 /usr/ports/UPDATING 裡面的  20081211 這個項目，可以利用 [portupgrade][3] 或者是 [portmaster][4] 來升級，之前都是利用 ruby 寫的 portupgrade 來升級系統或者是更新安全性，現在利用 portmaster 這一套也是不錯用，portmaster 是用 sh 寫出來的，在 gslin 大神這一篇：[portupgrade、portmaster、portconf][5] 說到速度方面比 portupgrade 還要好，這我沒有實際測試過，自己在實際用了一下，還蠻方便的。 安裝 [portmaster][4] 跟 [portconf][6] 搭配： 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/ports-mgmt/portconf
make install clean
cd /usr/ports/ports-mgmt/portmaster
make install clean</pre>

<!--more--> 先找出需要升級的套件： 

<pre class="brush: bash; title: ; notranslate" title="">pkg_version -v</pre> 在利用 

[portmaster][4] 升級 [php5][7] 

<pre class="brush: bash; title: ; notranslate" title="">pkg_delete -f php5-pcre\*
portmaster pecl\*
portmaster php5\*</pre> 如果是利用 

[portupgrade][3]： 

<pre class="brush: bash; title: ; notranslate" title="">pkg_delete -f php5-pcre-*
pkgdb -F
portupgrade -f php5*
portupgrade -f pecl*</pre> 之前還沒升級的時候，利用 

[portaudit][8] 檢查套件的安全性，發現 [php5-gd][9] 在 5.2.6 版有安全性的問題，所以就順便一起升級到 5.2.8_1 安裝 [portaudit][8]： 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/ports-mgmt/portaudit/
make install clean</pre> 升級 

[php5-gd][9]： 

<pre class="brush: bash; title: ; notranslate" title="">#
# -C：升級之前先清除套件 make clean
# -G：升級之前先檢查 make config
# -i：升級安裝套件之前，先詢問使用者
# -d：安裝之後清除套件
portmaster -CGid php5-gd-5.2.6</pre>

**update 2009.02.24：gslin 大神補充了一篇：[portmaster][10]**

 [1]: http://blog.gslin.org
 [2]: http://blog.gslin.org/archives/2008/12/10/1879/
 [3]: http://www.freshports.org/ports-mgmt/portupgrade/
 [4]: http://www.freshports.org/ports-mgmt/portmaster/
 [5]: http://blog.gslin.org/archives/2007/03/05/1113/
 [6]: http://www.freshports.org/ports-mgmt/portconf
 [7]: http://tw.php.net
 [8]: http://www.freshports.org/ports-mgmt/portaudit/
 [9]: http://www.freshports.org/graphics/php5-gd/
 [10]: http://blog.gslin.org/archives/2009/02/24/1951/