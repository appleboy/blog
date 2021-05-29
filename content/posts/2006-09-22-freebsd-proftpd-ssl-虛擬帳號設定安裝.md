---
title: '[FreeBSD] Proftpd + SSL 虛擬帳號設定安裝'
author: appleboy
type: post
date: 2006-09-22T08:41:53+00:00
url: /2006/09/freebsd-proftpd-ssl-虛擬帳號設定安裝/
bot_views:
  - 733
views:
  - 4364
dsq_thread_id:
  - 247289938
categories:
  - FreeBSD
tags:
  - Linux
  - proftpd
  - Ubuntu

---
系統 ubuntu 6.06 + proftpd 1.2.10 

<pre class="brush: bash; title: ; notranslate" title="">TLSEngine on
TLSLog /var/log/proftpd-tls.log
TLSProtocol TLSv1
TLSRequired on
TLSRSACertificateFile /etc/proftpd/HostCA.crt
TLSRSACertificateKeyFile /etc/proftpd/HostCA.key
TLSCACertificateFile /etc/proftpd/RootCA.crt
TLSVerifyClient off</pre> 虛擬帳號實做 

<pre class="brush: bash; title: ; notranslate" title="">AuthUserFile /etc/proftpd/proftpd.passwd
AuthGroupFile /etc/proftpd/proftpd.group
SystemLog /etc/proftpd/proftpd.syslog 

TransferLog /var/log/xferlog
LogFormat awstats "%t %h %u %m %f %s %b"
ExtendedLog /var/log/xferlog read,write awstats</pre> 在linux底下如何新增帳號： 

<pre class="brush: bash; title: ; notranslate" title="">ftpasswd --passwd --file=/etc/proftpd/proftpd.passwd --name=test --uid=2000 --gid=1001 --home=/home/ftp --shell=/bin/false</pre>