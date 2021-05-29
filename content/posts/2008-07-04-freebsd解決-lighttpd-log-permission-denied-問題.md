---
title: '[FreeBSD]解決 lighttpd log Permission denied 問題'
author: appleboy
type: post
date: 2008-07-04T04:01:59+00:00
url: /2008/07/freebsd解決-lighttpd-log-permission-denied-問題/
views:
  - 5332
bot_views:
  - 560
dsq_thread_id:
  - 246885925
categories:
  - FreeBSD
  - Lighttpd
  - Linux
  - www
tags:
  - lighttpd
  - log

---
今天早上伺服器 lighttpd 沒有跑起來，發現是因為沒有寫入 lighttpd.access.log 的權限，所以造成不能啟動 

> 2008-07-04 08:37:15: (mod_accesslog.c.535) opening access-log failed: Permission denied /var/log/lighttpd/lighttpd.access.log 目前的解法大概就是不能去改 /var/log 這個資料夾權限，所以我在 /var/log 底下新增 lighttpd 這個資料夾 <!--more-->

<pre class="brush: bash; title: ; notranslate" title="">#
# 新增 lighttpd 資料夾
#
mkdir -p /var/log/lighttpd
#
# 改變權限
#
chown -R www:www /var/log/lighttpd</pre> 接下來就是 log 檔案會每日增大，所以必須靠 newsyslog 來幫忙了，首先當然就是要去設定 newsyslog.conf 

<pre class="brush: bash; title: ; notranslate" title=""># logfilename          [owner:group]    mode count size when  flags [/pid_file] [sig_num]
/var/log/lighttpd/lighttpd.access.log  www:www          644  7     *    @T00  JC    /var/run/lighttpd.pid</pre> /var/log/lighttpd/lighttpd.access.log 這就是你要每天定期備份的 log 檔案 www:www 這個檔案擁有者，這個必須設定，不然 lighttpd 就不能讓你啟動，因為系統 rotate log 之後，權限會變成 root 644 這個不用說了吧，檔案權限 7 這個就是檔案數量了喔，大概備份7天 * size 大小，因為我設定每天備份，所以不限制大小了喔 @T00 這就是每天晚上12點進行備份 

<pre class="brush: bash; title: ; notranslate" title="">$D0     rotate every night at midnight (same as @T00)
                   $D23    rotate every day at 23:00 (same as @T23)
                   $W0D23  rotate every week on Sunday at 23:00
                   $W5D16  rotate every week on Friday at 16:00</pre> 上面是 man 寫的，很清楚吧，這樣設定之後，大概就沒什麼問題了，剩下就是重新啟動服務 

<pre class="brush: bash; title: ; notranslate" title="">#
# 重新啟動服務 
#
/etc/rc.d/newsyslog restart
/etc/rc.d/syslogd restart</pre>