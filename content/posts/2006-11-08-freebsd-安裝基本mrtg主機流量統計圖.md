---
title: '[FreeBSD] 安裝基本mrtg主機流量統計圖'
author: appleboy
type: post
date: 2006-11-08T10:17:40+00:00
url: /2006/11/freebsd-安裝基本mrtg主機流量統計圖/
views:
  - 3573
bot_views:
  - 721
dsq_thread_id:
  - 246749719
categories:
  - FreeBSD
  - Network
tags:
  - FreeBSD
  - mrtg
  - snmp

---
  * 主機資訊 FreeBSD 6.1-RELEASE
  * 安裝步驟

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/net-mgmt/net-snmp; make install clean

cd /usr/ports/net-mgmt/mrtg; make install clean</pre> 這2個安裝好，其實基本上就已經可以使用了 在 /etc/rc.conf 加上 

<pre class="brush: bash; title: ; notranslate" title="">snmpd_enable="YES"
snmpd_flags="-a -p /var/run/snmpd.pid"
snmptrapd_enable="YES"
snmptrapd_flags="-a -p /var/run/snmptrapd.pid"</pre> 修改 snmpd.conf 檔 目錄在 /usr/local/share/snmp/snmpd.conf 

>  <span class="postbody">com2sec local localhost <font color="red">public</font> com2sec lan 192.168.100.0/24 public</span> group RWGroup v1 local group ROGroup v1 lan view all included .1 80 access RWGroup &#8220;&#8221; any noauth prefix all all all access ROGroup &#8220;&#8221; any noauth prefix all none none 紅色部份，盡量不要用 public ，因為這樣別人可以猜到你的mrtg設定 修改好存檔 

<pre class="brush: bash; title: ; notranslate" title="">/usr/local/etc/rc.d/snmpd start</pre> 然後進行流量偵測，網路卡流量 cfgmaker public@localhost 如果沒有錯誤訊息，那就是成功了，把結果輸出到資料夾 cfgmaker public@localhost > /usr/local/etc/mrtg/mrtg.cfg 修改 /usr/local/etc/mrtg/mrtg.cfg # for UNIX 

<font color="#0e000d">Language:Big5</font> =============================================== 修改好存檔，然後執行，產生mrtg報表 

> /usr/local/bin/mrtg /usr/local/etc/mrtg/mrtg.cfg vi /etc/crontab 加入 \*/5 \* \* \* * root /usr/local/bin/mrtg /usr/local/etc/mrtg/mrtg.cfg #每5分鐘統計一遍 產生mrtg的index.htm 

<pre class="brush: bash; title: ; notranslate" title="">indexmaker 
--title='MRTG - <font class="zh-tw">網路流量分析</font>' 
--addhead='

<meta http-equiv="Content-Type" content="text/html; charset=big5" />
' 
--output /usr/local/www/data-dist/mrtg/index.htm 
--columns=1 
--nolegend 
/usr/local/etc/mrtg/mrtg.cfg</pre>

<a target="_blank" href="http://photobucket.com/"><img border="0" alt="Photobucket - Video and Image Hosting" src="https://i0.wp.com/i108.photobucket.com/albums/n5/appleboy46/127.png?w=840" data-recalc-dims="1" /></a>