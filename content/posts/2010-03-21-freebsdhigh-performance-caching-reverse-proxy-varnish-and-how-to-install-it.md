---
title: '[FreeBSD]high performance caching reverse proxy: Varnish (安裝架設篇)'
author: appleboy
type: post
date: 2010-03-20T16:12:44+00:00
url: /2010/03/freebsdhigh-performance-caching-reverse-proxy-varnish-and-how-to-install-it/
views:
  - 5868
bot_views:
  - 512
dsq_thread_id:
  - 247294004
categories:
  - apache
  - FreeBSD
  - Linux
  - Network
  - php
  - www
tags:
  - apache
  - HAProxy
  - php
  - Squid
  - Varnish

---
[<img src="https://i2.wp.com/farm3.static.flickr.com/2695/4445679996_0a9d597a94_o.gif?resize=235%2C64&#038;ssl=1" alt="varnish-logo-red-64" data-recalc-dims="1" />][1] 在上禮拜跟 [DarkHero][2] 兄聊到 [How To Build a Scalable Web Site (3/6)][3] 的上課講義，互相討論了 MySQL Load balance 以及 http [reverse proxy][4] 的方式，以前自己有用 [HAProxy][5] 當作 Web 平衡負載，順便紀錄了 [HAProxy FreeBSD 安裝方式][6]，這次要來介紹今天重點：[Varnish Cache Server][7]，在近幾年流行的 Caching 機制，大家會想到 Squid，只要您設定良好的 Squid 參數，它一定運作的非常穩定，然而它的核心依然是 forward proxy，要架設成 Reverse Proxy 還必需要設定一些參數才可以達到，是有一定的困難性，然而 Varnish Cache Server 底層就是高效能 caching reverse proxy，也因為 Squid 是 1980 年發展出來的，程式架構過於老舊，可以參考 [ArchitectNotes][8] 瞭解這部份詳情。也許您會問到 Varnish 可以架設成 forward proxy 嗎？答案是可以的，但是您也許不會這麼做，因為它需要 DNS 技術，以及需要一個非常大且複雜的 Varnish VCL(Varnish Configuration Language) file。 1. 今天要介紹如何在 FreeBSD 系統安裝，在介紹之前，系統必須先安裝好 apache，這樣才可以正確啟動，利用 ports 安裝： 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/www/varnish/
make install clean
</pre> 2. 修改 /etc/rc.conf 

<pre class="brush: bash; title: ; notranslate" title=""># varnishd
varnishd_enable="YES"
varnishd_listen=":80"
varnishd_admin=":81"
varnishd_backend=":5566"
varnishd_config="/usr/local/etc/varnish/default.vcl"</pre> 上面設定意思是說 Varnish listen on port 80，傳送 traffic 到後端 5566 port，管理連接埠是 81，也可以使用指令方式： 

<pre class="brush: bash; title: ; notranslate" title="">varnishd -a :80 -b localhost:8080 -T localhost:6082</pre>

> Varnishd listen on port 80，and forwarding traffic to a web server listen on localhost port 8080. It also turns on the management interface on port 6082. 3. 修改 default.vcl (Varnish Configuration Language) VCL 檔案告訴 Varnishd 正確的處理每個 request processing，包含在接受到 request 之前所處理的行為 vcl\_recv()，另外還有 vcl\_hit()、vcl_miss() 等...，都是用來處理 cache 如果存在或者是不存在時的情境 request。FreeBSD 預設放在 <span style="color:green">/usr/local/etc/varnish/default.vcl</span>。打開此檔案，您會看到： 

<pre class="brush: bash; title: ; notranslate" title="">backend default {
   .host = "127.0.0.1";
   .port = "80";
}</pre> 您只要把 host = "127.0.0.1" 改成你後端要連接的 ip 或者是 host，這樣 Varnish 會 forward traffic 到您的 web server。接下來只要啟動 apache 跟 Varnish 就算是初步架設完成。 

<pre class="brush: bash; title: ; notranslate" title="">/usr/local/etc/rc.d/apache22 restart
/usr/local/etc/rc.d/varnishd restart</pre>

