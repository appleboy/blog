---
title: Debian 7.x Install PHP 5.5 或 5.6 版本
author: appleboy
type: post
date: 2015-01-20T05:06:10+00:00
url: /2015/01/install-php-5-6-or-5-5-on-debian/
dsq_thread_id:
  - 3437101539
categories:
  - Linux
  - php
  - Ubuntu
tags:
  - Debian
  - php
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/15703430593" title="screen by Bo-Yi Wu, on Flickr"><img src="https://i1.wp.com/farm8.staticflickr.com/7487/15703430593_ffa1a49a44.jpg?resize=500%2C305&#038;ssl=1" alt="screen" data-recalc-dims="1" /></a>
</div>

[Debian][1] 目前預設的 [PHP][2] Stable 版本是 5.4.x，由於 Laravel PHP Framework 關係，所以希望升級到 PHP 5.5 或 5.6 版本，只要透過底下操作就可以直接裝 PHP 5.6 版本了

<!--more-->

<div>
  <pre class="brush: bash; title: ; notranslate" title="">
echo "deb http://packages.dotdeb.org wheezy-php56 all" >> /etc/apt/sources.list.d/dotdeb.list
echo "deb-src http://packages.dotdeb.org wheezy-php56 all" >> /etc/apt/sources.list.d/dotdeb.list</pre>
</div>

完成後請加入 apt key，如果是要安裝 PHP 5.5 請將 `wheezy-php56` 改成 `wheezy-php55`

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ wget http://www.dotdeb.org/dotdeb.gpg -O- | apt-key add -</pre>
</div>

接著更新 apt repository 及安裝 PHP 5.6

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ aptitude update
$ aptitude install php5-cli php5-fpm
</pre>
</div>

如果有安裝 `php5-memcached` 時，會遇到找不到 `libmemcached11` 套件，這時候請在 repository list 加入

<div>
  <pre class="brush: bash; title: ; notranslate" title="">deb http://packages.dotdeb.org wheezy all</pre>
</div>

接著再重新安裝一次 [php5-memcached][3] 即可

 [1]: https://www.debian.org/
 [2]: http://php.net/
 [3]: http://php.net/manual/en/book.memcached.php