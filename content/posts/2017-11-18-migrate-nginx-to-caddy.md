---
title: 從 Nginx 換到 Caddy
author: appleboy
type: post
date: 2017-11-18T04:23:25+00:00
url: /2017/11/migrate-nginx-to-caddy/
dsq_thread_id:
  - 6291888798
categories:
  - Caddy
  - Golang
  - Nginx
tags:
  - caddy
  - nginx

---
[<img src="https://i1.wp.com/farm1.staticflickr.com/528/32758934825_665c449ff3_z.jpg?w=840&#038;ssl=1" alt="The_Caddy_web_server_logo.svg" data-recalc-dims="1" />][1]

終於下定決心將 [Nginx][2] 換到 [Caddy][3] 這套用 [Go][4] 語言所撰寫的開源套件，大家一定會有所疑問『為什麼要換掉 Nginx 而改用 Caddy』，原因其實很簡單，你現在看的 Blog 安裝在 [Linode][5] 機器上面，之前跑的是 Nginx 搭配 [letsencrypt][6]，但是必須要寫一個 Scripts 來自動更新 letsencrypt 憑證，這機制最後不太運作，加上這一年來，每三個月就會有人丟我說『你的 Blog 憑證過期了』，所以就在這時間點，花點時間把 Nginx 設定調整到 Caddy，轉換的時間不會花超過一小時喔。

<!--more-->

## 轉換 WordPress

目前自己只有三個服務，其中一項就是現在的 Blog 是用 WordPress 架出來的，先來看看原先 Nginx 設定

<pre><code class="language-bash">server {
  # don&#039;t forget to tell on which port this server listens
  listen 80;

  # listen on the www host
  server_name blog.wu-boy.com;

  location /.well-known/acme-challenge/ {
    alias /var/www/dehydrated/;
  }

  # and redirect to the non-www host (declared below)
  return 301 https://blog.wu-boy.com$request_uri;
}

server {
  listen 0.0.0.0:443 ssl http2;

  location /.well-known/acme-challenge/ {
    alias /var/www/dehydrated/;
  }

  ssl_certificate /etc/dehydrated/certs/blog.wu-boy.com/fullchain.pem;
  ssl_certificate_key /etc/dehydrated/certs/blog.wu-boy.com/privkey.pem;

  # The host name to respond to
  server_name blog.wu-boy.com;

  # Path for static files
  root /home/www/blog/www;
  index index.html index.htm index.php;
  access_log /home/www/blog/log/access.log;
  error_log /home/www/blog/log/error.log;

  # Specify a charset
  charset utf-8;
  # disable autoindex
  autoindex off;

  # Deliver 404 instead of 403 "Forbidden"
  error_page 403 /403.html;
  # Custom 404 page
  error_page 404 /404.html;

  # stop image Hotlinking
  # ref: http://nginx.org/en/docs/http/ngx_http_referer_module.html
  location ~ .(gif|png|jpe?g)$ {
     valid_referers none blocked server_names;
     if ($invalid_referer) {
        return 403;
    }
  }

  location = / {
    index index.html index.html index.php;
  }

  include h5bp/basic.conf;
  include h5bp/module/wordpress.conf;</code></pre>

看到都頭昏眼花了。這還沒有附上 `wordpress.conf` 的設定呢。接著我們看一下 Caddy 的設定

<pre><code class="language-bash">blog.wu-boy.com {
  root /home/www/blog/www
  gzip
  fastcgi / unix:/var/run/php5-fpm.sock php
  rewrite {
    if {path} not_match ^\/wp-admin
    to {path} {path}/ /index.php?{query}
  }
}</code></pre>

有沒有差異很大，Caddy 強調的就是簡單，而且會自動更新網站憑證。

## 轉換 CodeIgniter

[CodeIgniter][7] 跟 [Laravel][8] 架構一樣，所以設定方式也差不多

<pre><code class="language-bash">codeigniter.org.tw {
  root /home/www/ci/www
  gzip
  fastcgi / unix:/var/run/php5-fpm.sock php
  rewrite {
    if {path} not_match ^\/(forum|user_guide|userguide3)
    to {path} {path}/ /index.php?{query}
  }
}</code></pre>

## 透過 Proxy 設定其他服務

如果你有啟動其他服務，可以透過 [proxy][9] 方式來設定

<pre><code class="language-bash">xxxx.wu-boy.com {
  proxy / localhost:8081 {
    websocket
    transparent
  }
}</code></pre>

## 感想

原本一直想找機會來處理憑證無法三個月自動更新，但是沒什麼時間處理，後來花短短半小時時間就把 Caddy 處理完成，並且設定在 Ubuntu 內開機自動啟動。也許大家可以嘗試看看 Caddy，如果最後真的效能瓶頸在 Caddy，也可以隨時抽換掉。想看更多範例，可以直接參考此[範例連結][10]。

 [1]: https://www.flickr.com/photos/appleboy/32758934825/in/dateposted-public/ "The_Caddy_web_server_logo.svg"
 [2]: https://nginx.org/en/
 [3]: https://caddyserver.com/
 [4]: https://golang.org
 [5]: https://www.linode.com/
 [6]: https://letsencrypt.org/
 [7]: https://codeigniter.org.tw/
 [8]: https://laravel.com/
 [9]: https://caddyserver.com/docs/proxy
 [10]: https://github.com/caddyserver/examples