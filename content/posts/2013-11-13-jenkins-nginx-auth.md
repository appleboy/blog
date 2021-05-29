---
title: Jenkins + Nginx User Auth
author: appleboy
type: post
date: 2013-11-13T02:57:57+00:00
url: /2013/11/jenkins-nginx-auth/
dsq_thread_id:
  - 1961267614
categories:
  - Git
  - Nginx
  - Ubuntu
tags:
  - GitLab
  - Jenkins
  - nginx

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/10830034484/" title="jenkins_logo by appleboy46, on Flickr"><img src="https://i0.wp.com/farm6.staticflickr.com/5507/10830034484_95cba45707.jpg?resize=398%2C128&#038;ssl=1" alt="jenkins_logo" data-recalc-dims="1" /></a>
</div>

<a href="http://jenkins-ci.org/" target="_blank">Jenkins CI</a> 是一套非常好的 Job 執行 Tool，可以幫忙跑專案測試，測試完成後繼續 Deploy 到相對應的伺服器，也可以自動寄信給開發者或者是指定的內部人員。在 <a href="http://www.ubuntu.com/" target="_blank">Ubuntu</a> 或 <a href="http://www.debian.org/" target="_blank">Debian</a> 安裝方式非常簡單，按照下述操作就可以簡易架設完成

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ aptitude -y install openjdk-7-jre openjdk-7-jdk
$ wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
$ sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
$ aptitude -y update
$ aptitude -y install jenkins</pre>
</div>

<!--more-->

安裝完成預設是 8080 port 如果要改成其他 port，或許你有裝 <a href="http://gitlab.org/" target="_blank">Gitlab</a> 你會發現 8080 已經被佔用了，請修改 **<span style="color:green">/etc/default/jenkins</span>**，將 **<span style="color:green">HTTP_PORT=8080</span>** 改成你想要的 port 即可。這時候請用 netstat -tanp | grep 8088 指令觀看服務是否有跑起來

<div>
  <pre class="brush: bash; title: ; notranslate" title="">tcp6  0  0 0.0.0.0:8088  :::*     LISTEN      31761/java</pre>
</div>

服務有正確跑起來，並且 Listen 在 0.0.0.0，如果你直接用瀏覽器打開 http://your_ip:8088，就可以看到 Jenkins 首頁，完全無任何認證，任何人都可以使用此網站，當然可以啟動 Jenkins 內建的使用者認證，設定後會發現一般使者還是可以看到 detail Job，比如說誰 commit 了 code … 等等，所以這邊介紹如何搭配 Nginx 的 User Auth 機制。

首先必須先把 IP 設定成只有 Listen 127.0.0.1，避免外面的人直接打 IP:PORT 連到網站，一樣設定 **<span style="color:green">/etc/default/jenkins</span>**

<div>
  <pre class="brush: bash; title: ; notranslate" title="">JENKINS_ARGS="--httpListenAddress=127.0.0.1 --webroot=/var/cache/jenkins/war --httpPort=$HTTP_PORT --ajp13Port=$AJP_PORT"</pre>
</div>

完成後請重新啟動 Jenkins，接著搭配 Nginx 用 Proxy 方式來導向 Jenkins 服務

<div>
  <pre class="brush: bash; title: ; notranslate" title="">upstream app_server {
    server 127.0.0.1:8088 fail_timeout=0;
}

server {
    listen 80;
    server_name xxxx.com;

    location / {
        proxy_redirect     off;

        proxy_set_header   Authorization $http_authorization;
        proxy_pass_header  Authorization;
        proxy_set_header   Host             $host;
        proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwared-User  $http_authorization;
        proxy_max_temp_file_size 0;
        if (!-f $request_filename) {
            proxy_pass http://app_server;
            break;
        }
    }
}</pre>
</div>

設定後請重新啟動 Nginx，這樣就可以直接使用 80 port 來瀏覽 Jenkins，最後搭配 <a href="http://wiki.nginx.org/HttpAuthBasicModule" target="_blank">Nginx Auth Module</a>，只要在 Location 加入兩行:

<div>
  <pre class="brush: bash; title: ; notranslate" title="">auth_basic "Restricted";
auth_basic_user_file /etc/nginx/.htpasswd;</pre>
</div>

產生帳號密碼可以透過底下指令:

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ htpasswd -c /etc/nginx/.htpasswd username</pre>
</div>

一樣重新啟動 Nginx 後，再度瀏覽網頁，就會跳出 popup 視窗，請你輸入密碼，這樣就可以防止任何人看到資料了。