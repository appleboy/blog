---
title: 'Ngnix 搭配 PHP-FPM 噴 php5-fpm.sock failed (13: Permission denied)'
author: appleboy
type: post
date: 2014-06-25T02:43:13+00:00
url: /2014/06/ngnix-php5-fpm-sock-failed-permission-denied/
dsq_thread_id:
  - 2793001025
categories:
  - Nginx
  - php
tags:
  - nginx
  - php
  - php-fpm

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8684224387/" title="nginx-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm9.staticflickr.com/8401/8684224387_19de454ebf.jpg?resize=320%2C120&#038;ssl=1" alt="nginx-logo" data-recalc-dims="1" /></a>
</div>

[Nginx][1] 搭配 [PHP-FPM][2] 已經是架設 PHP 伺服器基本入門款了，這次升級 CentOS 機器完後，發現 Log 一直噴出底下訊息

> nginx error connect to php5-fpm.sock failed (13: Permission denied)
透過 [Stackoverflow][3] 查到這篇解答 [nginx error connect to php5-fpm.sock failed (13: Permission denied)][4]，裡面提到兩種作法，其中一解法是直接修改 `/var/run/php5-fpm.sock` 為 666，讓其他使用者可以直接存取此檔案，但是此作法在下次重新開機後一樣會出現同問題，最終解法請修改 `/etc/php-fpm.d/www.conf` 如果是搭配 Nginx 請使用底下設定

<div>
  <pre class="brush: bash; title: ; notranslate" title="">user = nginx
group = nginx
; Set permissions for unix socket, if one is used. In Linux, read/write
; permissions must be set in order to allow connections from a web server. Many
; BSD-derived systems allow connections regardless of permissions.
; Default Values: user and group are set as the running user
;                 mode is set to 0666
listen.owner = nginx
listen.group = nginx
listen.mode = 0666</pre>
</div>

 [1]: http://nginx.org/
 [2]: http://php-fpm.org/
 [3]: http://stackoverflow.com/
 [4]: http://stackoverflow.com/questions/23443398/nginx-error-connect-to-php5-fpm-sock-failed-13-permission-denied