---
title: '[FreeBSD] 安裝 sshit 設定教學'
author: appleboy
type: post
date: 2006-11-03T23:27:56+00:00
url: /2006/11/freebsd-安裝-sshit-設定教學/
views:
  - 4750
bot_views:
  - 1202
dsq_thread_id:
  - 250011611
categories:
  - FreeBSD
tags:
  - FreeBSD
  - ipfw
  - SSH

---
系統：FreeBSD 6.0-RELEASE 安裝方式： cd /usr/ports/security/sshit/ make install clean 設定檔 /usr/local/etc/sshit.conf # Sample configuration file of sshit.pl # We use pf as firewall on default 看你喜歡用什麼防火牆，我熟悉ipfw FIREWALL\_TYPE = ipfw # Number of failed login attempts within time before we block MAX\_COUNT = 3 # Time in seconds in which all failed login attempts must occur WITHIN\_TIME = 60 # Time in seconds to block ip in firewall 失敗後禁止登入幾秒鐘 RESET\_IP = 300 IPFW\_CMD = /sbin/ipfw # Make sure you don't have any important rules here already IPFW\_RULE\_START = 2100 IPFW\_RULE\_END = 3100 IPFW2\_CMD = /sbin/ipfw IPFW2\_TABLE\_NO = 0 PFCTL\_CMD = /sbin/pfctl PF\_TABLE = badhosts vi /etc/syslog.conf 加上 auth.info;authpriv.info |exec /usr/local/sbin/sshit 不過安裝好之後，照常裡來說可以使用，結果發現完全沒有效果 所以我去看了一下 sshit perl的這隻程式，跟官方網站提供的log檔資料 官方網log檔如下 Jul 23 05:30:51 sshd[36291]: <span style="color: red">Failed</span> password for root from 200.204.175.122 port 48830 ssh2 Jul 23 05:30:51 sshit.pl: BLOCKING 200.204.175.122, rule 2100FreeBSD auth.log 檔如下 

> Oct 30 06:53:07 bbs sshd[13935]: <span style="color: blue">error</span>: PAM: authentication error for illegal user test from 163.29.208.2 Oct 30 06:53:07 bbs sshd[13935]: Failed keyboard-interactive/pam for invalid user test from 163.29.208.2 port 48102 ssh2 Oct 30 06:53:07 bbs sshit.pl: BLOCKING 163.29.208.2, rule 2101 發現freebsd的log檔，格式跟官方網不一樣，所以程式是正確的 [ssh_patch檔][1]{#p75} [http://alumni.ee.ccu.edu.tw/~appleboy/patch/sshit_patch.txt][2] 自行修改主機的port，這是預設值 <a target="_blank" href="http://anp.ath.cx/sshit/">http://anp.ath.cx/sshit/</a> <a target="_blank" href="http://blog.gfchen.org/2006/01/22/248/">http://blog.gfchen.org/2006/01/22/248/</a>

 [1]: http://blog.wu-boy.com/wp-content/uploads/2007/03/sshit_patch.txt
 [2]: http://alumni.ee.ccu.edu.tw/~appleboy/patch/sshit_patch.txt "http://alumni.ee.ccu.edu.tw/~appleboy/patch/sshit_patch.txt"