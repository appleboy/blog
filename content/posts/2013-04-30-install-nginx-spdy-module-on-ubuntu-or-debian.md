---
title: Install Nginx + spdy module on Ubuntu or Debian
author: appleboy
type: post
date: 2013-04-30T15:42:30+00:00
url: /2013/04/install-nginx-spdy-module-on-ubuntu-or-debian/
dsq_thread_id:
  - 1248352594
categories:
  - Nginx
  - Ubuntu
tags:
  - nginx
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8684224387/" title="nginx-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm9.staticflickr.com/8401/8684224387_19de454ebf.jpg?resize=320%2C120&#038;ssl=1" alt="nginx-logo" data-recalc-dims="1" /></a>
</div> 上一篇提到 

<a href="http://blog.wu-boy.com/2013/04/nginx-1-4-0-support-spdy-module/" target="_blank">nginx 1.4.0 釋出並支援 SPDY</a>，教學環境是 CentOS，這次在 Ubuntu 環境編譯遇到 

> /usr/bin/ld: cannot find -lperl 找不到 perl library，解法可以透過 aptitude 安裝 libperl5.14，安裝好後，到 /usr/lib 底下找到 libperl.so.5.14.2，由於檔案命名關係，請用 ln 將檔案 link 成 libperl.so 

<pre class="brush: bash; title: ; notranslate" title="">$ ln -s libperl.so.5.14.2 libperl.so</pre> 接著可以正確編譯了，底下安裝相關套件 

<pre class="brush: bash; title: ; notranslate" title="">$ aptitude -y install libpcre3-dev libgd-dev libgd2-xpm-dev libgeoip-dev</pre>