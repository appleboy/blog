---
title: '[apache] mod cband 頻寬限制'
author: appleboy
type: post
date: 2007-01-22T16:09:27+00:00
url: /2007/01/apache-mod-cband-頻寬限制/
views:
  - 6827
bot_views:
  - 1250
dsq_thread_id:
  - 246997135
categories:
  - apache
  - Linux
  - Network
  - windows
tags:
  - apache
  - FreeBSD
  - Linux

---
這個MODULE相當好用,這個可以用來解決架設APACHE頻寬問題 安裝方式: 

> For Linux: 先去下載軟體: mod\_cband 目前釋出到 0.9.7.5版 下載到 /tmp/ 資料夾裡面 解壓縮: tar -zxvf mod-cband-0.9.7.5.tgz 如果你有安裝 apsx2的話 請用下面安裝 $ cd mod-cband-0.9.7.5 $ ./configure $ make $ make install 如果沒有安裝 apsx2的話 請用下面安裝 重新編譯 configure –add-module=../mod-cband/mod\_cband.c –enable-shared=cband –enable-module=so 設定方法: \* 修改httpd.conf 加上2行CBandScoreFlushPeriod 1 CBandRandomPulse On mkdir /var/www/scoreboard chown apache:apache /var/www/scoreboard \* 設定 VirtualHost <VirtualHost 1.2.3.4> ServerName www.example.com ServerAdmin webmaster@example.com DocumentRoot /var/www CBandSpeed 1024 10 30 CBandRemoteSpeed 20kb/s 3 3 </VirtualHost> 說明:# 100MB virtualhost bandwidth limit CBandLimit 100M # Maximal 1024kbps speed for this virtualhost # Maximal 10 requests per second for this virtualhost # Maximal 30 open connections for this virtualhost限制該網域總頻寬跟連線數目 CBandSpeed 1024 10 30# Maximal 10kB/s speed, 3 requests/s and 2 open connections for any remote client CBandRemoteSpeed 10kb/s 3 2 4個禮拜清除設定一次# a period of time after which the scoreboard will be cleared (4 weeks) CBandPeriod 4W # define ‘class_1′ <CBandClass class_1> CBandClassDst 217.172.231.67 CBandClassDst 127/8 CBandClassDst 192.168.0.0/24 CBandClassDst 10.0.0.20 </CBandClass> # define ‘class_2′ <CBandClass class_2> CBandClassDst 192.168.100.100 CBandClassDst 153.19/16 </CBandClass> <CBandUser dembol> CBandUserLimit 1000000 CBandUserExceededURL http://edns.pl/bandwidth\_exceeded.html CBandUserScoreboard /home/dembol/write/user.dembol.scoreboard# 500MB limit for ‘class\_2′ CBandUserClassLimit class_2 500000 </CBandUser> 實作部份: <CBandClass local_class> CBandClassDst 127/8 CBandClassDst 192.168.0.0/24 </CBandClass> <VirtualHost *:80> ServerAdmin appleboy.tw@gmail.com DocumentRoot /var/www/html ServerName nas.th.gov.tw ErrorLog logs/nas.th.gov.tw-error\_log CustomLog logs/nas.th.gov.tw-access\_log common CBandSpeed 1024 200 200 CBandRemoteSpeed 1024kb/s 50 50 CBandClassRemoteSpeed local_class 1000Gbps 1000 1000 CBandLimit 10G CBandPeriod 1W CBandScoreboard /var/run/apache2/default.scoreboard </VirtualHost> 如果要看SERVER-Status的話 也可以設定在httpd.conf就好 # # mod_cband # <Location /cband-status> SetHandler cband-status </Location>