[<img src="https://i0.wp.com/farm3.static.flickr.com/2726/4448204616_8668e2d8b3.jpg?resize=500%2C170&#038;ssl=1" alt="Varnish_01" data-recalc-dims="1" />][9] 大家可以看到 61.\*.\*.* 連到本機 80 port，接下來 Varnish 在開啟隨機 57475 port 連接到 Web Server 5566 port。 **Q:如何讓 apache 紀錄正確的 Client IP 到 log 檔案呢？** 1. 打開 Vcl config 檔案，寫入 Varnish configuration: 

<pre class="brush: bash; title: ; notranslate" title="">sub vcl_recv {
  # Add a unique header containing the client address
  remove req.http.X-Forwarded-For;
  set    req.http.X-Forwarded-For = client.ip;
  # [...]
}</pre> 2. 開啟 apache httpd.conf 加入此行： 

<pre class="brush: bash; title: ; notranslate" title="">LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" varnishcombined</pre>

[<img src="https://i1.wp.com/farm3.static.flickr.com/2694/4448227216_99663d5959.jpg?resize=500%2C156&#038;ssl=1" alt="Varnish_02" data-recalc-dims="1" />][10] **Q:如何讓 PHP 程式紀錄正確的 Client IP？** 可以參考底下程式碼就可以完全抓到 Proxy 後面真正使用者IP，否則您的 Web 只會抓到 Reverse Proxy 的 IP Address。 

<pre class="brush: php; title: ; notranslate" title="">function getIP() {
  if (validip($_SERVER["HTTP_CLIENT_IP"])) {
    return $_SERVER["HTTP_CLIENT_IP"];
  }
  foreach(explode(",",$_SERVER["HTTP_X_FORWARDED_FOR"]) as $ip) {
    if (validip(trim($ip))) {return $ip;}
  }
  if (validip($_SERVER["HTTP_X_FORWARDED"])) 
  {
    return $_SERVER["HTTP_X_FORWARDED"];
  }
  else if (validip($_SERVER["HTTP_FORWARDED_FOR"])) 
  {
    return $_SERVER["HTTP_FORWARDED_FOR"];
  } 
  else if (validip($_SERVER["HTTP_FORWARDED"])) 
  {
    return $_SERVER["HTTP_FORWARDED"];
  } 
  else if (validip($_SERVER["HTTP_X_FORWARDED"])) 
  {
    return $_SERVER["HTTP_X_FORWARDED"];
  } 
  else 
  {
    return $_SERVER["REMOTE_ADDR"];
  }
}

function validip($ip) {
  if (!empty($ip) && ip2long($ip)!=-1) {
    $reserved_ips = array (
      array('10.0.0.0','10.255.255.255'),
      array('127.0.0.0','127.255.255.255'),
      array('169.254.0.0','169.254.255.255'),
      array('172.16.0.0','172.31.255.255'),
      array('192.168.0.0','192.168.255.255'),
    );
    foreach ($reserved_ips as $r) {
      $min = ip2long($r[0]);
      $max = ip2long($r[1]);
      if ((ip2long($ip) >= $min) && (ip2long($ip) <= $max)) return false;
    }
    return true;
  } 
  else 
  {
    return false;
  }
}[/code]
<strong>Q:rotate Varnish log file every day？</strong>
打開 /etc/newsyslog.conf，加入底下兩行
/var/log/varnish.log        640     7   *   @T00    JB  /var/run/varnishlog.pid
/var/log/varnishncsa.log    640     7   *   @T00    JB  /var/run/varnishncsa.pid</pre> 每天12點進行 log 備份，使用 gzip 壓縮 log 檔案。

 [1]: https://www.flickr.com/photos/appleboy/4445679996/ "Flickr 上 appleboy46 的 varnish-logo-red-64"
 [2]: http://blog.darkhero.net
 [3]: http://blog.darkhero.net/?p=391
 [4]: http://en.wikipedia.org/wiki/Reverse_proxy
 [5]: http://haproxy.1wt.eu/
 [6]: http://blog.wu-boy.com/2008/06/23/283/
 [7]: http://varnish-cache.org/
 [8]: http://varnish-cache.org/wiki/ArchitectNotes
 [9]: https://www.flickr.com/photos/appleboy/4448204616/ "Flickr 上 appleboy46 的 Varnish_01"
 [10]: https://www.flickr.com/photos/appleboy/4448227216/ "Flickr 上 appleboy46 的 Varnish_02"