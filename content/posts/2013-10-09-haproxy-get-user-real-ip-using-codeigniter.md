---
title: HAProxy 搭配 CodeIgniter 取使用者真實 IP
author: appleboy
type: post
date: 2013-10-09T02:57:24+00:00
url: /2013/10/haproxy-get-user-real-ip-using-codeigniter/
dsq_thread_id:
  - 1838137358
categories:
  - CodeIgniter
  - Debian
  - Linux
  - Nginx
tags:
  - CodeIgniter
  - HAProxy

---
前端 Load Balance 首選就是 <a href="http://haproxy.1wt.eu/" target="_blank">HAProxy</a>，後端架設 <a href="http://nginx.org/" target="_blank">Nginx</a> 搭配 <a href="http://www.codeigniter.org.tw/" target="_blank">CodeIgniter</a>，紀錄使用者 IP 時，Nginx 總是只有抓到內部 IP 192.168.x.x，而無法抓到真實 Public IP，要抓到 Public IP 必須修改 HAProxy + Nginx 設定檔，HAProxy 只要在 Backend 地方加入 <a href="http://code.google.com/p/haproxy-docs/wiki/forwardfor" target="_blank">forward</a> 選項，這樣 HAProxy 會送 X-Forwarded-For header 給後端 Nginx。 

<pre class="brush: bash; title: ; notranslate" title="">option forwardfor</pre>

<!--more--> 接著設定 Nginx 部份，必須編譯 

<a href="http://nginx.org/en/docs/http/ngx_http_realip_module.html" target="_blank">ngx_http_realip_module</a> 模組，在 nginx.conf 加入 

<pre class="brush: bash; title: ; notranslate" title="">set_real_ip_from 127.0.0.1;
real_ip_header X-Forwarded-For;</pre> 這樣就可以拿到真實 IP 了，最後在 CodeIgniter 找到 config.php 設定檔 

<pre class="brush: bash; title: ; notranslate" title="">/*
|--------------------------------------------------------------------------
| Reverse Proxy IPs
|--------------------------------------------------------------------------
|
| If your server is behind a reverse proxy, you must whitelist the proxy IP
| addresses from which CodeIgniter should trust the HTTP_X_FORWARDED_FOR
| header in order to properly identify the visitor's IP address.
| Comma-delimited, e.g. '10.0.1.200,10.0.1.201'
|
*/
$config['proxy_ips'] = '192.168.1.100,192.168.1.101,192.168.1.102';</pre> 將 proxy_ips 設定好即可