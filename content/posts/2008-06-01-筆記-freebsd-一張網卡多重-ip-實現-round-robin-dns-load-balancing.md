---
title: '[筆記] FreeBSD 一張網卡多重 ip 實現 Round Robin DNS Load Balancing'
author: appleboy
type: post
date: 2008-06-01T03:34:57+00:00
url: /2008/06/筆記-freebsd-一張網卡多重-ip-實現-round-robin-dns-load-balancing/
views:
  - 8014
bot_views:
  - 956
dsq_thread_id:
  - 247206777
categories:
  - DNS
  - FreeBSD
  - Linux
  - www
tags:
  - DNS
  - FreeBSD
  - ip
  - Load Balancing

---
來紀錄一下好了，其實這兩年前，我自己就試過了，當時在弄 web 系統 Load Balancing，因為找不到更好的方法，所以使用 Round Robin DNS Load Balancing 技術來達到這功能，可是當然這不是很準確的做到 load balance，只是能解決暫時性的問題，真正要做到 Load Balancing 可能要靠硬體的技術了。 我自己是在 FreeBSD 系統上面實做的，當然弄 Load Balancing 一定要在網卡上面綁定多重ip，Linux 作法跟 FreeBSD 不大相同 

<pre class="brush: bash; title: ; notranslate" title="">#
# Linux 作法
#
ifconfig eth0:0 inet xxx.xxx.xxx.xx(1~9) netmask 255.255.255.0 broadcast xxx.xxx.xxx.255</pre>

<pre class="brush: bash; title: ; notranslate" title="">#
# FreeBSD 作法
#
# /etc/rc.conf - add a new IP address to the NIC
# 在 rc.conf 加入底下 entry
ifconfig_rl0_alias0="192.168.0.57 netmask 0xffffffff" 
#
# 指令
#
ifconfig rl0 alias 192.168.0.57 netmask 0xffffffff
 </pre>

<!--more--> 利用 Round Robin DNS Load Balancing 技術達到分流，有兩種作法，一種使用 CNAME 另一種就是 A record 1.DNS load balancing implementation (Multiple CNAMES) 先在正解設定檔裡面加入： 

<pre class="brush: bash; title: ; notranslate" title="">srv1 IN A 123.45.67.1
srv2 IN A 123.45.67.2
srv3 IN A 123.45.67.3
srv4 IN A 123.45.67.4</pre> 然後在使用 CNAME 

<pre class="brush: bash; title: ; notranslate" title="">www IN CNAME srv1.domain.tld.
IN CNAME srv2.domain.tld.
IN CNAME srv3.domain.tld.
IN CNAME srv4.domain.tld. </pre> 然後在 named.conf 加入底下設定 [ For BIND 8 name servers ] 

<pre class="brush: bash; title: ; notranslate" title="">options {
multiple-cnames yes;
}; </pre> 2.DNS load balancing implementation (Multiple A Records) 我是用此方法： 

<pre class="brush: bash; title: ; notranslate" title="">www.domain.tld. 60 IN A 123.45.67.1
www.domain.tld. 60 IN A 123.45.67.2
www.domain.tld. 60 IN A 123.45.67.3
www.domain.tld. 60 IN A 123.45.67.4</pre> 這樣上面的 server 就會互相轉換，非常方便，我是用此方法，TTL 60 這個可以在設定短一點，這樣他在切換的速度會更快喔 相關網站： 

[=http://blog.wu-boy.com/2007/03/11/74][1][www] 網站分流問題[/url] 參考網站： http://www.freebsddiary.org/ip-address-change.php http://bbs.linuxsky.org/thread-638-1-5.html http://content.websitegear.com/article/load\_balance\_dns.htm

 [1]: http://blog.wu-boy.com/2007/03/11/74