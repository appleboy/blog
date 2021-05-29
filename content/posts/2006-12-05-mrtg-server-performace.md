---
title: MRTG Server performace
author: appleboy
type: post
date: 2006-12-05T14:15:39+00:00
url: /2006/12/mrtg-server-performace/
bot_views:
  - 776
views:
  - 2613
dsq_thread_id:
  - 246875229
categories:
  - FreeBSD
  - Linux

---
每次看到 每5分鐘執行 mrtg 的時候， 以root身份去執行它，會使系統瞬間負載增加 就算在好的電腦，我發現在mrtg畫圖的瞬間，還是會使系統負擔，要如何避免這樣呢 

> The RunAsDaemon keyword enables daemon mode operation. The purpose of daemon mode is that MRTG is launched once and not repeatedly (as it is with cron). This behavior saves computing resourses as loading and parsing of configuration files happens only once. Using daemon mode MRTG itself is responible for timing the measurement intervals. Therfore its important to set the Interval keyword to an apropiate value. 那就是在 cfg檔案裏面增加 

<pre class="brush: bash; title: ; notranslate" title="">RunAsDaemon:Yes
Interval:5
Refresh:300 </pre> 然後crontab 裏面就不需要寫入 每隔5分鐘執行一次了，然後把它寫入 /etc/rc.local 開機自動執行 

<pre class="brush: bash; title: ; notranslate" title="">##
# automatic mrtg
##
env LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg.local</pre> 製作 mrtg 的 index.htm檔 

<pre class="brush: bash; title: ; notranslate" title="">indexmaker --bodyopt="bgcolor=#87CEFA link=#0000FF alink=#FF0000 vlink=#8B008B text=#000000 bgproperties=fixed"    \   --addhead='

<META HTTP-EQUIV="Content-Type" CONTENT="text/html;charset=utf-8" />
'  \
--width=500 \
 --height=135  \
-title="NAS Server - 網路流量分析"  \
-output="/var/www/html/mrtg/index.htm"  \
/etc/mrtg/mrtg.cfg.local
</pre>

<http://oss.oetiker.ch/mrtg/doc/indexmaker.en.html> <http://oss.oetiker.ch/mrtg/doc/mrtg-reference.en.html>