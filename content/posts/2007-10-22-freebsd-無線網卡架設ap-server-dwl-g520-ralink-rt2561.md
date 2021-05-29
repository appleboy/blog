---
title: '[FreeBSD] 無線網卡架設AP Server DWL-G520 Ralink RT2561'
author: appleboy
type: post
date: 2007-10-22T12:22:57+00:00
url: /2007/10/freebsd-無線網卡架設ap-server-dwl-g520-ralink-rt2561/
views:
  - 8044
bot_views:
  - 1216
dsq_thread_id:
  - 246783918
categories:
  - FreeBSD
  - www
tags:
  - FreeBSD
  - ipfw

---
今天終於搞定了這張網卡，同樣的 DWL-G520 有兩種版本，一個是 Atheros 另一個就是大廠 ralink 了，不過話說我自己已經把 Atheros 晶片的無線網卡實做過一個ap server了，其實也不難啦，不過之前在搞 ralink 的晶片的時候，是可以驅動，可是就是弄不起來ap，後來怎麼解覺得呢，那就是換freebsd的版本，我之前是在 FreeBSD 6.2 release 底下弄的，我換到 FreeBSD 6.2-STABLE-200709版本，就馬上抓到，然後就進行ap的架設，後來就成功了，相當爽，畢竟可以繼續惡搞其他東西了。 接下來教大家如何安裝了，系統配備如下 

  * 硬體：i386 PC Intel P4 1.6G
  * 記憶體：256M RAM
  * 網卡：2 片網卡 ( 一般 100M 網卡 + 一片 D-Link DWL-G520 54G無線網卡 )
  * 作業系統：FreeBSD 6.2 Stable

<!--more--> 1. 首先我們準備兩張網卡，第一有線網卡做對外，然後無限網卡做對內，並且架設DHCP Server 這個可以省略，妳也可以直接設定內部ip，看妳怎麼設定了 首先我們要把freebsd支援無線網卡的module打開，並且把 pf 防火牆給啟動，所以必須編譯kernel 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/src/sys/i386/conf
vi GENERIC
#在最後面加上
# Ipfw
options IPFIREWALL
options IPFIREWALL_DEFAULT_TO_ACCEPT
options IPFIREWALL_VERBOSE
options IPFIREWALL_VERBOSE_LIMIT=10
options IPDIVERT

options ACCEPT_FILTER_HTTP
options ACCEPT_FILTER_DATA

#  wireless suport
device ath
device ath_hal
device ath_rate_sample
device wi
device wlan
device wlan_wep
device wlan_ccmp
device wlan_tkip
device wlan_xauth
device wlan_acl
#  packet filter firewall suport
device      pf
device      pflog
device      pfsync
options     ALTQ
options     ALTQ_CBQ

#儲存 :wq!
#然後開始編譯kernel
config GENERIC       
#  一切就緒開始編譯核心
cd ../compile/GENERIC
make cleandepend; make depend all install      
</pre> 然後在開機自動載入module 

<pre class="brush: bash; title: ; notranslate" title="">vi /boot/loader.conf        #  讓開機就自動載入無線網路的 funtion

wlan_wep_load="YES"
wlan_tkip_load="YES"
wlan_ccmp_load="YES"
wlan_xauth_load="YES"
wlan_acl_load="YES"
</pre> 設定啟動 Packet Filter 之 ( NAT ) 及 ( 防火牆 ) 功能 

<pre class="brush: bash; title: ; notranslate" title="">#vi /etc/sysctl.conf #  開啟 NAT 功能讓封包可轉出去

net.inet.ip.forwarding=1
net.inet.ip.fastforwarding=1

#vi /etc/inetd.conf #  開啟 ftp 代理，這是 PF 比較特殊的一點，一定要開啟這個 Intranet 的 ftp client 才能出得去
#這個如果妳沒用到的話，其實也不必設定，因為也沒關西

ftp-proxy   stream  tcp nowait  root/usr/libexec/ftp-proxy  ftp-proxy

#vi /etc/pf.conf  # 加入 PF 防火牆之規則，因為我們只做基本測試所以防火牆規則全開，若要更多的限制請自己學習 PF 規則。

