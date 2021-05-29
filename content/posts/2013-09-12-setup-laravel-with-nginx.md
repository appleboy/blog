---
title: Nginx 搭配 Laravel PHP Framework 設定
author: appleboy
type: post
date: 2013-09-12T07:45:45+00:00
url: /2013/09/setup-laravel-with-nginx/
dsq_thread_id:
  - 1751184972
categories:
  - Laravel
  - Nginx
  - php
tags:
  - Laravel
  - nginx

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6248708214/" title="Laravel PHP Framework by appleboy46, on Flickr"><img src="https://i0.wp.com/farm7.static.flickr.com/6038/6248708214_ef1133d0e9_o.png?resize=283%2C101&#038;ssl=1" alt="Laravel PHP Framework" data-recalc-dims="1" /></a>
</div> 筆記在 

<a href="http://nginx.org/" target="_blank">Nginx</a> 設定 <a href="http://laravel.com" target="_blank">Laravel</a> 專案，現在的 PHP Framework 都將 query string 整個導向首頁 index.php，就拿 <a href="http://www.codeigniter.org.tw/" target="_blank">CodeIgniter</a> 來說，在 <a href="http://httpd.apache.org/" target="_blank">Apache</a> 只要設定 

<pre class="brush: bash; title: ; notranslate" title="">RewriteEngine on
RewriteBase /
RewriteCond $1 !^(index\.php|images|robots\.txt|$)
RewriteRule ^(.*)$ index.php/$1 [L,QSA]</pre> 在 Nginx 內只要透過 

<a href="http://wiki.nginx.org/HttpCoreModule#try_files" target="_blank">try_files</a> 即可 

<pre class="brush: bash; title: ; notranslate" title="">location / {
    try_files $uri $uri/ /index.php
}</pre> 正常來說 Laravel 直接用上面的設定即可，但是我發現在 $_GET 這全域變數會拿到空值，解法也很簡單，在 Nginx 將 query string 變數帶到 index.php 後面即可 

<pre class="brush: bash; title: ; notranslate" title="">location / {
    try_files $uri $uri/ /index.php?$query_string;
}</pre>