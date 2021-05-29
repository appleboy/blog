---
title: Nginx + phpMyAdmin 搭配 SSL 設定
author: appleboy
type: post
date: 2013-06-08T07:51:08+00:00
url: /2013/06/force-phpmyadmin-ssl-with-nginx/
dsq_thread_id:
  - 1377556509
categories:
  - apache
  - MySQL
  - Nginx
tags:
  - apache
  - MySQL
  - nginx
  - phpMyAdmin

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8171305355/" title="mysql_logo by appleboy46, on Flickr"><img src="https://i1.wp.com/farm9.staticflickr.com/8488/8171305355_7fb578fdc9.jpg?w=300&#038;ssl=1" alt="mysql_logo" data-recalc-dims="1" /></a>
</div>

<a href="http://www.phpmyadmin.net/home_page/index.php" target="_blank">phpMyAdmin</a> 是一套用來管理 <a href="http://www.mysql.com/" target="_blank">MySQL</a> 的 Web 介面，如果要讓 phpMyAdmin 強制走 https 的話，可以透過兩種方式，一種是直接設定 phpMyAdmin，另外一種方式是透過 <a href="http://httpd.apache.org/docs/current/mod/mod_rewrite.html" target="_blank">Apache rewrite</a> 或 <a href="http://nginx.org/" target="_blank">Nginx</a> 設定，底下來分別說明。 <!--more-->

### 1. phpMyAdmin 設定

直接設定 `config.inc.php`，加入底下設定

<pre class="brush: php; title: ; notranslate" title="">$cfg['ForceSSL'] = true;</pre>

### 2. Nginx 或 Apache 設定

打開 Apache mod_rewrite 功能，將設定寫入 `.htaccess`

<pre class="brush: bash; title: .htaccess; notranslate" title=".htaccess">RewriteEngine On
RewriteCond %{SERVER_PORT} !^443$
RewriteRule ^/directory(.*)$ https://%{HTTP_HOST}/directory$1 [L,R]
</pre>

或是使用 Nginx 設定，將 80 port 轉到 https，設定 443 port 的 SSL 憑證。

<pre class="brush: bash; title: ; notranslate" title="">server {
  listen 80;
  server_name xxx.xxx.xxx.xxx;
  rewrite ^ https://$server_name$request_uri? permanent;
}</p>



<p>
  server {
    # listen 80 default_server deferred; # for Linux
    # listen 80 default_server accept_filter=httpready; # for FreeBSD
    #listen 80;
</p>



<p>
  listen 443 ssl spdy;
    ssl on;
    ssl_certificate /etc/nginx/conf/api.ovoq.tv/server.crt;
    ssl_certificate_key /etc/nginx/conf/api.ovoq.tv/ssl.key;
    ssl_protocols       SSLv3 TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 5m;
</p>



<p>
  # The host name to respond to
    server_name xxx.xxx.xxx.xxx;
  }
  </pre>
</p>



<p>
  上面 Nginx 設定完成後，會發現登入 phpMyAdmin 後，網址被轉成
</p>



<blockquote>
  http://xxx.xxx.xxx.xx:443
</blockquote>



<p>
  馬上看到網頁噴
</p>



<blockquote>
  the plain http request was sent to https port
</blockquote>



<p>
  看到這訊息，是 Nginx 產生的，error code 是 497，其實將此 error 導向正確的地方就可以了，在 Nginx 設定檔加入
</p>



<p>
  <pre class="brush: bash; title: ; notranslate" title="">error_page 497 https://$host$request_uri;</pre>
</p>



<p>
  就可以解決此問題了。
</p>



<p>
  Ref: 
  <a href="http://forum.nginx.org/read.php?2,5065,5065" target="_blank">The plain HTTP request was sent to HTTPS port</a>
  <a href="http://www.michaelbarton.name/2009/12/13/forcing-ssl-with-phpmyadmin/" target="_blank">Forcing SSL with phpMyAdmin</a>
</p>