---
title: '[FreeBSD] Lighttpd + PHP + mod_proxy + FastCGI'
author: appleboy
type: post
date: 2008-07-10T01:51:23+00:00
url: /2008/07/freebsd-lighttpd-php-mod_proxy-fastcgi/
views:
  - 7502
bot_views:
  - 895
dsq_thread_id:
  - 249119559
categories:
  - Lighttpd
  - Linux
  - php
  - www
tags:
  - apache
  - FreeBSD
  - lighttpd
  - Linux
  - proxy

---
最近一直在玩 [Lighttpd][1] 這一套 web 的 daemon，我覺得這一套還蠻好用的，不像 Apache 掛載這麼多 module 結果吃還蠻大的資源，加上 Apache 預設跑 MPM prefork 所以如果大型網站大概就會掛掉，線上人數一堆，就會快撐不住了，所以用 [MPM worker][2] 或者是 [MPM Event][3]，然後 [Lighttpd][1] 本身還支援 [mod_rewrite][4] 的功能，可以參考我之前寫的 [[FreeBSD]Lighttpd + php5 + 解決 wordpress Permalinks 問題][5]，不過最近遇到一個很奇怪問題，那就是 [Lighttpd][1] 會自己掛點，但是我看 message 跟 error log 底下是： 

> 2008-07-10 09:08:31: (server.c.1258) NOTE: a request for /wp-includes/js/scriptaculous/effects.js?ver=1.8.0 timed out after writing 32991 bytes. We waited 360 seconds. If this a problem increase server.max-write-idle<!--more--> 我發現，這個問題是還好，不過我參考了 

[gaslin 大神][6]的這一篇[lighttpd + FastCGI + PHP 時的問題][7]，裡面提到FastCGI 跑 TCP socket 比較沒問題，但是用 UNIX 的 socket 會比較有問題，那我也參考了 [Lighttpd][1] 的 Wiki 上用 [Handy External Spawning FastCGI PHP Processes in FreeBSD][8] 這篇所提供的 script，下去跑，最近還在看看結果如何，那大致上作法如下： 1. 把 [fastcgi-php.sh][9] 下載到 /usr/local/etc/rc.d/ 裡面 2. 按到底下步驟 

<pre class="brush: bash; title: ; notranslate" title="">#
# 下面幾乎不用改
#
cd /usr/local/etc/rc.d/
chown root:wheel fastcgi-php.sh
chmod 544 fastcgi-php.sh
mkdir /var/run/fcgiphp
chown www:www /var/run/fcgiphp</pre> 3. 設定 /etc/rc.conf 

<pre class="brush: bash; title: ; notranslate" title="">#
# 基本 rc.conf 設定
#
# 開機啟動
fcgiphp_enable="YES"            
# fast-cgi 指令          
fcgiphp_bin_path="/usr/local/bin/php-cgi"    
fcgiphp_user="www"                       
fcgiphp_group="www"                      
fcgiphp_children="10"                    
fcgiphp_port="8002"
# 如果你要用 tcp socket 的話，那就是把 下面清空                      
fcgiphp_socket=""   
fcgiphp_env="SHELL PATH USER"            
fcgiphp_max_requests="500"               
fcgiphp_addr="localhost"         </pre> 4. 啟動 fast-cgi 

<pre class="brush: bash; title: ; notranslate" title=""># /usr/local/etc/rc.d/fastcgi-php.sh start
Starting fcgiphp.
# /usr/local/etc/rc.d/fastcgi-php.sh stop
Stopping fcgiphp.
# /usr/local/etc/rc.d/fastcgi-php.sh restart
Stopping fcgiphp.
Starting fcgiphp.</pre> 5. 修改 Lighttpd.conf 

<pre class="brush: bash; title: ; notranslate" title="">fastcgi.server             = ( ".php" =>
                               ( "localhost" =>
                                 (
                                   "host" => "127.0.0.1",
                                   "port" => 8002,
                                   "bin-path" => "/usr/local/bin/php-cgi"
                                 )
                               )
                            )</pre> 這樣大致上完成了。 介紹一下 

[Lighttpd][1] 的 [mod_proxy][10] 功能，目前把圖片存放到另外一台，然後用 proxy 的功能導過去 設定如下： 

<pre class="brush: bash; title: ; notranslate" title="">$HTTP["host"] == "pic.wu-boy.com" {
  accesslog.filename = "/var/log/lighttpd/pic.wu-boy.com-access_log"
  proxy.server = ( "" =>
                     ( (
                       "host" => "140.123.107.54",
                       "port" => 80
                     ) )
                 )
}</pre> 這樣就可以達到你想要的功能了

 [1]: http://www.lighttpd.net/
 [2]: http://httpd.apache.org/docs/2.0/mod/worker.html
 [3]: http://httpd.apache.org/docs/2.2/mod/event.html
 [4]: http://trac.lighttpd.net/trac/wiki/Docs%3AModRewrite
 [5]: http://blog.wu-boy.com/2008/07/03/287/
 [6]: http://blog.gslin.org
 [7]: http://blog.gslin.org/archives/2007/01/18/1020/
 [8]: http://trac.lighttpd.net/trac/wiki/fastcgi-php-starter-for-freebsd
 [9]: http://blog.wu-boy.com/wp-content/uploads/2008/07/fastcgi-php.sh
 [10]: http://trac.lighttpd.net/trac/wiki/Docs%3AModProxy