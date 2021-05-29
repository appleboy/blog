---
title: 在 Ubuntu 10.10 (Maverick) 架設 Nginx + PHP FastCGI
author: appleboy
type: post
date: 2012-05-25T13:41:19+00:00
url: /2012/05/php-fastcgi-with-nginx-on-ubuntu-10-10-maverick/
dsq_thread_id:
  - 703232783
categories:
  - Nginx
  - Ubuntu
tags:
  - fastcgi
  - nginx
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6760100409/" title="logo-Ubuntu by appleboy46, on Flickr"><img src="https://i2.wp.com/farm8.staticflickr.com/7153/6760100409_b23d1ce67b_m.jpg?resize=240%2C165&#038;ssl=1" alt="logo-Ubuntu" data-recalc-dims="1" /></a>
</div> 今天來筆記如何在 

<a href="http://www.ubuntu-tw.org/" target="_blank">Ubuntu</a> 底下完整安裝 <a href="http://nginx.org/" target="_blank">Nginx</a> + <a href="http://www.fastcgi.com/drupal/" target="_blank">PHP FastCGI</a>，以及了解 Nginx 基本設定。我想大家都知道 <a href="http://www.apache.org/" target="_blank">Apache</a> 是一個很好的 Web Server 伺服器，也常常用在個人網站，或者一般小型專案，網路上也有一堆懶人包，如 <a href="http://www.appservnetwork.com/" target="_blank">Appserv</a>, <a href="http://www.apachefriends.org/zh_tw/xampp.html" target="_blank">Xampp</a>，對於新手入門來說 Apache 是一個很好的選擇，但是您會發現用了 Apache 後，系統記憶體常常飆高 XD，載入太多額外不必要的模組，所以非常肥大，那這次就來嘗試另外一套 Web 伺服器 Nginx 吧。 <!--more-->

### 安裝套件 Ubuntu 可以透過 

<a href="http://tavi.debian.org.tw/index.php?page=apt-get" target="_blank">apt-get</a> 方式安裝 

<pre class="brush: bash; title: ; notranslate" title="">$ apt-get update
$ apt-get upgrade
$ apt-get install nginx php5-cli php5-cgi spawn-fcgi psmisc</pre> PHP CGI binary 能自行執行在 Fast CGI Interface 上面，並不需要額外安裝任何程式。只需要安裝 php-cgi 套件 

**<span style="color:green">aptitude install php5-cgi</span>**，接著執行 **<span style="color:green">php-cgi -b 127.0.0.1:9000</span>** 就完成了。你會發現 local 端用 PHP 跑起一個 FastCGI interface 服務，透過 Nginx 的 **<span style="color:red">fastcgi_pass 127.0.0.1:9000;</span>** 就可以跟 FastCGI 做溝通。 

### 開機自動執行 PHP FastCGI 建立 PHP FastCGI 開機啟動 Script，首先打開 

<span style="color:green">/etc/init.d/php-fcgi</span> (如果無此檔案，請用 touch 方式產生)，將底下 shell script 程式碼放入 

<pre class="brush: bash; title: ; notranslate" title="">#!/bin/bash
BIND=127.0.0.1:9000
USER=www-data
PHP_FCGI_CHILDREN=15
PHP_FCGI_MAX_REQUESTS=1000

PHP_CGI=/usr/bin/php5-cgi
PHP_CGI_NAME=`basename $PHP_CGI`
PHP_CGI_ARGS="- USER=$USER PATH=/usr/bin PHP_FCGI_CHILDREN=$PHP_FCGI_CHILDREN PHP_FCGI_MAX_REQUESTS=$PHP_FCGI_MAX_REQUESTS $PHP_CGI -b $BIND"
RETVAL=0

start() {
      echo -n "Starting PHP FastCGI: "
      start-stop-daemon --quiet --start --background --chuid "$USER" --exec /usr/bin/env -- $PHP_CGI_ARGS
      RETVAL=$?
      echo "$PHP_CGI_NAME."
}
stop() {
      echo -n "Stopping PHP FastCGI: "
      killall -q -w -u $USER $PHP_CGI
      RETVAL=$?
      echo "$PHP_CGI_NAME."
}

case "$1" in
    start)
      start
  ;;
    stop)
      stop
  ;;
    restart)
      stop
      start
  ;;
    *)
      echo "Usage: php-fcgi {start|stop|restart}"
      exit 1
  ;;
