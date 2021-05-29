---
title: '[FreeBSD & Linux]網站分流：簡易架設 HAProxy 伺服器'
author: appleboy
type: post
date: 2008-06-23T14:07:23+00:00
url: /2008/06/freebsd-linux網站分流：簡易架設-haproxy-伺服器/
views:
  - 10632
bot_views:
  - 1175
dsq_thread_id:
  - 246823024
categories:
  - apache
  - DNS
  - FreeBSD
  - Linux
  - www
tags:
  - apache
  - FreeBSD
  - HAProxy
  - Linux

---
最近在玩這套 Web 的 Load Balance 軟體，其實這是之前我寫的一篇：[[筆記] FreeBSD 一張網卡多重 ip 實現 Round Robin DNS Load Balancing][1]，有網友留言給我說可以玩看看 [HAProxy][2]，這樣的確改善了很多效能，而且也是正確達到 load balance 的效果，不然用 DNS Robin DNS Load Balancing 的方式的卻沒辦法做的很好，關於 HAProxy 在 google 了一下，好像國內很少人在寫這方面的教學，我自己來寫一下筆記好了，其實我還不是對設定很熟悉，只是大概知道他的原理罷了，底下我們來看看官網的一張圖 [<img src="https://i1.wp.com/farm4.staticflickr.com/3211/2603471691_6d083bbeed.jpg?resize=363%2C290&#038;ssl=1" alt="haproxy-pmode" data-recalc-dims="1" />][3] <!--more--> 其實原理很簡單，就是在最前面擺一台簡單的電腦架設 HAProxy 來達成分流功能，後端擺幾台 WEB 伺服器，然後最後面在擺一台資料庫MySQL或者是其他的資料庫，然後去設定 HAProxy 看看哪個ip進來就把它導向到後端的部份，然後後端機器就是設定一下 apache 的 

[virtualhost][4]，其實這樣就差不多了 第一步：架設 FreeBSD 的 HAProxy 

<pre class="brush: bash; title: ; notranslate" title="">Port:   haproxy-devel-1.3.12.2
Path:   /usr/ports/net/haproxy-devel
Info:   The Reliable, High Performance TCP/HTTP Load Balancer
Maint:  hugo@barafranca.com
B-deps:
R-deps:
WWW:    http://haproxy.1wt.eu/</pre>

<pre class="brush: bash; title: ; notranslate" title="">進行安裝：
#
# cd /usr/ports/net/haproxy-devel
#
make install clean</pre> 第二步：設定 HAProxy 的 conf 檔 

<pre class="brush: bash; title: ; notranslate" title="">#
# vi /usr/local/etc/haproxy.conf
#
global
        maxconn         32768
        user            nobody
        group           nobody
        daemon
        nbproc          8
listen blog-balancer
        bind            140.123.107.54:80
        mode            http
        balance         roundrobin
        maxconn         32768
        clitimeout      60000
        srvtimeout      60000
        contimeout      5000
        retries         3

        server          blog1 192.168.1.1:80 weight 3 check
        server          blog2 192.168.1.2:80 weight 3 check
        server          blog3 192.168.1.3:80 weight 3 check
        option          forwardfor
        option          httpclose
        option          httplog
        option          redispatch
        option          dontlognull
</pre> 上面資料，我是參考 

[網路大神 Gslin][5] 大大的 [wiki][6]，其實我自己還不太瞭解怎麼設定，所以要去參考官網寫的[設定教學][7] 第三步：要在後端主機設定 apache virtualhost 

<pre class="brush: bash; title: ; notranslate" title="">&lt;VirtualHost 10.1.2.3>
ServerAdmin webmaster@host.foo.com
DocumentRoot /www/docs/host.foo.com
ServerName host.foo.com
ErrorLog logs/host.foo.com-error_log
TransferLog logs/host.foo.com-access_log
&lt;/VirtualHost> 
</pre> 後端三台都是要加上這些設定，這樣在轉過去的時候，才會出現正確網站，大致設定這樣就可以 work 參考網站： 

<a href="http://haproxy.1wt.eu/" target="_blank">http://haproxy.1wt.eu/</a> [商業服務的Rails HTTP Cluster觀念及測試][8] [Load Balancing & QoS with HAProxy][9] <a href="http://www.ecase.com.cn/blog/?p=14" target="_blank">http://www.ecase.com.cn/blog/?p=14</a> <a href="http://wiki.gslin.org/haproxy" target="_blank">http://wiki.gslin.org/haproxy</a> [期刊/商業服務的Rails伺服器叢集觀念與實做(下)][10]

 [1]: http://blog.wu-boy.com/2008/06/01/274/
 [2]: http://haproxy.1wt.eu/
 [3]: https://www.flickr.com/photos/appleboy/2603471691/ "haproxy-pmode by appleboy46, on Flickr"
 [4]: http://httpd.apache.org/docs/2.0/mod/core.html#virtualhost
 [5]: http://blog.gslin.org/
 [6]: http://wiki.gslin.org/haproxy
 [7]: http://haproxy.1wt.eu/download/1.3/doc/haproxy-en.txt
 [8]: http://www.adj.idv.tw/html/42/t-242.html
 [9]: http://www.igvita.com/2008/05/13/load-balancing-qos-with-haproxy/
 [10]: http://www.tsima.org.tw/wiki/index.php/%E6%9C%9F%E5%88%8A/%E5%95%86%E6%A5%AD%E6%9C%8D%E5%8B%99%E7%9A%84Rails%E4%BC%BA%E6%9C%8D%E5%99%A8%E5%8F%A2%E9%9B%86%E8%A7%80%E5%BF%B5%E8%88%87%E5%AF%A6%E5%81%9A(%E4%B8%8B)