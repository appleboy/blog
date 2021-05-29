---
title: '[FreeBSD] freebsd kernel: fxp0: link state changed to DOWN / UP'
author: appleboy
type: post
date: 2009-12-10T03:00:15+00:00
url: /2009/12/freebsd-freebsd-kernel-fxp0-link-state-changed-to-down-up/
views:
  - 4182
bot_views:
  - 325
dsq_thread_id:
  - 249090818
categories:
  - FreeBSD
tags:
  - FreeBSD

---
這一個禮拜被機器弄的頭昏腦脹，突然網路斷掉，然後不知不覺中又好了，接下來是斷斷續續，時好時壞，所以去檢查看一下 /var/log/message 訊息，log 檔案吐出很多底下的資訊： 

> Dec 9 21:17:02 freebsd kernel: fxp0: link state changed to DOWN Dec 9 21:17:03 freebsd kernel: fxp0: link state changed to UP Dec 9 21:17:10 freebsd kernel: fxp0: link state changed to DOWN Dec 9 21:17:12 freebsd kernel: fxp0: link state changed to UP 在網路上 [FreeBSD][1] mail list 查到一篇：『[Interface Status changes to UP and Down][2]』，裡面提到通常是硬體的問題，換過 switch 以及網路線，測試還是有問題，網路會斷斷續續，後來就用主機板上面另外兩個網孔測試，網路就不會時好時壞了，由於時常更改 /etc/rc.conf 裡面的 ip 設定，要重新啟動網路卡介面，這樣會造成遠端 ssh 斷線，解決方式請用下面指令： **How do I restart network service over ssh session?** 

<pre class="brush: bash; title: ; notranslate" title="">/etc/rc.d/netif restart && /etc/rc.d/routing restart</pre> 底下一些常用 FreeBSD 網路指令： 

<pre class="brush: bash; title: ; notranslate" title="">#關閉網卡
ifconfig network-interface down
#啟動網卡
ifconfig network-interface up
#觀看尚未啟動的網卡
ifconfig -d
#觀看已啟動網卡
ifconfig -u
# FreeBSD Update / restart routing tables / service
/etc/rc.d/routing restart</pre> Reference 

[FreeBSD: How To Start / Restart / Stop Network and Routing Service][3] [FreeBSD IP Alias: Setup 2 or More IP address on One NIC][4]

 [1]: http://www.freebsd.org
 [2]: http://lists.freebsd.org/pipermail/freebsd-net/2007-September/015237.html
 [3]: http://www.cyberciti.biz/tips/freebsd-how-to-start-restart-stop-network-service.html
 [4]: http://www.cyberciti.biz/tips/freebsd-how-to-setup-2-ip-address-on-one-nic.html