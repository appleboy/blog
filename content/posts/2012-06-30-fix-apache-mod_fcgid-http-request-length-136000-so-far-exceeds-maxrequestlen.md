---
title: '[筆記] 解決 apache mod_fcgid: HTTP request length 136000 (so far) exceeds MaxRequestLen (131072)'
author: appleboy
type: post
date: 2012-06-30T00:41:29+00:00
url: /2012/06/fix-apache-mod_fcgid-http-request-length-136000-so-far-exceeds-maxrequestlen/
dsq_thread_id:
  - 745433773
categories:
  - apache
  - Ubuntu
tags:
  - apache
  - fastcgi
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6760100409/" title="logo-Ubuntu by appleboy46, on Flickr"><img src="https://i2.wp.com/farm8.staticflickr.com/7153/6760100409_b23d1ce67b_m.jpg?resize=240%2C165&#038;ssl=1" alt="logo-Ubuntu" data-recalc-dims="1" /></a>
</div> 上次寫了一篇 

<a href="http://blog.wu-boy.com/2012/05/php-fastcgi-with-nginx-on-ubuntu-10-10-maverick/" target="_blank">Ubuntu 10.10 (Maverick) 架設 Nginx + PHP FastCGI</a>，不過在 PHP 上傳檔案部份發現了問題，打開 <span style="color:green">/var/log/apache2/error.log</span> 發現底下錯誤訊息: 

> mod_fcgid: HTTP request length 136000 (so far) exceeds MaxRequestLen (131072) 上網找了一下是 fcgid.conf 設定錯誤，解決方式非常簡單，只要打開 <span style="color:green"><strong>/etc/apache2/mods-available/fcgid.conf</strong></span>，將底下內容 <!--more-->

<pre class="brush: bash; title: ; notranslate" title="">&lt;IfModule mod_fcgid.c>
  AddHandler    fcgid-script .fcgi
  FcgidConnectTimeout 20
&lt;/IfModule></pre> 取代成 

<pre class="brush: bash; title: ; notranslate" title="">&lt;IfModule mod_fcgid.c>
  AddHandler    fcgid-script .fcgi
  FcgidConnectTimeout 20
  # to get around upload errors when uploading images increase the MaxRequestLen size to 15MB
  MaxRequestLen 15728640
&lt;/IfModule></pre> 如果檔案上傳時間不夠，又會出現底下錯誤 

<pre class="brush: bash; title: ; notranslate" title="">mod_fcgid: read data timeout in 40 seconds
Premature end of script headers: index.php</pre> 所以我們將設定檔再改成底下就可以了 

<pre class="brush: bash; title: ; notranslate" title="">&lt;IfModule mod_fcgid.c>
  AddHandler    fcgid-script .fcgi

  # fix for:   mod_fcgid: read data timeout in 40 seconds
  IdleTimeout 3600
  DefaultMinClassProcessCount 100
  FcgidConnectTimeout 120
  IPCCommTimeout 400

  # to get around upload errors when uploading images increase the MaxRequestLen size to 15MB
  MaxRequestLen 15728640
&lt;/IfModule></pre> 最後附上個人 fcgid.conf 設定檔給大家參考 

<pre class="brush: bash; title: ; notranslate" title="">&lt;IfModule mod_fcgid.c>
  AddHandler    fcgid-script .fcgi .php
  FcgidConnectTimeout 20
  FcgidIPCDir /var/lib/apache2/fcgid/sock
  IdleTimeout 3600
  ProcessLifeTime 7200
  MaxProcessCount 1000
  DefaultMinClassProcessCount 3
  DefaultMaxClassProcessCount 100
  IPCConnectTimeout 8
  IPCCommTimeout 360
  BusyTimeout 300
  FcgidWrapper /usr/bin/php5-cgi .php
  MaxRequestLen 15728640
&lt;/IfModule></pre> 參考網站: 

<a href="http://blog.philippklaus.de/2011/04/fix-mod_fcgid-http-request-length-xyz-so-far-exceeds-maxrequestlen-131072/" target="_blank">[fix] mod_fcgid: HTTP request length xyz (so far) exceeds MaxRequestLen (131072)</a>