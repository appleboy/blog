---
title: nginx 1.4.0 釋出並支援 SPDY
author: appleboy
type: post
date: 2013-04-28T08:15:48+00:00
url: /2013/04/nginx-1-4-0-support-spdy-module/
categories:
  - Linux
  - Network
  - Nginx
  - www
tags:
  - nginx
  - spdy

---
**Update: 由於 OpenSSL CVE-2014-0160 Heartbleed Security，請將 openssl 升級到 1.0.1g 版本**

<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8684224387/" title="nginx-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm9.staticflickr.com/8401/8684224387_19de454ebf.jpg?resize=320%2C120&#038;ssl=1" alt="nginx-logo" data-recalc-dims="1" /></a>
</div>

很高興看到 <a href="http://nginx.org/" target="_blank">Nginx</a> Release 1.4.0 版本，此新版本開始支援 <a href="http://nginx.org/en/docs/http/ngx_http_spdy_module.html" target="_blank">SPDY module</a>，對於 SPDY 還不熟悉了解的，可以參考今年 <a href="http://www.webconf.tw" target="_blank">2013 WebConf</a> 講師 ihower 介紹的 <a href="http://www.slideshare.net/ihower/a-brief-introduction-to-spdy-http20" target="_blank">A brief introduction to SPDY - 邁向 HTTP/2.0</a>，要提升整個 Web Performance，可以將 SPDY 導入，對於使用 Apache 使用者，請參考 <a href="http://code.google.com/p/mod-spdy/" target="_blank">mod_spdy</a>，如果是 Nginx 用戶，在 1.3.x 版本，可以直接用官方 [patch][1]，升級到 1.4.x 就不需要 patch 了，但 OS 是 <a href="http://www.ubuntu.com/" target="_blank">Ubuntu</a> 或 <a href="http://www.centos.org/" target="_blank">CentOS</a> 系列是需要自行編譯，這次會筆記在 CentOS 下將 spdy 編譯進系統。

### 安裝方式

先看 Ngix 是否有支援 spdy，直接下 nginx -V 觀看

> nginx version: nginx/1.1.19 TLS SNI support enabled configure arguments: --prefix=/etc/nginx --conf-path=/etc/nginx/nginx.conf --erth=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-lb/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path==/var/run/nginx.pid --with-debug --with-http\_addition\_module --with-http\_dav\_moith-http\_image\_filter\_module --with-http\_realip\_module --with-http\_stub\_status\_\_xslt\_module --with-ipv6 --with-sha1=/usr/include/openssl --with-md5=/usr/includ/buildd/nginx-1.1.19/debian/modules/nginx-auth-pam --add-module=/build/buildd/d/nginx-1.1.19/debian/modules/nginx-upstream-fair --add-module=/build/buildd/ng
<!--more--> 看到上述結果，沒有發現 

<span style="color:green"><strong>http_spdy_module</strong></span> 模組，代表並無編譯進去，底下安裝過程，是基於 CentOS 6.4 Release 環境。安裝前請先下載 <a href="http://nginx.org/download/nginx-1.4.0.tar.gz" target="_blank">Nginx 1.4.0</a> 及 <a href="http://www.openssl.org/source/openssl-1.0.1g.tar.gz" target="_blank">openssl 1.0.1g</a> 版本。

<div>
  <pre class="brush: bash; title: ; notranslate" title=""># generate makefile
cd /tmp/nginx-1.4.7 && ./configure \
        --prefix=/usr/share/nginx \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --user=nginx \
        --group=nginx \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_xslt_module \
        --with-http_image_filter_module \
        --with-http_geoip_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_degradation_module \
        --with-http_stub_status_module \
        --with-http_perl_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-http_ssl_module \
        --with-http_spdy_module \
        --with-openssl=/tmp/openssl-1.0.1g
    cd /tmp/nginx-1.4.7 && make && make install</pre>
</div>

比較需要注意的事，假如系統已經安裝好 nginx 版本，預設執行程式會在 /usr/sbin/nginx，所以編譯時，請務必指定此路徑蓋掉原有的執行檔，這樣系統還是可以透過 init.d 啟動或關閉 nginx。

### 啟動 spdy 模組

為了將 https 及 spdy 同時 listen 443 port，OpenSSL 務必支援 <a href="https://technotes.googlecode.com/git/nextprotoneg.html" target="_blank">Next Protocol Negotiation</a>，所以版本要 1.0.1 以上。在 nginx.conf 設定如下

<div>
  <pre class="brush: bash; title: ; notranslate" title="">server {
    listen 443 ssl spdy;

    ssl_certificate server.crt;
    ssl_certificate_key server.key;
    ...
}</pre>
</div>

### 偵測伺服器是否支援 spdy

經過安裝完成 Nginx with spdy module，要確定伺服器有無支援，可以透過 Firefox addon 或 Chrome extension，底下是 SPDY indicator 下載連結

  * <a href="https://addons.mozilla.org/zh-tw/firefox/addon/spdy-indicator/" target="_blank">Firefox SPDY indicator</a>
  * C<a href="https://chrome.google.com/webstore/detail/spdy-indicator/mpbpobfflnpcgagjijhmgnchggcjblin" target="_blank">hrome SPDY indicator</a>

要如何測試呢？打開 Chrome 瀏覽器，輸入 Google 網址，你會發現網址列多一個<span style="color:green">綠色勾勾</span>，那就代表伺服器有支援 SPDY Module。

 [1]: http://nginx.org/patches/spdy/patch.spdy.txt