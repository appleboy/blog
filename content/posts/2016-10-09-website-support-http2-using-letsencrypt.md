---
title: 申請 Let’s Encrypt 免費憑證讓網站支援 HTTP2
author: appleboy
type: post
date: 2016-10-09T08:23:00+00:00
url: /2016/10/website-support-http2-using-letsencrypt/
dsq_thread_id:
  - 5208688592
categories:
  - DevOps
  - Linux
  - Nginx
  - SSL
tags:
  - AWS
  - devops
  - http2
  - https
  - Letsencrypt
  - nginx

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23840721545/in/dateposted-public/" title="Letsencrypt"><img src="https://i1.wp.com/farm6.staticflickr.com/5803/23840721545_e0350b687f.jpg?w=300&#038;ssl=1" alt="Letsencrypt" data-recalc-dims="1" /></a>

寫這篇最主要推廣讓網站都支援 [HTTPS 加密連線][1]及 [HTTP2 協定][2]，對於網站為什麼要支援 HTTP2，可以直接參考 ihower 寫的[說明文章][3]，最近在玩 Facebook, Line, Telegram Bot 時，填寫 Webhook URL，都強制要填寫 https:// 開頭，所以更不能忽略 HTTPS 了。，去年底寫了一篇 [Let's Encrypt 開放申請免費 SSL 憑證][4] 推廣 Let's Encrypt 的貢獻，讓買不起憑證，又想玩看看 HTTP2 的開發者可以用很簡單的方式來安裝及自動更新憑證，而 [gslin][5] 大為了推廣 HTTPS 也做了一個[網站教學][6]，文章寫得相當清楚，支援 [Apache][7] 及 [Nginx][8] 設定。

<!--more-->

### 安裝方式

如果主機是使用 Amazone EC2，可以直接用 [AWS Certificate Manager][9]，用 AWS 的好處就是只要透過[後台介面搭配 ELB][10] 就可以直接設定好 HTTPS 對應到 EC2 主機，壞處就是直接被綁死，將來如果不要使用 AWS，要轉移機器會相當痛苦。所以本篇會紀錄如何用 Nginx 搭配 [Let's Encrypt][11]。為了方便部署機器，我們選用 [dehydrated][12] 來設定 Let's Encrypt，好處就是不用安裝 Python 套件，官方網站提供的安裝方式需要安裝 Python 相關環境。透過 wget 將 dehydrated 安裝到 `/etc/dehydrated/` 底下

<pre><code class="language-bash">$ mkdir -p /etc/dehydrated/
$ wget https://raw.githubusercontent.com/lukas2511/dehydrated/master/dehydrated -O /etc/dehydrated/dehydrated
$ chmod 755 /etc/dehydrated/dehydrated</code></pre>

### 建立設定檔

建立 dehydrated config 設定檔

    $ echo "WELLKNOWN=/var/www/dehydrated" > /etc/dehydrated/config 
    $ mkdir -p /var/www/dehydrated

Nginx 設定，先在 80 port 的 Server section 內寫入底下設定:

<pre><code class="language-bash">location /.well-known/acme-challenge/ {
  alias /var/www/dehydrated/;
}</code></pre>

可以先丟個檔案到 `/var/www/dehydrated/` 確定網站可以正常讀取檔案，接著透過 dehydrated 指令產生 SSL 設定檔

<pre><code class="language-bash">$ /etc/dehydrated/dehydrated -c -d fbbot.wu-boy.com</code></pre>

執行上述指令會看到底下結果

<pre><code class="language-bash"># INFO: Using main config file /etc/dehydrated/config
Processing fbbot.wu-boy.com
 + Signing domains...
 + Generating private key...
 + Generating signing request...
 + Requesting challenge for fbbot.wu-boy.com...
 + Responding to challenge for fbbot.wu-boy.com...
 + Challenge is valid!
 + Requesting certificate...
 + Checking certificate...
 + Done!
 + Creating fullchain.pem...
 + Done!</code></pre>

最後在設定一次 nginx

<pre><code class="language-bash">server {
  # don&#039;t forget to tell on which port this server listens
  listen 80;

  # listen on the www host
  server_name fbbot.wu-boy.com;

  # and redirect to the non-www host (declared below)
  return 301 https://fbbot.wu-boy.com$request_uri;
}

server {
  listen 0.0.0.0:443 ssl http2;
  server_name fbbot.wu-boy.com;

  location /.well-known/acme-challenge/ {
    alias /var/www/dehydrated/;
  }

  ssl_certificate /etc/dehydrated/certs/fbbot.wu-boy.com//fullchain.pem;
  ssl_certificate_key /etc/dehydrated/certs/fbbot.wu-boy.com/privkey.pem;
  location / {
    proxy_pass http://localhost:8081;
  }
}</code></pre>

上面是將 80 port 自動轉到 https，如果下次要重新 renew 的時候才不會又要打開 80 port 一次。

### 加入 Cron 設定

每天半夜可以自動 renew 一次，請參考 <https://letsencrypt.tw/> 最後章節

<pre><code class="language-bash">0 0 * * * root sleep $(expr $(printf "\%d" "0x$(hostname | md5sum | cut -c 1-8)") \% 86400); ( /etc/dehydrated/dehydrated -c -d fbbot.wu-boy.com; /usr/sbin/service nginx reload ) &gt; /tmp/dehydrated-fbbot.wu-boy.com.log 2&gt;&1</code></pre>

### 後記

除了這方法之外，也可以使用 [Certbot][13] 來自動更新憑證，但是這方式就是要安裝 Python 環境，不過也不是很難就是了，可以直接參考這篇『[NGINX 使用 Let's Encrypt 免費 SSL 憑證設定 HTTPS 安全加密網頁教學][14]』。結論就是你可以在網路上找到超多種方法來申請 Let's Encrypt 憑證，就找到自己覺得不錯的方法即可，而我是認為不用安裝 Python 環境的方式最適合部署了。

 [1]: https://en.wikipedia.org/wiki/HTTPS
 [2]: https://en.wikipedia.org/wiki/HTTP/2
 [3]: https://ihower.tw/blog/archives/8489
 [4]: https://blog.wu-boy.com/2015/12/letsencrypt-entering-public-beta-free-ssl/
 [5]: https://blog.gslin.org/
 [6]: https://letsencrypt.tw/
 [7]: https://httpd.apache.org/
 [8]: https://nginx.org/
 [9]: https://aws.amazon.com/tw/certificate-manager/
 [10]: http://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-create-https-ssl-load-balancer.html
 [11]: https://letsencrypt.org/
 [12]: https://github.com/lukas2511/dehydrated
 [13]: https://github.com/certbot/certbot
 [14]: https://blog.gtwang.org/linux/secure-nginx-with-lets-encrypt-ssl-certificate-on-ubuntu-and-debian/