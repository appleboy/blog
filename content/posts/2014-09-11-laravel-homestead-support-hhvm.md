---
title: Laravel Homestead 開始支援 HHVM
author: appleboy
type: post
date: 2014-09-11T03:13:01+00:00
url: /2014/09/laravel-homestead-support-hhvm/
dsq_thread_id:
  - 3007123273
categories:
  - Laravel
  - php
tags:
  - Laravel
  - Laravel Homestead
  - Laravel news
  - php

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6248708214/" title="Laravel PHP Framework by appleboy46, on Flickr"><img src="https://i0.wp.com/farm7.static.flickr.com/6038/6248708214_ef1133d0e9_o.png?resize=283%2C101&#038;ssl=1" alt="Laravel PHP Framework" data-recalc-dims="1" /></a>
</div>

在 [Laravel News][1] 看到這篇 [Laravel Homestead – Now with HHVM][2]，也就是官方 Homestead 開始支援 [HHVM][3]，現在可以直接透過底下指令升級 Box:

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ vagrant box update</pre>
</div>

版本會從 `0.1.8` 升級到 `0.1.9`，升級過程需要一段時間，最後要啟用 HHVM 服務，請在 `Homestead.yaml` 加入底下設定

<div>
  <pre class="brush: bash; title: ; notranslate" title="">sites:
  - map: homestead.app
    to: /home/vagrant/Code/Laravel/public
    hhvm: true</pre>
</div>

不用煩惱架設 HHVM 環境了，對開發者真是一大幅音。

 [1]: http://laravel-news.com/
 [2]: http://laravel-news.com/2014/09/laravel-homestead-now-hhvm/
 [3]: http://hhvm.com/