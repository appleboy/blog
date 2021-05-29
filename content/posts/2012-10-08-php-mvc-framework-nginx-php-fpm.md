---
title: PHP MVC Framework 搭配 Nginx + PHP-FPM 設定檔
author: appleboy
type: post
date: 2012-10-08T12:03:03+00:00
url: /2012/10/php-mvc-framework-nginx-php-fpm/
dsq_thread_id:
  - 876476448
categories:
  - CodeIgniter
  - Laravel
  - Nginx
  - php
  - Ubuntu
tags:
  - apache
  - CodeIgniter
  - Laravel
  - nginx
  - php
  - php-fpm

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6248708214/" title="Laravel PHP Framework by appleboy46, on Flickr"><img src="https://i0.wp.com/farm7.static.flickr.com/6038/6248708214_ef1133d0e9_o.png?resize=283%2C101&#038;ssl=1" alt="Laravel PHP Framework" data-recalc-dims="1" /></a>
</div> 相信大家都知道 

<a href="http://nginx.com/" target="_blank">Nginx</a> 搭配 <a href="http://php-fpm.org/" target="_blank">PHP-FPM</a> 用起來效能還不錯，這次來筆記如何設定 Nginx 去除 PHP MVC Framework 討厭的 index.php 字串，不管是 <a href="http://laravel.com/" target="_blank">Laravel</a> 或 <a href="http://codeigniter.org.tw" target="_blank">CodeIgniter</a> 教學文件都是在 <a href="http://www.apache.org/" target="_blank">Apache</a> 設定 <a href="http://en.wikipedia.org/wiki/Htaccess" target="_blank">.htaccess</a> 來達成 Cleaner URL，Apache 最大好處支援 .htaccess，但是 Nginx 也有強大的效能，此篇紀錄如何設定 Nginx 達成 <a href="http://httpd.apache.org/docs/2.2/mod/mod_rewrite.html" target="_blank">mod_rewrite</a> 效果。 <!--more--> 首先來看看 apache .htaccess 是如何設定: 

<pre class="brush: bash; title: ; notranslate" title=""><IfModule mod_rewrite.c>
     RewriteEngine on

     RewriteCond %{REQUEST_FILENAME} !-f
     RewriteCond %{REQUEST_FILENAME} !-d

     RewriteRule ^(.*)$ index.php/$1 [L]
</IfModule></pre> 上面的意思就是代表如果該 URL 是不存在的檔案或者是目錄就全部導向 index.php，如果在 

<a href="http://www.ubuntu.com/" target="_blank">Ubuntu</a> 底下可能會產生 Loop，請把 .htaccess 改成底下 

<pre class="brush: bash; title: ; notranslate" title="">Options +FollowSymLinks
RewriteEngine on

RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d

RewriteRule . index.php [L]</pre> 接著 Nginx 是如何設定呢？打開虛擬主機設定檔 

**<span style="color:green">/etc/nginx/sites-available/xxxx</span>**，將底下設定寫入 

<pre class="brush: bash; title: ; notranslate" title="">server {
    listen       80;
    server_name  laravel.wuboy.twbbs.org;
    root         /usr/home/git/laravel/public;

    access_log /var/log/nginx/laravel_access.log;
    error_log /var/log/nginx/laravel_error.log;

    location / {
        index  index.php index.html index.htm;
    }

    if ($request_uri ~* index/?$)
    {
        rewrite ^/(.*)/index/?$ /$1 permanent;
    }

    # removes trailing slashes (prevents SEO duplicate content issues)
    if (!-d $request_filename)
    {
        rewrite ^/(.+)/$ /$1 permanent;
    }

    # removes access to "system" folder, also allows a "System.php" controller
    if ($request_uri ~* ^/system)
    {
        rewrite ^/(.*)$ /index.php?/$1 last;
        break;
    }

    # unless the request is for a valid file (image, js, css, etc.), send to bootstrap
    if (!-e $request_filename)
    {
        rewrite ^/(.*)$ /index.php?/$1 last;
        break;
    }

    # catch all
    error_page 404 /index.php;

    # use fastcgi for all php files
    location ~ \.php$
    {
        fastcgi_pass unix:/tmp/php-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include /usr/local/etc/nginx/fastcgi_params;
        fastcgi_param HTTPS off;
    }

    # deny access to apache .htaccess files
    location ~ /\.ht
    {
        deny all;
    }
}</pre> 基本上按照上面的設定，你就可以成功移除 index.php 字眼，底下來解釋此設定檔 

<pre class="brush: bash; title: ; notranslate" title="">if ($request_uri ~* index/?$)
{
    rewrite ^/(.*)/index/?$ /$1 permanent;
}</pre> 此設定會將 /controller/index 轉成 /controller，因為每一個 Controller 預設的 method 就是 index，所以我想也不用特別顯示在 URL 上面。permanent 所代表就是 301 轉向。 

<pre class="brush: bash; title: ; notranslate" title="">if (!-d $request_filename)
{
    rewrite ^/(.+)/$ /$1 permanent;
}</pre> 此設定會將 URL 最後的 Slash 給拿掉，防止 SEO 取得重複資訊。 

<pre class="brush: bash; title: ; notranslate" title="">if ($request_uri ~* ^/system)
{
    rewrite ^/(.*)$ /index.php?/$1 last;
    break;
}</pre> 此設定是禁止存取 system 目錄，此目錄是 CodeIgniter 核心目錄，那 Laravel 沒有此問題，因為你的虛擬主機一定會指向 public 目錄，所以也無法存取上層 Laravel 核心目錄 

<pre class="brush: bash; title: ; notranslate" title="">if (!-e $request_filename)
{
    rewrite ^/(.*)$ /index.php?/$1 last;
    break;
}</pre> 此設定來到 URL 最後判斷，如果 URL 連結並非是實體檔案，則全部導向 /index.php?/$1，也就完成了 Cleaner URL 動作，最下面設定了 PHP-FPM Socket Server，這邊就不多說了，設定檔給大家參考，如果有任何問題請留言。