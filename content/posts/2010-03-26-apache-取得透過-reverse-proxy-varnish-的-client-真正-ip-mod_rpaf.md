---
title: Apache 取得透過 Reverse Proxy (Varnish) 的 Client 真正 IP (mod_rpaf)
author: appleboy
type: post
date: 2010-03-25T17:21:51+00:00
url: /2010/03/apache-取得透過-reverse-proxy-varnish-的-client-真正-ip-mod_rpaf/
views:
  - 4806
bot_views:
  - 463
dsq_thread_id:
  - 246815686
categories:
  - apache
  - FreeBSD
  - Linux
tags:
  - apache
  - FreeBSD
  - mod_rpaf
  - Varnish

---
[<img src="https://i1.wp.com/farm3.static.flickr.com/2705/4462939520_26be3f6fa9_o.gif?resize=356%2C107&#038;ssl=1" alt="feather" data-recalc-dims="1" />][1] 之前介紹 [[FreeBSD]high performance caching reverse proxy: Varnish (安裝架設篇)][2] 來當 Web 前端 [Reverse Proxy][3]，也有 [load balance][4] 的功能，不過碰到這樣的環境，後端 [Apache][5] Server 只會抓到 Reverse Proxy IP 來當作 log 紀錄，而無法正確取得 Client 端 IP，[Varnish][6] 官網 [FAQ][7] 有提到 log 檔案得的解決方法，不過在程式方面，要大量的修改，假設今天 Apache 跑10個 [Virtual Host][8] ，不就要去改10個網站程式，背後或許是一些大型 open source 的 Project，改起來相當不容易，也很費工夫。[Darkhero][9] 提供了 [reverse proxy add forward module for Apache (mod_rpaf)][10] 模組，只要裝上這模組，Apache 就不必動到其它設定就可以正確紀錄 log 檔案，且程式都不必修改，就可以得到正確 IP 了。 FreeBSD Ports 安裝方式： 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/www/mod_rpaf2/
make install clean</pre> 修改 httpd.conf (FreeBSD: /usr/local/etc/apache22/httpd.conf) 

<pre class="brush: bash; title: ; notranslate" title="">LoadModule rpaf_module        libexec/apache22/mod_rpaf.so</pre> 將上面 unmask，最後面加上： 

<pre class="brush: bash; title: ; notranslate" title="">RPAFenable On
RPAFsethostname On
RPAFproxy_ips xxx.xxx.xxx.xxx 127.0.0.1
RPAFheader X-Forwarded-For</pre>

 [1]: https://www.flickr.com/photos/appleboy/4462939520/ "Flickr 上 appleboy46 的 feather"
 [2]: http://blog.wu-boy.com/2010/03/21/2054/
 [3]: http://en.wikipedia.org/wiki/Reverse_proxy
 [4]: http://en.wikipedia.org/wiki/Load_balancing_(computing)
 [5]: http://www.apache.org/
 [6]: http://varnish-cache.org/
 [7]: http://varnish-cache.org/wiki/FAQ
 [8]: http://httpd.apache.org/docs/2.0/vhosts/examples.html
 [9]: http://blog.darkhero.net/
 [10]: http://stderr.net/apache/rpaf/