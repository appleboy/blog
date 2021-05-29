---
title: '[FreeBSD] SNMP 統計流量分析 mrtg'
author: appleboy
type: post
date: 2008-03-20T14:05:08+00:00
url: /2008/03/freebsd-snmp-統計流量分析-mrtg/
views:
  - 8488
bot_views:
  - 974
dsq_thread_id:
  - 246749673
categories:
  - FreeBSD
tags:
  - FreeBSD
  - mrtg
  - snmp

---
最近處理系上伺服器，安裝的是 [FreeBSD][1] 7.0 Release 版本，想說來裝個 [mrtg][2] 來統計流量，因為目前 SNMP 已經納入 FreeBSD base 系統裡面了，所以在安裝 mrtg 就相當方便了，我之前有寫過三篇關於統計流量的教學 [MRTG Server performace][3] [[Linux] Mrtg 實做 war3 線上人數統計][4] [[FreeBSD] 安裝基本mrtg主機流量統計圖][5] [[FC4] snmpd + mrtg 安裝教學「注意事項」][6] <!--more--> 上面這幾篇看完，大概也就會基本的 mrtg 畫圖了，只不過我在 FreeBSD 上有遇到一個問題： 首先我們先要開啟 /etc/rc.conf，加入 bsnmp 服務 

<pre class="brush: bash; title: ; notranslate" title=""># bsnmpd
bsnmpd_enable="YES"
</pre> 第一次啟動時可以手動跑： 

<pre class="brush: bash; title: ; notranslate" title="">/etc/rc.d/bsnmpd start
</pre> 在啟動的時候遇到下面問題 

> Mar 20 23:10:01 www snmpd[67795]: foobar: hostname nor servname provided, or not known Mar 20 23:10:01 www snmpd[67795]: in file /etc/snmpd.config line 46 Mar 20 23:10:01 www snmpd[67795]: error in config file 後來解決方式呢，就是打開 snmpd 的設定檔/etc/snmpd.config 把 

> host := foobar 改成 

> #改成自己的機器 domain host := www.xxx.ccu.edu.tw  這樣就解決了，不過我去比對了一下 FreeBSD 6.3 跟 7.0 版本，發現 7.0 release : 

> \# open standard SNMP ports begemotSnmpdPortStatus.0.0.0.0.161 = 1 6.3 release : 

> \# open standard SNMP ports begemotSnmpdPortStatus.[$(host)].161 = 1 begemotSnmpdPortStatus.127.0.0.1.161 = 1 6.3 多了那一行，我也不知道做什麼用的 解答：感謝 JoeHorn 

> begemotSnmpdPortStatus.0.0.0.0.161 = 1 把 161 port 開在 \*.\* ，像這樣： root bsnmpd 803 6 udp4 \*:161 \*:\* : 6.3 release : : # open standard SNMP ports : begemotSnmpdPortStatus.[$(host)].161 = 1 : begemotSnmpdPortStatus.127.0.0.1.161 = 1 把 161 port 開在特定 IP 與 localhost ， ex： root bsnmpd 677 6 udp4 111.222.333.444:161 \*:\* root bsnmpd 677 7 udp4 127.0.0.1:161 \*:* 然後裝 [net-mgmt/mrtg][7]： 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/net-mgmt/mrtg
make install clean
</pre> 加入 /etc/rc.conf 檔案 

<pre class="brush: bash; title: ; notranslate" title=""># mrtg
mrtg_daemon_enable="YES"
</pre> 裝完後跑 cfgmaker 產生檔案： 

<pre class="brush: bash; title: ; notranslate" title="">cfgmaker public@127.0.0.1 > mrtg.cfg
</pre> 在 cfg 檔案裡面加入 

> RunAsDaemon:Yes Interval:5 Refresh:300 這樣的話，比較不會吃系統資源，不然如果利用 crontab 去每5分鐘跑一次的話，跑的瞬間會衝到 CPU 使用率 100％ 然後修改 mrtg.cfg 內的 WorkDir，最後產生 index.html： 

<pre class="brush: bash; title: ; notranslate" title="">indexmaker --bodyopt="bgcolor=#87CEFA link=#0000FF alink=#FF0000 vlink=#8B008B text=#000000 bgproperties=fixed"    \   --addhead='

<META HTTP-EQUIV="Content-Type" CONTENT="text/html;charset=utf-8" />
'  \
--width=500 \
 --height=135  \
-title="NAS Server - 網路流量分析"  \
-output="/var/www/html/mrtg/index.htm"  \
/etc/mrtg/mrtg.cfg.local
</pre> 最後在寫入開機程序 /etc/rc.local 

> /usr/bin/env LANG=C /usr/local/bin/mrtg /usr/local/etc/mrtg/mrtg.cfg 這樣以後開機就會自動執行了 參考資料： gslin 大大：[FreeBSD 上的 SNMP][8]

 [1]: http://www.freebsd.org
 [2]: http://www.mrtg.com/
 [3]: http://blog.wu-boy.com/2006/12/05/51/
 [4]: http://blog.wu-boy.com/2006/11/28/47/
 [5]: http://blog.wu-boy.com/2006/11/08/32/
 [6]: http://blog.wu-boy.com/2006/09/26/19/
 [7]: http://www.freshports.org/net-mgmt/mrtg/
 [8]: http://blog.gslin.org/archives/2007/08/19/1275/