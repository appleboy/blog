---
title: '[FreeBSD]利用 DenyHosts 軟體擋掉暴力破解 ssh 的使用者'
author: appleboy
type: post
date: 2008-12-26T04:48:00+00:00
url: /2008/12/freebsd利用-denyhosts-軟體擋掉暴力破解-ssh-的使用者/
views:
  - 15012
bot_views:
  - 2079
dsq_thread_id:
  - 246687498
categories:
  - FreeBSD
  - Linux
tags:
  - DenyHost
  - FreeBSD
  - Linux
  - SSH

---
不管是架設好 Linux 跟 [FreeBSD][1] 通常都會有國外的 hacker 來 try 機器的 SSH 帳號密碼，我想這是很正常的，網路上也提供很多方法來分析 Log 檔，[FreeBSD][1]：/var/log/auth.log，我可以分析檔案，然後再利用 firewall like ipfw or pf 的方式來達到，或者是利用寫到 /etc/hosts.deny 來達到 Block 的功能，網路上有很多工具可以用，例如 [DenyHosts][2]，[sshguard][3] 或者是 [sshit][4]，可以參考我之前寫的一篇[利用 sshit 來達到阻擋 ssh 使用者][5]，然而今天來介紹一下 DenyHosts 再 FreeBSD 底下如何設定，還蠻方便的。 首先利用 ports 安裝，[DenyHosts][2] 是利用 [python][6] 的程式語言寫出來的： 

<pre class="brush: bash; title: ; notranslate" title="">Port:   denyhosts-2.6_2
Path:   /usr/ports/security/denyhosts
Info:   Script to thwart ssh attacks
Maint:  janos.mohacsi@bsd.hu
B-deps: python25-2.5.2_3
R-deps: python25-2.5.2_3
WWW:    http://denyhosts.sourceforge.net/

/* 利用 ports 安裝 */
cd /usr/ports/security/denyhosts; make install clean
</pre>

<!--more--> 安裝好之後接下來設定系統 

<pre class="brush: bash; title: ; notranslate" title="">#
# 在 /etc/rc.conf 加入 denyhosts_enable="YES"
#
denyhosts_enable="YES"
#
# 編輯 /etc/hosts.allow 加入
#
sshd : /etc/hosts.deniedssh : deny
sshd : ALL : allow
#
# 假如 /etc/hosts.deniedssh 不存在，那就新增一個
#
touch /etc/hosts.deniedssh</pre> 接下來就是設定 /usr/local/etc/denyhosts.conf 

<pre class="brush: bash; title: ; notranslate" title="">#
# 設定需要分析 Log 檔案位置
#
# FreeBSD or OpenBSD
SECURE_LOG = /var/log/auth.log
# Redhat or Fedora Core:
#SECURE_LOG = /var/log/secure
# SuSE:
#SECURE_LOG = /var/log/messages

#
# 我們要阻擋的 IP 寫入到的檔案
#
HOSTS_DENY = /etc/hosts.deniedssh
#
# 我們要清除 hosts.deniedssh 裡面的 entries
#            'm' = minutes
#            'h' = hours
#            'd' = days
#            'w' = weeks
#            'y' = years
# 格式：i[dhwmy] i 是數字
PURGE_DENY = 5d
#
# 我們要阻擋的服務：sshd
#
BLOCK_SERVICE  = sshd
#
# 如果該帳號不存在 /etc/passwd 嘗試超過5次失敗，就阻擋該ip登入此服務
#
DENY_THRESHOLD_INVALID = 5
#
# 如果該帳號存在 /etc/passwd 嘗試超過10次失敗，就阻擋該ip登入此服務
#
DENY_THRESHOLD_VALID = 10
#
# 阻擋 root 帳號錯誤登入次數，不過這對 FreeBSD 沒影響
# 因為 FreeBSD 架設完成，是不能遠端利用 root 登入的
DENY_THRESHOLD_ROOT = 1
#
# 把 deny 的 host 或者是 ip 紀錄到 Work_dir 裡面
# 盡量把這資料夾改變到 root 帳號以外不能存取的地方
#
WORK_DIR = /usr/local/share/denyhosts/data
#
# 設定 deny host 寫入到該資料夾
#
DENY_THRESHOLD_RESTRICTED = 1
#
# 當 DenyHOts 啟動的時候寫入 pid，已確保服務正確啟動，防止同時啟動多個服務
#
LOCK_FILE = /var/run/denyhosts.pid
#
# 這裡可以設定 denyhost 寄發 email 給管理者
#
ADMIN_EMAIL = xxxx@gmail.com
#
# 如果設定了 ADMIN_EMAIL 下面就要設定 smtp 的 host
#
SMTP_HOST = localhost
SMTP_PORT = 25
# 發信的 header
SMTP_FROM = DenyHosts &lt;nobody@localhost>
# 發信標題
SMTP_SUBJECT = DenyHosts Report
#
# DenyHosts log 紀錄檔案
#
DAEMON_LOG = /var/log/denyhosts</pre> 這樣大致上完成了。 參考相關網站： 

[擋掉用ssh try 帳密的人][7] [最好的阻止SSH暴力破解的方法(DenyHosts)][8] [用 Deny Hosts 保護你的 Linux 伺服器][9]

 [1]: http://www.freebsd.org/
 [2]: http://denyhosts.sourceforge.net/
 [3]: http://sshguard.sourceforge.net/
 [4]: http://anp.ath.cx/sshit/
 [5]: http://blog.wu-boy.com/2006/11/04/31/
 [6]: http://www.python.org/
 [7]: http://wufish.blogspot.com/2007/09/ssh-try.html
 [8]: http://chengavin.blogspot.com/2008/10/sshdenyhosts.html
 [9]: http://blog.miniasp.com/?tag=/denyhosts