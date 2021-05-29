---
title: '[Ubuntu]  開機自動執行script'
author: appleboy
type: post
date: 2006-10-21T22:33:49+00:00
url: /2006/10/ubuntu-開機自動執行script/
views:
  - 6857
bot_views:
  - 856
dsq_thread_id:
  - 246729417
categories:
  - Linux
tags:
  - Linux
  - Ubuntu

---
因為在安裝 maple bbs 的時候 發現itoc的方式沒辦法解決開機自動執行 沒有 inetd.conf 也沒有 xinetd 的方式 ，所以利用下面方式才可以達成 我是增加一個檔案 /etc/init.d/bbsd 然後增加以下內容 &#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8211; 

> #!/bin/sh # # MapleBBS # su bbs -c &#8216;/home/bbs/bin/camera&#8217; su bbs -c &#8216;/home/bbs/bin/account&#8217; /home/bbs/bin/bbsd /home/bbs/bin/bmtad /home/bbs/bin/bpop3d /home/bbs/bin/gemd /home/bbs/bin/bguard /home/bbs/bin/xchatd /home/bbs/innd/innbbsd &#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212; 

> chmod 755 /etc/init.d/bbsd 然後 cd /etc 

> update-rc.d bbsd defaults 90 <span class="postbody">90為開機時的執行順序, 端看您如何設定.</span> update-rc.d會自動幫各個rcX.d目錄下建立一link至/etc/init.d/執行檔 或者是 <span class="postbody">update-rc.d iptables start 20 2 3 4 5 . stop 0 1 6 .</span> 後面有一個點喔  <span class="postbody">2.3.4.5 是指 rcX.d 複製到底下 當開機run level 2.3.4.5 當開機run level的話才會執行 該執行檔</span>