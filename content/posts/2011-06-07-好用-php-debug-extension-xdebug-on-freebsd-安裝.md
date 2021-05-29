---
title: 好用 PHP debug extension Xdebug on FreeBSD 安裝
author: appleboy
type: post
date: 2011-06-07T05:42:18+00:00
url: /2011/06/好用-php-debug-extension-xdebug-on-freebsd-安裝/
views:
  - 165
bot_views:
  - 85
dsq_thread_id:
  - 324309666
categories:
  - FreeBSD
  - php
tags:
  - FreeBSD
  - php
  - Xdebug

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/5806873037/" title="xdebug-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm6.static.flickr.com/5108/5806873037_823aef3cd1_o.png?resize=200%2C116&#038;ssl=1" alt="xdebug-logo" data-recalc-dims="1" /></a>
</div> 之前介紹 

[FirePHP][1] 這套好用的 PHP Debug 工具，也寫了一篇針對 [CodeIgniter][2] 的安裝方式，請參考: [[PHP] 好用 Debug PHP 工具 FirePHP for FireFox on CodeIgniter][3]，今天要介紹一套好用的 PHP debug Extension: [Xdebug][4] 的安裝方式，作者環境是在 FreeBSD 上，Windows 安裝方式就到官方網站下載對應的 PHP Windows binaries，目前在 FreeBSD ports 上面的版本是 2.1.0，但是 Xdebug 作者已經更新到 2.1.1，自己就順手發了一個 [patch 157677][5] 給 FreeBSD 官方 ports 去 update。 

### FreeBSD 安裝步驟

<pre class="brush: bash; title: ; notranslate" title=""># cd /usr/ports/devel/php-xdebug
# make install clean</pre> 設定 

**<span style="color:green">/usr/local/etc/php/extensions.ini</span>** 檔案後面加入 

<pre class="brush: bash; title: ; notranslate" title="">extension=xdebug.so</pre> 設定 

**<span style="color:green">/usr/local/etc/php/php.ini</span>** 檔案後面加入 

<pre class="brush: bash; title: ; notranslate" title="">xdebug.profiler_enable = 1
xdebug.profiler_output_dir = /tmp/profiler</pre> 重新啟動 apache 

<pre class="brush: bash; title: ; notranslate" title="">/usr/local/etc/rc.d/apache22 restart</pre> 之後執行指令 php -v 會發現出現底下 warning message: 

> PHP Warning: Xdebug MUST be loaded as a Zend extension 這時候請修改 **<span style="color:green">/usr/local/etc/php/extensions.ini</span>** 

<pre class="brush: bash; title: ; notranslate" title="">zend_extension="/usr/local/lib/php/20090626-zts/xdebug.so"</pre> 這樣大致上就完成了，你會發現當寫 PHP 網頁如果出現錯誤，會詳細列出哪裡的錯誤，可以參考 

[Xdebug Documentation][6] 看一下 PHP 是否 load Xdebug extension: [<img src="https://i1.wp.com/farm4.static.flickr.com/3468/5806922427_db324552f4.jpg?resize=500%2C93&#038;ssl=1" alt="Xdebug_FreeBSD" data-recalc-dims="1" />][7] Ref: [Xdebug MUST be loaded as a Zend extension][8]

 [1]: http://www.firephp.org/
 [2]: http://codeigniter.org.tw/
 [3]: http://blog.wu-boy.com/2010/06/php-%E5%A5%BD%E7%94%A8-debug-php-%E5%B7%A5%E5%85%B7-firephp-for-firefox-on-codeigniter/
 [4]: http://xdebug.org/index.php
 [5]: http://www.freebsd.org/cgi/query-pr.cgi?pr=157677
 [6]: http://xdebug.org/docs/
 [7]: https://www.flickr.com/photos/appleboy/5806922427/ "Xdebug_FreeBSD by appleboy46, on Flickr"
 [8]: http://www.develobert.info/2008/06/xdebug-must-be-loaded-as-zend-extension.html