---
title: '[FreeBSD & Linux] 架設時間伺服器 ntpd'
author: appleboy
type: post
date: 2008-04-22T01:36:53+00:00
url: /2008/04/freebsd-linux-架設時間伺服器-ntpd/
bot_views:
  - 571
views:
  - 4211
dsq_thread_id:
  - 247185286
categories:
  - FreeBSD
  - Linux
tags:
  - ntpd

---
最近在調整系統時間，所以我利用了 Ntpd 伺服器，來微調系統時間，如果不利用這個方式，那可以利用我之前寫的調整系統時間：[[FreeBSD] 修改系統時間 UTC -> CST][1]，然而 Ntpd 會用一份時間伺服器的清單來間歇的檢查系統時間，它會取得這些時間伺服器的平均值，然後漸漸的調整系統時間。 FreeBSD 啟用 Ntpd 的方式： 步驟一：建立 /etc/ntp 這個目錄 

<pre class="brush: bash; title: ; notranslate" title="">#
# 建立目錄
#
mkdir /etc/ntp
</pre>

<!--more--> 步驟二：在 /etc 目錄底下建立 ntp.conf 的檔案 

<pre class="brush: bash; title: ; notranslate" title="">#
# 建立檔案
#
touch /etc/ntp/ntp.conf 
</pre> 步驟三： 請在 ntp.conf 下加入 

<pre class="brush: bash; title: ; notranslate" title="">#
# 把底下加入檔案
# driftfile 後面接的檔案需要使用完整路徑檔名
driftfile /etc/ntp/drift
server tick.stdtime.gov.tw
server tock.stdtime.gov.tw
server time.stdtime.gov.tw
server clock.stdtime.gov.tw
server watch.stdtime.gov.tw
#
# 如果不想其他機器連上你的伺服器，請加入
#
restrict default ignore
#
# 只准許特定ip機器連上
#
restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap
</pre> 步驟四：鍵入馬上啟動 Ntpd 

<pre class="brush: bash; title: ; notranslate" title="">#
# FreeBSD 啟動 ntpd
#
/etc/rc.d/ntpd start
#
# Linux 啟動 
#
/etc/init.d/ntpd start
</pre> 步驟五：於 /etc/rc.conf 加入 

<pre class="brush: bash; title: ; notranslate" title="">#
# 讓系統於開機或重開機後自動執行 Ntpd
#
xntpd_enable="YES"
</pre> 參考： http://linux.vbird.org/linux\_server/0440ntp.php http://www.freebsd.org/doc/zh\_TW/books/handbook/network-ntp.html

 [1]: http://blog.wu-boy.com/2007/06/22/112/