ext_if="rl0"
int_if="ral0"

#
nat on $ext_if from $int_if:network to any -> ($ext_if)
rdr on $int_if proto tcp from any to any port 21 -> 127.0.0.1 port 8021

#
pass in all
pass out all
</pre> 架設 DHCP Server 自動發放 IP 給 Wireless LAN ral0 

<pre class="brush: bash; title: ; notranslate" title="">#cd /usr/ports/net/isc-dhcp3-server       #  安裝設定 ISC 版本的 DHCP Server
#make install clean
#cd /usr/local/etc
#cp dhcpd.conf.sample dhcpd.conf
#true > dhcpd.conf      #  清掉裡面的設定值我要自行寫入
#vi dhcpd.conf
default-lease-time 6000;
max-lease-time 7200;
option subnet-mask 255.255.255.0;
option domain-name-servers 140.123.106.13,168.95.1.1;
option domain-name "ee.ccu.edu.tw";
option routers 192.168.1.254;
option broadcast-address 192.168.1.255;
option interface-mtu 1500;
option perform-mask-discovery on;
option mask-supplier on;
ddns-update-style none;
#  Wireless LAN 自動發放 IP 的區段
subnet 192.168.1.0 netmask 255.255.255.0 {
option routers 192.168.1.254;
option broadcast-address 192.168.1.255;
range 192.168.1.50 192.168.1.200;
}
subnet 140.123.107.0 netmask 255.255.255.0 {
}

#route add -host DHCP -interface ath0       #  指定 Wireless LAN ath0 提供 DHCP 服務
</pre> #vi /etc/rc.conf # 增加開機自動啟動的服務項目 

<pre class="brush: bash; title: ; notranslate" title="">defaultrouter="140.123.107.249"
hostname="ixp.cn.ee.ccu.edu.tw"
ifconfig_rl0="inet 140.123.107.54  netmask 255.255.255.0"
inetd_enable="YES"
sshd_enable="YES"
usbd_enable="YES"
# added by xorg-libraries port
local_startup="/usr/local/etc/rc.d"
ifconfig_ral0="inet 192.168.1.254  netmask 255.255.255.0"
pf_enable="YES"
pflog_enable="YES"
dhcpd_enable="YES"
</pre> 開起 Wireless LAN 卡運行 Access Point 模式 #ifconfig ral0 ssid Appleboy-Ralink channel 6 mode 11g mediaopt hostap # 採用一般無加密方式任何人只要搜尋到 SSID 就可使用 #ifconfig ral0 ssid Appleboy-Ralink wepmode on wepkey 12345 mode 11g mediaopt hostap # 採用 WEP 一般 ASCII 64 bit 加密模式 只要輸入 5 碼數字的密碼即可 #ifconfig ral0 ssid Appleboy-Ralink wepmode on wepkey 0x1234567890 mode 11g mediaopt hostap # 採用 WEP 16 進位 64 bit 加密模式則要輸入 0x 再加 10 碼數字 

[<img src='https://i0.wp.com/blog.wu-boy.com/wp-content/uploads/2007/10/ralink-ap.thumbnail.jpg?w=840' alt='ap' data-recalc-dims="1" />][1] 大致上是如此，不過話說我在 6.2 release 的系統無法抓到這張網卡，所以我又參考了底下文章，就可以上網了，但是我測試過無法架設ap [FreeBSD Driver for Ralink RT2561][2] 裡面的driver patch 我也放在我這裡一份 [if_ral.diff][3] reference: [自行架設 FreeBSD 無線防火牆 + 無線 AP ( Access Point )][4] [*BSD driver for Ralink RT2500/RT2600 chipsets][5]

 [1]: https://i1.wp.com/blog.wu-boy.com/wp-content/uploads/2007/10/ralink-ap.jpg "ap"
 [2]: http://blog.monkeybiz.info/2007/05/freebsd-driver-for-ralink-rt2561.html
 [3]: http://blog.wu-boy.com/wp-content/uploads/2007/10/if_raldiff.txt "if_ral.diff"
 [4]: http://freebsd.ntut.idv.tw/document/freebsd_wireless_ap.html
 [5]: http://damien.bergamini.free.fr/ral/