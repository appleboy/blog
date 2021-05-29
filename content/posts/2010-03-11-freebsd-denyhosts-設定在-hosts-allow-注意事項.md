---
title: '[FreeBSD] DenyHosts 設定在 hosts.allow 注意事項'
author: appleboy
type: post
date: 2010-03-11T10:13:29+00:00
url: /2010/03/freebsd-denyhosts-設定在-hosts-allow-注意事項/
views:
  - 4539
bot_views:
  - 452
dsq_thread_id:
  - 247445822
categories:
  - FreeBSD
  - Linux
tags:
  - DenyHost
  - FreeBSD
  - Linux
  - SSH

---
[<img src="https://i1.wp.com/farm5.static.flickr.com/4062/4424616360_8f2af7881e_o.png?resize=347%2C73&#038;ssl=1" alt="denyhosts" data-recalc-dims="1" />][1] [DenyHosts][2] 是一套用 [Python][3] 跟 shell script 寫出來的 open source base on Linux or FreeBSD (/var/log/secure on Redhat, /var/log/auth.log on Mandrake, FreeBSD, etc...)，用來阻擋 SSH Server 被攻擊，之前寫一篇 <a href="http://blog.wu-boy.com/2008/12/26/663/" alt="[FreeBSD]利用 DenyHosts 軟體擋掉暴力破解 ssh 的使用者">FreeBSD 安裝設定教學</a>，有一點沒有注意到，就是打開 /etc/hosts.allow，注意要把 ALL : ALL : allow 放到最後一行，跟 iptables 設定原理是一樣的，會從第一條規則開始比對，如果比對成功，下面的 rule 就會略過比對了，參考英文說明： 

> Start by allowing everything (this prevents the rest of the file from working, so remove it when you need protection). The rules here work on a "First match wins" basis. /etc/hosts.deny 已經被 FreeBSD 棄用，所以必須把 allow 跟 deny 的 rule 都寫到 hosts.allow 檔案裡面才是正確的 

<pre class="brush: bash; title: ; notranslate" title="">#
# DenyHosts file: /etc/hosts.deniedssh
sshd : /etc/hosts.deniedssh : deny
sshd : ALL : allow

# Start by allowing everything (this prevents the rest of the file
# from working, so remove it when you need protection).
# The rules here work on a "First match wins" basis.
# move bottom by appleboy 2010.03.11
ALL : ALL : allow</pre>

 [1]: https://www.flickr.com/photos/appleboy/4424616360/ "Flickr 上 appleboy46 的 denyhosts"
 [2]: http://denyhosts.sourceforge.net/
 [3]: http://www.python.org/