---
title: '輕量級 A Clean & Classy PHP Framework Laravel 簡介安裝'
author: appleboy
type: post
date: 2011-10-16T04:40:28+00:00
url: /2011/10/install-a-clean-classy-php-framework-laravel/
dsq_thread_id:
  - 444688716
categories:
  - Laravel
  - php
tags:
  - Laravel
  - php

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6248708214/" title="Laravel PHP Framework by appleboy46, on Flickr"><img src="https://i0.wp.com/farm7.static.flickr.com/6038/6248708214_ef1133d0e9_o.png?resize=283%2C101&#038;ssl=1" alt="Laravel PHP Framework" data-recalc-dims="1" /></a>
</div> 今日作者來介紹一套輕量級 PHP Framework: 

<a href="http://laravel.com/" target="_blank">Laravel</a>，目前還尚未發現台灣有任何人使用這套，然而 PHP Framework 實在太多種了，要把每一套都弄熟實在很不容易，如果作者有玩過一定會上來寫些教學文件，Laravel 是基於 **<span style="color:green">PHP 5.3</span>** 環境的 PHP Framwork，裡面已經都是用物件及 5.3 的 <a href="http://php.net/manual/en/language.namespaces.php" target="_blank">Namespace</a> 下去開發，如果您想研究 Laravel PHP Framework 可以 <a href="http://twitter.com/laravelphp" target="_blank">Follow Laravel Twitter</a>，更重要的是追蹤 <a href="http://github.com/laravel" target="_blank">Github Source Code</a>。也許可以看一下 <a href="http://laravel.com/roadmap" target="_blank">2.0 的 Roadmap</a>。 <!--more-->

### 下載安裝 透過 git 或者是直接

<a href="http://laravel.com/download" target="_blank">下載檔案</a>安裝系統，底下就介紹透過 git 安裝 Laravel 

<pre class="brush: bash; title: ; notranslate" title=""># Ubuntu WWW Directory
$ cd /var/www
$ git clone https://github.com/laravel/laravel.git</pre> 下載好之後，目錄就是 

<span style="color:green"><strong>/var/www/laravel</strong></span>，我們直接打開 <span style="color:green"><strong>http://localhost/larvel/public</strong></span> 就可以看到首頁了。裡面有兩個目錄需要注意，那就是 public 及 application，public 就是您的網站根目錄，所有的 css js images 都是放在這裡面，而 laravel 設定檔則是放在 application 目錄中。 

### 基本設定 我們直接來看 

**<span style="color:green">application</span>** 目錄底下的檔案，基本設定都在 **<span style="color:green">application/config/application.php</span>**。 

<pre class="brush: bash; title: ; notranslate" title=""># 網站根目錄設定
'url' => 'http://localhost/laravel/public/',</pre> 只要將上面設定好，請打開 http://localhost/laravel/public/ 就會看到下面安裝完成畫面 

<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6248768862/" title="Laravel PHP Framework_install by appleboy46, on Flickr"><img src="https://i0.wp.com/farm7.static.flickr.com/6118/6248768862_2fb288a433.jpg?resize=500%2C123&#038;ssl=1" alt="Laravel PHP Framework_install" data-recalc-dims="1" /></a>
</div> 有沒有看到上面畫面，接著就寫 Hello World 了。 

### 基本 Route 請打開 

**<span style="color:green">application/routes.php</span>**，寫一個簡單的 hello word: 

<pre class="brush: php; title: ; notranslate" title="">'GET /hello/(:any)' => function($name)
{
    return "Welcome, $name.";
},
'GET /hello' => function()
{
    return "Welcome, Laravel PHP Framework";
}</pre> 打開瀏覽器 

**<span style="color:green">http://localhost/laravel/public/index.php/hello/</span>** 就可以看到 <span style="color:red">Welcome, Laravel PHP Framework</span>，那打開 **<span style="color:green">http://localhost/laravel/public/index.php/hello/appleboy</span>** 您會看到 <span style="color:red">Welcome, appleboy.</span>。有沒有很眼熟？在 <a href="http://jquery.com/" target="_blank">jQuery</a> 也是這樣的方式寫程式，也就是 <a href="http://php.net/manual/en/functions.anonymous.php" target="_blank">PHP Anonymous functions</a>，個人還蠻喜歡這樣寫。 

### .htaccess 設定 這部份其實就跟 

<a href="http://codeigniter.org.tw" target="_blank">CodeIgniter</a> 文件寫的類似，您可以發現 public 目錄底下已經有了 .htaccess 檔案，底下的教學都是 apache 的方法，如果其他 Web Server 就不適用了。 

<pre class="brush: bash; title: ; notranslate" title="">&lt;IfModule mod_rewrite.c>
     RewriteEngine on

     RewriteCond %{REQUEST_FILENAME} !-f
     RewriteCond %{REQUEST_FILENAME} !-d

     RewriteRule ^(.*)$ index.php/$1 [L]
&lt;/IfModule></pre> 不過如果您的 OS 是 Ubuntu，請改成底下: 

<pre class="brush: bash; title: ; notranslate" title="">&lt;IfModule mod_rewrite.c>
     RewriteEngine on

     RewriteCond %{REQUEST_FILENAME} !-f
     RewriteCond %{REQUEST_FILENAME} !-d

     RewriteRule ^(.*)$ index.php [L]
&lt;/IfModule></pre> 最後請修改 

**<span style="color:green">application/config/application.php</span>** 將 Application Index 填入空白: 

<pre class="brush: php; title: ; notranslate" title="">'index' => '',</pre> 測試的部份，請把上面的測試網址內的 index.php 拿掉，您會得到相同答案。 今天就大致上介紹到這裡，之後再寫更詳細的功能介紹。最後可以參考

<a href="http://laravel.com/docs/start/config" target="_blank">官方上面的文件</a>，都寫的非常清楚。