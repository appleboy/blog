---
title: 將 wordpress 強制使用 SSL 連線
author: appleboy
type: post
date: 2015-12-19T10:03:17+00:00
url: /2015/12/force-https-connection-on-wordpress/
dsq_thread_id:
  - 4416840874
categories:
  - Nginx
  - php
  - wordpress
tags:
  - http2
  - Letsencrypt
  - nginx
  - php
  - spdy
  - SSL
  - wordpress

---
<div style="margin:0 auto; text-align:center">
  <a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23840721545/in/dateposted-public/" title="Letsencrypt"><img src="https://i1.wp.com/farm6.staticflickr.com/5803/23840721545_e0350b687f.jpg?w=300&#038;ssl=1" alt="Letsencrypt" data-recalc-dims="1" /></a>
</div>

繼上篇介紹 [Letsencrypt 開放申請免費 SSL 憑證][1]，就把我的 Blog 強制使用 https 連線，Wordpress 強制使用 SSL 連線有幾個步驟需要注意，底下會是搭配 Nginx 相關設定，建議如果有裝任何 Plugin，都先進去後台暫時關閉。Nginx 1.9.5 之後有把 [http2][2] 模組加入，所以本篇會是以設定 http2 為主，當然跟 [spdy][3] 設定一樣，只是換個名字而已。

<!--more-->

### 資料庫相關設定

這邊可以從 WordPress 後台修改，或者是從資料庫內的 `wp_options` 直接改 `siteurl` 及 `home` 這兩個 value。

### WordPress 設定檔

請打開 `wp-config.php` 加入底下設定

<div>
  <pre class="brush: php; title: ; notranslate" title="">define('FORCE_SSL_LOGIN', true);
define('FORCE_SSL_ADMIN', true);</pre>
</div>

### 設定 Nginx

將原本 80 port 設定 301 轉到 https

<div>
  <pre class="brush: bash; title: ; notranslate" title="">server {
  # don't forget to tell on which port this server listens
  listen 80;

  # listen on the www host
  server_name blog.wu-boy.com;

  # and redirect to the non-www host (declared below)
  return 301 https://blog.wu-boy.com$request_uri;
}

server {
  listen 0.0.0.0:443 ssl http2;

  # include ssl config
  include ssl/blog.conf; 

  ....
}</pre>
</div>

比較注意的是，如果 Nginx 有設定 `fastcgi_param HTTPS off;`，請務必移除，否則你的 WordPress 網站會產生 Loop。最後附上在 [SSllabs][4] 驗證的截圖

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23732612342/in/dateposted-public/" title="Screen Shot 2015-12-18 at 1.25.30 PM"><img src="https://i2.wp.com/farm6.staticflickr.com/5720/23732612342_2d981cf910_z.jpg?resize=640%2C355&#038;ssl=1" alt="Screen Shot 2015-12-18 at 1.25.30 PM" data-recalc-dims="1" /></a> <a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23293707733/in/dateposted-public/" title="SSL Server Test  blog.wu boy.com  Powered by Qualys SSL Labs"><img src="https://i1.wp.com/farm6.staticflickr.com/5659/23293707733_57f01d3d7a_b.jpg?resize=582%2C1024&#038;ssl=1" alt="SSL Server Test  blog.wu boy.com  Powered by Qualys SSL Labs" data-recalc-dims="1" /></a>

 [1]: https://blog.wu-boy.com/2015/12/letsencrypt-entering-public-beta-free-ssl/
 [2]: http://nginx.org/en/docs/http/ngx_http_v2_module.html
 [3]: https://www.chromium.org/spdy/spdy-whitepaper
 [4]: https://www.ssllabs.com/