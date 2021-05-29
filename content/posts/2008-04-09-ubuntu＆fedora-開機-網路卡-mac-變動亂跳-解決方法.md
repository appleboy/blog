---
title: '[Ubuntu＆Fedora] 開機 網路卡 MAC 變動亂跳 [解決方法]'
author: appleboy
type: post
date: 2008-04-09T06:35:59+00:00
url: /2008/04/ubuntu＆fedora-開機-網路卡-mac-變動亂跳-解決方法/
views:
  - 5124
bot_views:
  - 788
dsq_thread_id:
  - 246931233
categories:
  - Linux
  - Ubuntu
tags:
  - Fedora
  - Linux
  - Ubuntu

---
最近在幫 lab 同學處理他安裝好的 [ubuntu][1] linux，結果發現一個問題，就是只要重新開機，網路卡的 mac 就會改變，還真是奇怪，後來在 google 找到一篇文章：[Ubuntu的MAC一直亂跳嗎?][2] 或者是ubuntu官方論壇：[解決方法][3]，才終於解決這個問題。 在主機板 GA-M56S-S3 這個系列板子都會有這種問題，至少我測試過兩張主機板都會這樣，所以看了那些解決方法，可以解決 ubuntu 的問題，但是不能解決 fedora core 的問題，我解決 fedora 的方法，其實很簡單，只要你會利用文字介面設定網路，就可以了 fedora 解法：前提是你不會讓機器開機亂跳動 ethx，所以你要按照上面的解法，解決前半部份 先在 root 底下新增一個檔案 ifcfg-eth0，然後寫入 

<pre class="brush: bash; title: ; notranslate" title=""># Broadcom Corporation NetXtreme BCM5721 Gigabit Ethernet PCI Express
DEVICE=eth0
BOOTPROTO=none
BROADCAST=140.123.107.255
HWADDR=00:15:F2:A7:37:42
IPADDR=140.123.107.*
IPV6_AUTOCONF=yes
NETMASK=255.255.255.0
NETWORK=140.123.107.0
ONBOOT=yes
GATEWAY=140.123.107.249
TYPE=Ethernet
</pre>

<!--more--> 在 /etc/rc.local 裡面寫入 

<pre class="brush: bash; title: ; notranslate" title="">#
# 兩種方法，一種用 ip 另一種用 ifconfig
#
ip link set eth0 down
ip link set eth0 address 00:15:F2:A7:37:42
ip link set eth0 up

ifconfig eth0 down
ifconfig eth0 hw ether 00:15:F2:A7:37:42
ifconfig eth0 up
#
# 停止網路
#
/etc/init.d/network stop

#
# 寫入檔案
#
cat /root/ifcfg-eth0 > /etc/sysconfig/network-scripts/ifcfg-eth0

#
# 啟動網路
#
/etc/init.d/network start
</pre> 這樣就可以解決了

 [1]: http://www.ubuntu.org.tw/
 [2]: http://www.karayou.com/redirect.php?tid=206006&goto=lastpost
 [3]: http://ubuntuforums.org/showthread.php?p=4156690#post4156690