---
title: Jenkins + Apache User Auth
author: appleboy
type: post
date: 2013-12-08T12:45:16+00:00
url: /2013/12/jenkins-apache-auth-setting/
dsq_thread_id:
  - 2035145520
categories:
  - Network
  - Nginx
  - Ubuntu
  - www
tags:
  - apache
  - Jenkins
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/10830034484/" title="jenkins_logo by appleboy46, on Flickr"><img src="https://i0.wp.com/farm6.staticflickr.com/5507/10830034484_95cba45707.jpg?resize=398%2C128&#038;ssl=1" alt="jenkins_logo" data-recalc-dims="1" /></a>
</div>

上個月寫過一篇如何設定 <a href="http://nginx.org/" target="_blank">Nginx</a> + <a href="http://jenkins-ci.org/" target="_blank">Jenkins</a> 文章，可以參考: <a href="http://blog.wu-boy.com/2013/11/jenkins-nginx-auth/" target="_blank">Jenkins + Nginx User Auth</a>，這次筆記 Jenkins + <a href="http://httpd.apache.org" target="_blank">Apache</a> 設定方式 <!--more-->

### 安裝 Jenkins

在 Ubuntu 環境，可以直接參考 <a href="https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Ubuntu" target="_blank">Installing Jenkins on Ubuntu</a>

<pre class="brush: bash; title: ; notranslate" title="">$ wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
$ sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
$ sudo apt-get update
$ sudo apt-get install jenkins</pre>

### 設定 Apache

如果您是需要用一個特定 domain 也就是 jenkein.example.com，沒有 sub folder，你可以透過底下設定

啟用 Apache proxy 模組

<pre class="brush: bash; title: ; notranslate" title="">$ a2enmod proxy
$ a2enmod proxy_http</pre>

<a href="http://httpd.apache.org/docs/current/vhosts/" target="_blank">Apache virtual host</a> 部份加入底下設定

<pre class="brush: bash; title: ; notranslate" title="">ProxyRequests Off
<Proxy *>
    Order deny,allow
    Allow from all
</Proxy>
ProxyPreserveHost On
ProxyPass / http://127.0.0.1:8080
</pre>

設定到這邊，重新啟動 Apache 即可，如果你是使用 sub folder 的方式，有就是透過 www.example.com/jenkins 方式瀏覽，請換成底下設定

<pre class="brush: bash; title: ; notranslate" title="">ProxyRequests Off
<Proxy *>
    Order deny,allow
    Allow from all
</Proxy>
ProxyPreserveHost On
ProxyPass /jenkins http://127.0.0.1:8080/jenkins</pre>

但是你會發現 css, js, image 都讀取錯誤。這時候請修改 **<span style="color:green">/etc/default/jenkins</span>** 將 JENKINS_ARGS 加入 --prefix 設定

<pre class="brush: bash; title: ; notranslate" title="">JENKINS_ARGS="--prefix=$PREFIX --httpListenAddress=127.0.0.1 --webroot=/var/cache/jenkins/war --httpPort=$HTTP_PORT --ajp13Port=$AJP_PORT"</pre>

重新啟動 Jenkins 及 Apache 即可。最後透過 htpasswd 將 jenkins web 目錄鎖起來

<pre class="brush: bash; title: ; notranslate" title=""><Location /jenkins/>
    AuthType basic
    AuthName "jenkins"
    AuthUserFile "/etc/apache2/conf/.htpasswd"
    Require valid-user
</Location></pre>