esac
exit $RETVAL
</pre> 存檔後，請修改此檔案權限，讓其他使用者可以執行程式。 

<pre class="brush: bash; title: ; notranslate" title="">chmod +x /etc/init.d/php-fcgi</pre> 透過底下方式，可以隨時啟動或關閉 PHP FastCGI 

<pre class="brush: bash; title: ; notranslate" title=""># start the fast cgi
/etc/init.d/php-fcgi start
# stop the fast cgi
/etc/init.d/php-fcgi stop
# restart fast cgi
/etc/init.d/php-fcgi restart</pre> 加入開機自動執行 

<pre class="brush: bash; title: ; notranslate" title="">update-rc.d php-fcgi defaults</pre>

### 編輯 Nginx 設定檔 Nginx 設定檔目錄在 /etc/nginx/，我們打開設定檔 nginx.conf 

<pre class="brush: bash; title: ; notranslate" title="">user www-data;
worker_processes  1;

error_log  /var/log/nginx/error.log;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
    # multi_accept on;
}

http {
    include       /etc/nginx/mime.types;

    access_log	/var/log/nginx/access.log;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;
    tcp_nodelay        on;

    gzip  on;
    gzip_disable "MSIE [1-6]\.(?!.*SV1)";

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}</pre> 此檔案不需要更動，我們可以看到最後一行有 

<span style="color:green">include /etc/nginx/sites-enabled/*</span>，這就是 Nginx Virtual Host 設定檔位置，預設會有一個 default 設定，如果需要建立其它 domain，我們就可以複製此檔案即可。底下會帶大家如何設定 Nginx + PHP FastCGI，直接打開 default，加底下設定值寫到檔案即可 

<pre class="brush: bash; title: ; notranslate" title="">location ~ \.php {
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    include /etc/nginx/fastcgi_params;
    keepalive_timeout 0;
    fastcgi_param SCRIPT_FILENAME /var/www$fastcgi_script_name;
}</pre> 注意看到 fastcgi_pass 就是用 TCP 方式跟 PHP FastCGI 溝通，另外網頁目錄也是需要設定 

<pre class="brush: bash; title: ; notranslate" title="">location / {
    root   /var/www;
    index  index.php index.html index.htm;
}</pre> 設定完成後，重新啟動 Nginx 

<pre class="brush: bash; title: ; notranslate" title="">/etc/init.d/nginx restart</pre> 打開 /var/www/phpinfo.php 裡面寫入 

<pre class="brush: php; title: ; notranslate" title=""><?php
phpinfo();
?></pre> 看到 PHP 設定值畫面就代表架設成功。另外可以用 /etc/init.d/nginx configtest 檢查 Nginx 設定檔是否正確，如果要新開虛擬網站，請透過底下方式建立 

<pre class="brush: bash; title: ; notranslate" title=""># 建立目錄
mkdir /var/www/www.example.com
# 建立設定檔
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/example.com
# 連結
ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/example.com
# 重新啟動伺服器
/etc/init.d/php-fcgi start
/etc/init.d/nginx restart</pre>

### 出現 No input file specified. 請注意網站設定檔是否設定錯誤 

<pre class="brush: bash; title: ; notranslate" title="">fastcgi_param SCRIPT_FILENAME /var/www$fastcgi_script_name;</pre> 上面請務必設定正確，根據不同的根目錄，請自行修改 

<span style="color:green"><strong>/var/www</strong></span> 這部份 其他參考網站: <a href="http://tomasz.sterna.tv/2009/04/php-fastcgi-with-nginx-on-ubuntu/" target="_blank">PHP FastCGI with nginx on Ubuntu</a> <a href="http://blog.longwin.com.tw/2010/11/nginx-php-cgi-ubuntu-1004-2010/" target="_blank">架設 Nginx + PHP FastCGI 於 Ubuntu Linux 10.04</a> <a href="http://library.linode.com/web-servers/nginx/php-fastcgi/ubuntu-10.10-maverick" target="_blank">Nginx and PHP-FastCGI on Ubuntu 10.10 (Maverick)</a> <a href="http://wiki.nginx.org/PHPFcgiExample" target="_blank">官方 Wiki: PHPFcgiExample (必看)</a> <a href="http://wiki.nginx.org/Configuration" target="_blank">官方 Wiki: Configuration</a>