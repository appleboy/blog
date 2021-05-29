---
title: 增加 phpMyAdmin 登入時間
author: appleboy
type: post
date: 2013-12-31T07:19:47+00:00
url: /2013/12/increase-phpmyadmin-login-time/
dsq_thread_id:
  - 2083185431
categories:
  - MySQL
  - php
  - sql
tags:
  - php
  - phpMyAdmin
  - Session

---
<img src="https://i0.wp.com/upload.wikimedia.org/wikipedia/commons/9/95/PhpMyAdmin_logo.png?w=840" alt="phpMyAdmin" data-recalc-dims="1" />

[phpMyAdmin][1] 是一套管理 MySQL 資料庫的 UI 介面工具，預設登入時間為 1440 秒，這時間是定義在 `libraries/config.default.php` 內，phpMyAdmin 也是透過 [gc-maxlifetime][2] 來決定 Session 存在與否，所以如果要增加登入時間，比如說設定一年 `(3600 * 24 * 365)` 好了，請按照底下設定

## PHP 設定檔

如果是裝 [php-fpm][3] 請修改 `/etc/php5/fpm/php.ini` 路徑

<pre><code class="language-shell">;After this number of seconds, stored data will be seen as \&#039;garbage\&#039; and ; cleaned up by the garbage collection process. 
; http://php.net/session.gc-maxlifetime 
session.gc_maxlifetime = 315360000</code></pre>

重新啟動 php-fpm

<pre><code class="language-shell">$ /etc/init.d/php5-fpm restart</code></pre>

## phpMyAdmin 設定檔

修改 `config.inc.php` 如果找不到此檔案，請複製 **config.sample.inc.php** 為 **config.inc.php**，接著增加底下設定即可

<pre><code class="language-php">$cfg[&#039;LoginCookieValidity&#039;] = 3600 * 24 * 365;</code></pre>

最後注意的是 `gc_maxlifetime` 設定值一定要超過 `LoginCookieValidity` 值，這樣才有作用

 [1]: http://www.phpmyadmin.net/home_page/index.php "phpMyAdmin"
 [2]: http://tw1.php.net/manual/en/session.configuration.php#ini.session.gc-maxlifetime
 [3]: http://php-fpm.org/