---
title: HAproxy 搭配 Nginx port redirect issue
author: appleboy
type: post
date: 2013-07-17T11:42:13+00:00
url: /2013/07/nginx-port-redirect-issue-with-haproxy/
dsq_thread_id:
  - 1506239126
categories:
  - Debian
  - Linux
  - Network
  - Ubuntu
tags:
  - HAProxy
  - nginx

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8684224387/" title="nginx-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm9.staticflickr.com/8401/8684224387_19de454ebf.jpg?resize=320%2C120&#038;ssl=1" alt="nginx-logo" data-recalc-dims="1" /></a>
</div>

<a href="http://haproxy.1wt.eu/" target="_blank">HAproxy</a> 是一套高效能分散式系統軟體，後端可搭配 Web 或 SQL 服務，這次在後端搭配 <a href="http://nginx.org/" target="_blank">Nginx</a> 出現 port redirect 問題，問題很簡單，在 Haproxy 設定 80 port 對應到內部三台 Nginx 機器，但是 Nginx port 設定 8080，這樣當我們在瀏覽網址如下: 

> http://aaa.bbb.ccc.ddd/test (請注意，最後沒有 slash 喔) 你會發現 Nginx 將網址轉成 

> http://aaa.bbb.ccc.ddd:8080/test/ 為了避免 Nginx 自動將 port 加入到網址列，我們可以透過設定 <a href="http://wiki.nginx.org/HttpCoreModule#port_in_redirect" target="_blank">port_in_redirect</a>，Nginx 預設將此設定為 On，所以將此設定為 off，並且重新啟動 Nginx 即可 

<pre class="brush: bash; title: ; notranslate" title="">port_in_redirect off;</pre>