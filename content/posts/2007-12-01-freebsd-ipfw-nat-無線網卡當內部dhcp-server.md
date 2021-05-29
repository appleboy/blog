---
title: '[FreeBSD] ipfw + Nat 無線網卡當內部DHCP Server'
author: appleboy
type: post
date: 2007-12-01T07:46:02+00:00
url: /2007/12/freebsd-ipfw-nat-無線網卡當內部dhcp-server/
views:
  - 3696
bot_views:
  - 2009
dsq_thread_id:
  - 246703956
categories:
  - FreeBSD
tags:
  - FreeBSD

---
之前在寫 [[FreeBSD] 無線網卡架設AP Server DWL-G520 Ralink RT2561][1] 這篇的時候，是利用 pf 當作防火牆，可是我偏好使用 ipfw 來作防火牆的工作，所以今天研究一下 nat 的作法，ipfw Firewall 設定方法。 請先參考設定 IPFW 編譯核心：[[FreeBSD] 系統核心支援ipfw 更新kernel][2] 

  * 系統：FreeBSD 6.2-RELEASE or STABLE 200709 
  * 網卡：一張有線網卡，另一張無線網卡 目前的架構，一張有線網卡對外，然後無線網卡對內，架設dhcp伺服器，提供ap的功能，會加上 802.1X 認證，這我晚一點會寫教學 目前要先修改 /etc/rc.conf 

<pre class="brush: bash; title: ; notranslate" title=""># 第一片網卡固有的設定：
ifconfig_rl0="inet 140.123.107.XX netmask   255.255.255.0"

# 只用一片網卡時，將第一片網卡虛擬出另一個IP(如果使用兩片網卡，就不要設這一行，或者註解起來也可)。
ifconfig_rl0_alias0="inet   192.168.1.254 netmask   255.255.255.0"

# 如果你有第二片網卡時，將此網卡設定如下(當然啦，這一行的註解就應該取消，第二塊網卡才會有作用)。
# ifconfig_ral0="inet   192.168.1.254 netmask   255.255.255.0"

# 宣告本主機可做為gateway(通訊閘)
gateway_enable="YES"

# 宣告防火牆(IP-FIREWALL)
firewall_enable="YES"
firewall_type="simple"
firewall_quiet="YES"
tcp_extensions="YES"

# 定義 NATD 的網路卡介面，應定義在設定 public IP 的網卡代號上。
natd_interface="vr0"
natd_enable="YES"
</pre> 然後 /etc/netstart 重新啟動網卡 再來是設定防火牆 ipfw 檔案在 /etc/rc.firewall 先備份原來的檔案 cp /etc/rc.firewall /etc/rc.firewall.bak 然後修改 /etc/rc.firewall 

<pre class="brush: bash; title: ; notranslate" title="">此設定是限制192.168.1.~254 整個網域,server DHCP ip 是設192.168.1.254

#!/bin/sh

/sbin/ipfw -f flush

/sbin/ipfw add pass all from 127.0.0.1 to 127.0.0.1 //設定server本機可以跟server本機通訊

/sbin/ipfw add divert natd all from any to any via rl0 //設定nat可以任何通行

/sbin/ipfw add pass all from 127.0.0.1 to any //讓本機可以通行到任何地方

/sbin/ipfw add pass all from 192.168.1.255 to any //如果有設dhcp一定要設這行

/sbin/ipfw add pass all from 192.168.1.1/24 to 192.168.1.254 //讓內部ip全部可以連上本機

/sbin/ipfw add pass all from 192.168.1.1/24 to 168.95.1.1 //開放hinet dns給使用者

#開放所有通行給該ip

/sbin/ipfw add pass all from 192.168.1.1 to any

/sbin/ipfw add pass all from 192.168.1.2 to any

/sbin/ipfw add pass all from 192.168.1.3 to any

/sbin/ipfw add deny all from 192.168.1.1/24 to 140.112.90.74
/sbin/ipfw add deny all from 192.168.1.1/24 to 140.112.90.72

# ================
# 其餘的(all)都放行了，NAT 和 FireWall 都需要設定這一行。
/sbin/ipfw   add   pass   all   from   any   to   any
</pre> 這樣大致上就ok了～

 [1]: http://blog.wu-boy.com/2007/10/22/122/
 [2]: http://blog.wu-boy.com/2006/10/29/28/