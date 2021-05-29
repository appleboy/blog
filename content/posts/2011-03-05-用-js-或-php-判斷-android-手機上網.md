---
title: 用 js 或 php 判斷 Android 手機上網
author: appleboy
type: post
date: 2011-03-05T09:18:55+00:00
url: /2011/03/用-js-或-php-判斷-android-手機上網/
views:
  - 547
bot_views:
  - 167
dsq_thread_id:
  - 246687183
categories:
  - javascript
  - jQuery
  - php
  - www
tags:
  - javascript
  - php

---
之前寫了一篇 [jQuery 偵測瀏覽器版本, 作業系統(OS detection)][1]，這次可以來加上 Android 手機版本，其實就是分析瀏覽器 [User Agent][2] 來達到目的，底下分享 PHP 跟 Javascript 作法 

### PHP 方法

<pre class="brush: php; title: ; notranslate" title="">if(stripos($_SERVER['HTTP_USER_AGENT'],'Android') !== false) 
{
	header('Location: http://android.xxx.com');
	exit();
}</pre>

### Javascript 方法

<pre class="brush: jscript; title: ; notranslate" title="">if(navigator.userAgent.match(/Android/i))
{
	window.location = 'http://android.xxx.com';
}</pre>

### Apache .htaccess 方法 用 

[Apache mod rewrite][3] 方法 

<pre class="brush: bash; title: ; notranslate" title="">RewriteCond %{HTTP_USER_AGENT} ^.*Android.*$
RewriteRule ^(.*)$ http://android.xxx.com [R=301]
</pre>

 [1]: http://blog.wu-boy.com/2010/10/jquery-%E5%81%B5%E6%B8%AC%E7%80%8F%E8%A6%BD%E5%99%A8%E7%89%88%E6%9C%AC-%E4%BD%9C%E6%A5%AD%E7%B3%BB%E7%B5%B1os-detection/
 [2]: http://en.wikipedia.org/wiki/User_agent
 [3]: http://httpd.apache.org/docs/2.0/mod/mod_rewrite.html