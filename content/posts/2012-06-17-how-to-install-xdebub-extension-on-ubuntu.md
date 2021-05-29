---
title: PHP 程式設計師必備 Xdebug extension 安裝 on Ubuntu
author: appleboy
type: post
date: 2012-06-17T06:18:38+00:00
url: /2012/06/how-to-install-xdebub-extension-on-ubuntu/
dsq_thread_id:
  - 729451966
categories:
  - Linux
  - php
  - Ubuntu
tags:
  - php
  - Ubuntu
  - Xdebug

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/5806873037/" title="xdebug-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm6.static.flickr.com/5108/5806873037_823aef3cd1_o.png?resize=200%2C116&#038;ssl=1" alt="xdebug-logo" data-recalc-dims="1" /></a>
</div> 之前寫了一篇

<a href="http://blog.wu-boy.com/2011/06/%E5%A5%BD%E7%94%A8-php-debug-extension-xdebug-on-freebsd-%E5%AE%89%E8%A3%9D/" target="_blank">在 FreeBSD 的安裝方式</a>，這次來紀錄如何在 Ubuntu 系統上安裝 <a href="http://xdebug.org/" target="_blank">Xdebug PHP extension</a>，開發網頁有太多的 debug 工具，其實最重要只要找到合適的開發環境，縮短專案開發程式時間，那底下就是介紹如何安裝在 Ubuntu 12.04 系統上。 

### 系統安裝 透過 Ubuntu 內建程式 apt 安裝即可 

<pre class="brush: bash; title: ; notranslate" title=""># php xdebug
aptitude -y install php5-dev
aptitude -y install php-pear
pecl install xdebug</pre>

<!--more-->

### 啟動 Xdebug 在 Ubuntu 系統，對於 PHP 系統在 

<span style="color:red">/etc/php5</span> 目錄底下分別有 cgi 和 cli 兩個不同目錄，cgi 是用在 Web 而 cli 則是用在 command line，所以其實兩個都是需要設定的。 打開 <span style="color:green">/etc/php5/cgi/php.ini</span> 和 <span style="color:green">/etc/php5/cli/php.ini</span> 加入 

<pre class="brush: bash; title: ; notranslate" title="">[xdebug]
zend_extension="/usr/lib/php5/20090626/xdebug.so"
xdebug.profiler_enable = 1
xdebug.profiler_output_dir = /tmp/profiler</pre> 如果用 CLI 執行 PHP 可以多加上色彩顯示 

<pre class="brush: bash; title: ; notranslate" title="">xdebug.cli_color = 2</pre> 另外最後要把 error message 打開、 

<pre class="brush: bash; title: ; notranslate" title="">display_errors = On
display_startup_errors = On
html_errors = On</pre> 這樣就可以看到 web 和 cli 輸出錯誤訊息，當然也幫助您用 

<a href="http://php.net/manual/en/function.var-dump.php" target="_blank">var_dump</a> 函式來除錯。