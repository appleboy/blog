---
title: 在 Fedora 或 Amazon Linux AMI 架設 Nginx + PHP FastCGI
author: appleboy
type: post
date: 2012-05-28T11:34:32+00:00
url: /2012/05/install-nginx-php-fastcgi-on-amazon-linux/
dsq_thread_id:
  - 705922478
categories:
  - Nginx
tags:
  - Amazon
  - AWS
  - Fedora
  - nginx

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/7285947094/" title="799px-Amazon.com-Logo.svg by appleboy46, on Flickr"><img src="https://i0.wp.com/farm8.staticflickr.com/7221/7285947094_9e34eeb903.jpg?resize=500%2C101&#038;ssl=1" alt="799px-Amazon.com-Logo.svg" data-recalc-dims="1" /></a>
</div> 上一篇介紹

<a href="http://blog.wu-boy.com/2012/05/php-fastcgi-with-nginx-on-ubuntu-10-10-maverick/" target="_blank">如何在 Ubuntu 底下安裝 Nginx + PHP FastCGI</a>，這次來紀錄如何安裝在 Fedora 系統，目前環境是使用 <a href="http://aws.amazon.com/amazon-linux-ami/" target="_blank">Amazon Linux AMI</a>，如果有在玩 <a href="http://aws.amazon.com/ec2/" target="_blank">AWS EC2</a> 或是 <a href="http://fedoraproject.org/" target="_blank">Fedora Linux</a> 的話，對這 OS 就不會很陌生了。 <!--more-->

### 安裝 Nginx 用 yum 升級系統所有套件，再安裝 

<a href="http://nginx.org/" target="_blank">Nginx</a> + <a href="http://php.net" target="_blank">PHP</a> 環境 

<pre class="brush: bash; title: ; notranslate" title="">$ yum update
$ yum install nginx php-cli php spawn-fcgi</pre> 將 Nginx 加入開機自動執行，並且啟動它 

<pre class="brush: bash; title: ; notranslate" title="">$ chkconfig --level 35 nginx on
$ service nginx start</pre>

### 設定 Nginx Nginx 設定檔預設放在 /etc/nginx/nginx.conf，如果看過此設定檔你會發現跟 Ubuntu 安裝不同的地方在於這裡沒有 

<span style="color:red">sites-available</span> 跟 <span style="color:red">sites-enabled</span> 目錄，當然我們可以自行去設定 

<pre class="brush: bash; title: ; notranslate" title="">mkdir /etc/nginx/sites-available
mkdir /etc/nginx/sites-enabled</pre> 接著修改 

<span style="color:green">/etc/nginx/nginx.conf</span> 加入底下設定 

<pre class="brush: bash; title: ; notranslate" title=""># Load virtual host configuration files.
include /etc/nginx/sites-enabled/*;</pre> 如果覺得這步驟很麻煩的話，可以直接修改 

<span style="color:green"><strong>/etc/nginx/conf.d/default.conf</strong></span>，這檔案就是 Nginx 預設的 Virtual Host 設定，如果要增加網站，就可以直接建立新檔案 <span style="color:green">/etc/nginx/conf.d/www.example.com.conf</span>，接下來設定單一網站，設定檔內容如下 

<pre class="brush: bash; title: ; notranslate" title="">server {
    server_name www.example.com;
    listen 8090;
    access_log /var/log/nginx/example/logs/access.log;
    error_log /var/log/nginx/example/logs/error.log;
    root /home/www/appleboy;

    location / {
        index index.php index.html index.htm;
    }

    location ~ \.php$ {
        include /etc/nginx/fastcgi_params;
        fastcgi_pass  127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME /home/www/appleboy$fastcgi_script_name;
    }
}</pre> 存檔後，記得建立 logs 目錄，Nginx 不會自動幫忙建立 

<pre class="brush: bash; title: ; notranslate" title="">mkdir -p /var/log/nginx/example/logs/</pre> 如果您想跟 Ubuntu 一樣的建立 Virtual Host，請執行底下步驟 

<pre class="brush: bash; title: ; notranslate" title="">ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/example.com </pre> 最後重新啟動 Nginx 

<pre class="brush: bash; title: ; notranslate" title="">service nginx restart</pre>

### 建立 PHP Fast CGI 環境 我們透過 spawn-fcgi 來管理 CGI process，避免 PHP5-CGI 突然掛掉。首先建立 /usr/bin/php-fastcgi 檔案，內容如下 

<pre class="brush: bash; title: ; notranslate" title="">#!/bin/sh
/usr/bin/spawn-fcgi -P /var/run/php-cgi.pid -a 127.0.0.1 -p 9000 -C 15 -u nginx -g nginx -f /usr/bin/php-cgi</pre> 建立 /etc/rc.d/init.d/php-fastcgi 開機執行 php fastcgi 

<pre class="brush: bash; title: ; notranslate" title="">#!/bin/sh
#
# php-fastcgi - Use PHP as a FastCGI process via nginx.
#
# chkconfig: - 85 15
# description: Use PHP as a FastCGI process via nginx.
# processname: php-fastcgi
# pidfile: /var/run/php-cgi.pid
# modified: Bo-Yi Wu &lt;appleboy.tw AT gmail.com>

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ "$NETWORKING" = "no" ] && exit 0

phpfastcgi="/usr/bin/php-fastcgi"
prog=$(basename php-cgi)

pidfile="/var/run/${prog}.pid"
lockfile="/var/lock/subsys/${prog}"
STOP_TIMEOUT="10"

start() {
    [ -x $phpfastcgi ] || exit 5
    echo -n $"Starting $prog: "
    daemon --pidfile=${pidfile} ${phpfastcgi}
    retval=$?
    echo
    [ $retval -eq 0 ] && touch ${lockfile}
    return $retval
}

stop() {
    echo -n $"Stopping ${prog}: "
    killproc -p ${pidfile} -d ${STOP_TIMEOUT} ${prog}
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -rf ${lockfile} ${pidfile}
    return $retval
}

restart() {
    stop
    start
}

reload() {
    echo -n $"Reloading $prog: "
    killproc $prog -HUP
    RETVAL=$?
    echo
}

force_reload() {
    restart
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    reload)
        reload
        ;;
    force-reload)
        force_reload
        ;;
    status)
        status -p ${pidfile} $prog
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|reload|force-reload}"
        exit 2
esac</pre> 更改 

<span style="color:green"><strong>/etc/rc.d/init.d/php-fastcgi</strong></span> 檔案權限 

<pre class="brush: bash; title: ; notranslate" title="">chmod +x /etc/rc.d/init.d/php-fastcgi</pre> 加入開機自動執行 

<pre class="brush: bash; title: ; notranslate" title="">$ chkconfig --add php-fastcgi
$ chkconfig php-fastcgi on
$ /etc/init.d/php-fastcgi start
</pre> 打開瀏覽器看有沒有正確看到 

<span style="color:green"><strong>phpinfo();</strong></span>