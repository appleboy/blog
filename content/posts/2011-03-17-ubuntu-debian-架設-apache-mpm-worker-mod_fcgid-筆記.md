---
title: Ubuntu (Debian) 架設 apache mpm worker mod_fcgid 筆記
author: appleboy
type: post
date: 2011-03-17T03:55:54+00:00
url: /2011/03/ubuntu-debian-架設-apache-mpm-worker-mod_fcgid-筆記/
views:
  - 502
bot_views:
  - 208
dsq_thread_id:
  - 256090385
categories:
  - apache
  - Linux
  - php
  - Ubuntu
tags:
  - apache
  - Debian
  - php
  - Ubuntu

---
最近想架設 [Redmine][1] 在 [Ubuntu][2] 伺服器上面，架設之前要先搞定 apache 搭配 mpm worker 及 mod_fcgi module，安裝步驟其實不難，就搭配懶人指令 [apt][3] 就可以了。 

### 安裝 apache mpm worker 由於怕安裝過程會叫你把 apache2-mpm-worker 移除，改裝 apache2-mpm-prefork，所以安裝順序上面有些變化，請參考底下: 

<pre class="brush: bash; title: ; notranslate" title=""># 先安裝
$ apt-get install apache2.2-bin apache2.2-common apache2-mpm-worker libapache2-mod-fcgid php5-cli php5-cgi php5-common
#後安裝
$ apt-get install apache2 php5 php5-gd php5-curl</pre> 至於 PHP 5 套件就看你需要什麼就裝什麼吧，搜尋一下 php5-* 看看，apache 裝好預設看不到 PHP 網頁，也就是認不得 php type，請在 apache config 檔案加入底下 

<!--more--> 修改 /etc/apache2/apache2.conf 

<pre class="brush: bash; title: ; notranslate" title=""># php
AddType application/x-httpd-php .php
AddType application/x-httpd-php-source .phps</pre> 啟動 fcgid 之前，要先設定 

<span style="color:green">/etc/apache2/mods-available/fcgid.conf</span>，可以參考[官網設定方式][4]，在自己微調 

<pre class="brush: bash; title: ; notranslate" title=""><IfModule mod_fcgid.c>
  AddHandler    fcgid-script .php .fcgi
  FcgidIPCDir /var/lib/apache2/fcgid/sock
  IdleTimeout 3600
  ProcessLifeTime 7200
  MaxProcessCount 1000
  DefaultMinClassProcessCount 3
  DefaultMaxClassProcessCount 100
  IPCConnectTimeout 8
  IPCCommTimeout 360
  BusyTimeout 300
  FcgidWrapper /usr/bin/php5-cgi .php
</IfModule></pre> 修改 php.ini (/etc/php5/cgi/php.ini 跟 etc/php5/cli/php.ini) 

<pre class="brush: bash; title: ; notranslate" title="">cgi.fix_pathinfo=1</pre> 接下來 enable apache 的 module，利用 

<span style="color:red">a2enmod</span> 指令 

<pre class="brush: bash; title: ; notranslate" title="">a2enmod rewrite
a2enmod include
a2enmod suexec
a2enmod fcgid
# 重新啟動 apache
service apache2 restart</pre>

### 設定 Apache Virtual Host 我們可以參考 

<span style="color:green">/etc/apache2/sites-available/default</span> 預設範例來建立其他 Virtual Host，由於跑 mod_fcgid，所以在 Options 部份請**<span style="color:red">務必</span>**加上 <span style="color:green"><strong>ExecCGI</strong></span>。 

<pre class="brush: bash; title: ; notranslate" title=""><VirtualHost *>
    ServerName blog.wu-boy.com
    ServerAdmin nobody@blog.wu-boy.com

    DocumentRoot /XXXXXX
    DirectoryIndex index.php

    <Directory />
        Options FollowSymLinks
        AllowOverride None
    </Directory>
    <Directory /var/www/Blog/>
        Options FollowSymLinks ExecCGI
        # Remove ExecCGI if you do not need php
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
    ErrorLog /var/log/apache2/error.log

    # Possible values include: debug, info, notice, warn, error, crit,
    # alert, emerg.
    LogLevel warn

    CustomLog /var/log/apache2/other_vhosts_access.log combined
</VirtualHost></pre> 把此設定檔儲存到 

<span style="color:green">/etc/apache2/sites-available/Blog</span>，接下來用 <span style="color:red">a2ensite</span> 指令來 enable 

<pre class="brush: bash; title: ; notranslate" title=""># Usage: a2ensite [Virtual Host]
a2ensite Blog</pre> 會發現在 

<span style="color:green">/etc/apache2/sites-enabled/</span> 資料夾裡面多出 <span style="color:green"><strong>Blog</strong></span> 這 Virtual Host，重新啟動 apache2 就完成了。 參考網站: [[Ububtu note.] 關於 Ubuntu, apache, php5, mod_fcgid 與 VirtualBox 筆記][5] [HOWTO: Using php5 with apache2-mpm-worker][6] [Hosting multiple websites with Apache2(利用 a2ensite 新增 Virtual Host)][7]

 [1]: http://www.redmine.org/
 [2]: http://www.ubuntu.com/
 [3]: http://en.wikipedia.org/wiki/Advanced_Packaging_Tool
 [4]: http://httpd.apache.org/mod_fcgid/mod/mod_fcgid.html
 [5]: http://blog.hinablue.me/868
 [6]: http://ubuntuforums.org/showthread.php?t=1038416
 [7]: http://www.debian-administration.org/articles/412