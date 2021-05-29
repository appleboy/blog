---
title: '[筆記] Ubuntu apt-get update 出現 NO_PUBKEY / GPG error'
author: appleboy
type: post
date: 2012-05-10T06:07:52+00:00
url: /2012/05/how-to-resolve-apt-get-no_pubkey-gpg-error/
dsq_thread_id:
  - 683575457
dsq_needs_sync:
  - 1
categories:
  - Ubuntu
tags:
  - Debian
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6760100409/" title="logo-Ubuntu by appleboy46, on Flickr"><img src="https://i2.wp.com/farm8.staticflickr.com/7153/6760100409_b23d1ce67b_m.jpg?resize=240%2C165&#038;ssl=1" alt="logo-Ubuntu" data-recalc-dims="1" /></a>
</div> 當我們更新 Ubuntu/Debian 伺服器套件時，apt-get update 出現底下錯誤訊息 

<pre class="brush: bash; title: ; notranslate" title="">W: GPG error: http://ppa.launchpad.net maverick Release: 
The following signatures couldn't be verified because the public key is not available: 
NO_PUBKEY 1C1E55A728CBC482</pre>

<!--more--> 網路上找到一篇 

<a href="http://en.kioskea.net/faq/809-debian-apt-get-no-pubkey-gpg-error" target="_blank">[Debian] Apt-get : NO_PUBKEY / GPG error</a>，解決方式非常容易，上面錯誤訊息有告知 public key 是 <span style="color:red"><strong>1C1E55A728CBC482</strong></span>，透過底下兩個步驟就可以成功解決，**請注意務必將 public number 換成上面錯誤訊息的號碼** 

<pre class="brush: bash; title: ; notranslate" title="">gpg --keyserver pgpkeys.mit.edu --recv-key  1C1E55A728CBC482     
gpg -a --export 1C1E55A728CBC482 | sudo apt-key add -</pre> 之後再重新跑 apt-get update 即可。