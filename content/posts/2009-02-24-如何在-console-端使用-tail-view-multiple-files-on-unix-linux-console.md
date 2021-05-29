---
title: 如何在 console 端使用 Tail (View) Multiple Files on UNIX / Linux Console
author: appleboy
type: post
date: 2009-02-24T10:24:28+00:00
url: /2009/02/如何在-console-端使用-tail-view-multiple-files-on-unix-linux-console/
views:
  - 9333
bot_views:
  - 575
dsq_thread_id:
  - 246811740
categories:
  - Debian
  - FreeBSD
  - Linux
  - Ubuntu
tags:
  - FreeBSD
  - Linux

---
這在管理 [UNIX][1] base 系統方面最重要的地方，不管是維護 [Linux][2] or [FreeBSD][3] 主機，都要學習如何觀看 log 檔案，系統出問題，不管是 apache 不能啟動，或者是 MySQL 發生錯誤，基本上都可以觀察 /var/log 底下的檔案來達到解決問題，平常在使用 Linux 預設可以用 [tail][4] 這個指令，使用方法如下： 

<pre class="brush: bash; title: ; notranslate" title="">tail -F /var/log/message
tail -f /var/log/message
-f 如果在 message 晚上 rotate 檔案的時候，就會停止
-F 持續偵測是否有新檔案，會繼續維持下去</pre>

<!--more--> 現在要介紹另一個指令 

[multitail][5]，可以開啟多重檔案，顯示多重視窗喔 在 **<span style="color: #800080;">Debian / Ubuntu</span>** Linux 底下安裝： 

<pre class="brush: bash; title: ; notranslate" title="">$ sudo apt-get update
$ sudo apt-get install multitail</pre> 在 FreeBSD 底下： 

<pre class="brush: bash; title: ; notranslate" title=""># cd /usr/ports/sysutils/multitail
# make install clean</pre> 使用方法： 如果要同時觀看 /var/log/message 跟 /var/log/auth.log 

<pre class="brush: bash; title: ; notranslate" title="">multitail /var/log/messages /var/log/auth.log</pre> 底下這張圖是結果： 

[<img src="https://i2.wp.com/farm4.static.flickr.com/3534/3305515917_c69caafaa6.jpg?resize=500%2C343&#038;ssl=1" title="multitail (by appleboy46)" alt="multitail (by appleboy46)" data-recalc-dims="1" />][6] 如果要同時觀看檔案跟同時執行其他指令： 

<pre class="brush: bash; title: ; notranslate" title="">multitail /var/log/httpd.log -l "netstat -nat"</pre> 觀看三個檔案 multitail /var/log/maillog /var/log/FuzzyOcr.log /var/log/antivirus.log 或者是把視窗切成左邊一個，右邊兩個 multitail -s 2 /var/log/maillog /var/log/FuzzyOcr.log /var/log/antivirus.log 如圖： 

[<img src="https://i0.wp.com/farm4.static.flickr.com/3470/3306361368_bc15a84a48.jpg?resize=500%2C343&#038;ssl=1" title="multitail_1 (by appleboy46)" alt="multitail_1 (by appleboy46)" data-recalc-dims="1" />][7] 參考網站： <http://www.cyberciti.biz/tips/multitail-view-multiple-files-like-tail-command.html>

 [1]: http://en.wikipedia.org/wiki/Unix
 [2]: http://zh.wikipedia.org/wiki/Linux
 [3]: http://www.freebsd.org
 [4]: http://en.wikipedia.org/wiki/Tail_(Unix)
 [5]: http://www.vanheusden.com/multitail/
 [6]: https://www.flickr.com/photos/appleboy/3305515917/ "multitail (by appleboy46)"
 [7]: https://www.flickr.com/photos/appleboy/3306361368/ "multitail_1 (by appleboy46)"