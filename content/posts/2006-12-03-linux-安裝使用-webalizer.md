---
title: '[Linux] 安裝使用 Webalizer'
author: appleboy
type: post
date: 2006-12-03T10:05:00+00:00
url: /2006/12/linux-安裝使用-webalizer/
views:
  - 5397
bot_views:
  - 653
dsq_thread_id:
  - 246737885
categories:
  - Linux
  - Network

---
系統：CentOS 4.4 搜尋 Webalizer 

> \[root@NAS\]\[~\][17:52:51]# yum search webalizer Searching Packages: Setting up repositories Reading repository metadata in from local files webalizer.x86\_64 2.01\_10-25 base Matched from: webalizer The Webalizer is a Web server log analysis program. It is designed to scan Web server log files in various formats and produce usage statistics in HTML format for viewing through a browser. It produces professional looking graphs which make analyzing when and where your Web traffic is coming from easy. http://www.mrunix.net/webalizer/ 設定檔放在 /etc/webalizer.conf 我的設定如下 

> LogFile /var/log/httpd/access\_log OutputDir /var/www/html/webalizer HistoryName /var/lib/webalizer/webalizer.hist Incremental yes IncrementalName /var/lib/webalizer/webalizer.current HostName NAS.th.gov.tw PageType htm\* PageType cgi PageType php PageType shtml DNSCache /var/lib/webalizer/dns\_cache.db DNSChildren 10 Quiet yes FoldSeqErr yes HideURL \*.gif HideURL \*.GIF HideURL \*.jpg HideURL \*.JPG HideURL \*.png HideURL \*.PNG HideURL \*.ra SearchEngine yahoo.com p= SearchEngine altavista.com q= SearchEngine google.com q= SearchEngine eureka.com q= SearchEngine lycos.com query= SearchEngine hotbot.com MT= SearchEngine msn.com MT= SearchEngine infoseek.com qt= SearchEngine webcrawler searchText= SearchEngine excite search= SearchEngine netscape.com search= SearchEngine mamma.com query= SearchEngine alltheweb.com query= SearchEngine northernlight.com qr=<!--more--> apache 設定安全目錄 

> <Directory &#8220;/var/www/html/webalizer&#8221;> Options None AllowOverride None Order deny,allow Allow from 192.168.130.211 192.168.160.109 </Directory>  新增資料夾 

> mkdir /var/www/html/webalizer 然後請執行 

> /usr/bin/webalizer -c /etc/webalizer.conf 如果沒有顯示什麼訊息 表示成功了 設定crontab ..讓它每二小時跑一次: 

> \# #run apache log # 00 \*/2 \* \* \* root /usr/bin/webalizer -c /etc/webalizer.conf[<img src="https://i2.wp.com/static.flickr.com/116/312722925_0c7283c846.jpg?resize=500%2C324" alt="Webalizer" data-recalc-dims="1" />][1] 如何觀看 Webalizer <http://forum.webdsn.net/showthread.php?p=1221>

 [1]: https://www.flickr.com/photos/appleboy/312722925/ "Photo Sharing"