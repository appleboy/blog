---
title: '[FreeBSD]快速利用 cvsup-mirror 架設 CVSup Server (mirror site)'
author: appleboy
type: post
date: 2009-01-06T13:22:04+00:00
url: /2009/01/freebsd快速利用-cvsup-mirror-架設-cvsup-server-mirror-site/
views:
  - 6174
bot_views:
  - 1364
dsq_thread_id:
  - 246785722
categories:
  - FreeBSD
tags:
  - FreeBSD

---
今天看到一篇：[[教學]用 cvsup-mirror 架設 CVSup Server (mirror site)][1]，自己就來架設一下，其實還蠻容易的，因為 FreeBSD Ports 都已經包好，所以安裝起來也不困難，利用 [cvsup-mirror][2] 這個軟體就可以架設完成了，那如何在台灣找尋一台最佳連線速度的 mirror 伺服器呢，利用 [fastest_cvsup][3] 這個 ports 軟體，就可以了，當 FreeBSD 剛安裝完成，就是要先設定 cvsup mirror 的站台，我自己都是用 cvsup.tw.freebsd.org，這伺服器是交大資工架設，domain 同 freebsd.csie.nctu.edu.tw，我們利用 fastest_cvsup 可以另外找尋更好的伺服器。 

<pre class="brush: bash; title: ; notranslate" title="">#
# ports 安裝
#
cd /usr/ports/sysutils/fastest_cvsup
make install clean</pre> 說明如何使用指令： 

<pre class="brush: bash; title: ; notranslate" title="">#
# 找尋台灣區最佳的伺服器 
#
fastest_cvsup -c tw
#
# 找尋最上層 cvsup 伺服器，如 cvsup.freebsd.org
#
fastest_cvsup -c tld</pre>

<!--more--> 下面是圖示： 

[<img src="https://i1.wp.com/farm4.static.flickr.com/3127/3173162423_a3922c0f3e.jpg?resize=343%2C500&#038;ssl=1" title="freebsd_cvsup (by appleboy46)" alt="freebsd_cvsup (by appleboy46)" data-recalc-dims="1" />][4] 那架設方式請參考 [[教學]用 cvsup-mirror 架設 CVSup Server (mirror site)][1]，這一篇寫的還蠻詳細的。 加入開機自動啟動： 

<pre class="brush: bash; title: ; notranslate" title="">#
# 編輯 rc.conf 最後加上 
#
cvsupd_enable="YES"</pre> 它會開啟 5999 這個 port number 提供給 fastest_cvsup 偵測連線，不過偵測是根據 http://www.freebsd.org/doc/en/books/handbook/cvsup.html 這個網站提供的 mirror list 來決定，所以自己測試就是設定自己的伺服器看看就可以了。

 [1]: http://www.backup.idv.tw/viewtopic.php?=&p=1536
 [2]: http://www.freshports.org/net/cvsup-mirror/
 [3]: http://www.freshports.org/sysutils/fastest_cvsup/
 [4]: https://www.flickr.com/photos/appleboy/3173162423/ "freebsd_cvsup (by appleboy46)"