---
title: '[FreeBSD] Smokeping 安裝 架設'
author: appleboy
type: post
date: 2007-04-28T13:29:02+00:00
url: /2007/04/freebsd-smokeping-安裝-架設/
views:
  - 5304
bot_views:
  - 903
dsq_thread_id:
  - 246934064
categories:
  - FreeBSD
  - Network

---
昨天看到 sayya 的 firedragen 個人版，看到 <a href="http://oss.oetiker.ch/smokeping/" target="_blank">smokeping</a> 的一些圖片，還蠻帥的，就想到要架設來玩看看 安裝方式如下： 

> \[FreeBSD\]\[root\][ ~ ]# cd /usr/ports/net/smokeping/ 進去之後 

> make install clean 然後底下是安裝好之後的訊息 

> NOTE: A set of sample configuration files have been installed: /usr/local/etc/smokeping/config /usr/local/etc/smokeping/smokemail /usr/local/etc/smokeping/basepage.html /usr/local/etc/smokeping/tmail You \*MUST\* edit these to suit your requirements. Please read the manpages &#8216;smokeping\_install&#8217; and &#8216;smokeping\_config&#8217; for further details on installation and configuration. If you are upgrading from a previous version of Smokeping, the manpage &#8216;smokeping\_upgrade&#8217; may be of help. Once configured, you can start SmokePing by adding: smokeping\_enable=&#8221;YES&#8221; to /etc/rc.conf, and then running, as root: /usr/local/etc/rc.d/smokeping start To enable Apache web access, add the following to your /usr/local/etc/apache/httpd.conf: ScriptAlias /smokeping.cgi /usr/local/smokeping/htdocs/smokeping.cgi Alias /smokeimg/ /usr/local/smokeping/htdocs/img/ 上面就是寫：請在 /etc/rc.conf 加入 smokeping_enable=&#8221;YES&#8221; 然後編輯 /usr/local/etc/apache/httpd.conf 在最後面加上 ScriptAlias /smokeping.cgi /usr/local/smokeping/htdocs/smokeping.cgi Alias /smokeimg/ /usr/local/smokeping/htdocs/img/ 修改 根目錄底下權限 Options Indexes FollowSymLinks ExecCGI 然後底下這段原本mark，請把他取消 AddHandler cgi-script .cgi 然後最後加上 <directory> Options Indexes FollowSymLinks ExecCGI AllowOverride Limit Order Deny,Allow Deny from all Allow from 192.168 </directory> 底下附上設定檔，DarkKiller 在 firedragen 版 的連結，不過連結已經失效，好顯自己有存檔 <http://blog.wu-boy.com/wp-content/uploads/2007/04/smokeping.txt> 最後 NCTU NetFlow&#8217;s somkeping demo: <a href="http://netflow.ntcu.net/smokeping/smokeping.cgi?target=Album" target="_blank">http://netflow.ntcu.net/smokeping/smokeping.cgi?target=Album</a>