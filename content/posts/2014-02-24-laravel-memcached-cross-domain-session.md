---
title: Laravel 搭配 Memcached Cross Domain Session
author: appleboy
type: post
date: 2014-02-24T07:09:49+00:00
url: /2014/02/laravel-memcached-cross-domain-session/
dsq_thread_id:
  - 2312048688
categories:
  - Laravel
  - php
tags:
  - Laravel
  - memcache
  - Memcached
  - php
  - Session

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6248708214/" title="Laravel PHP Framework by appleboy46, on Flickr"><img src="https://i0.wp.com/farm7.static.flickr.com/6038/6248708214_ef1133d0e9_o.png?resize=283%2C101&#038;ssl=1" alt="Laravel PHP Framework" data-recalc-dims="1" /></a>
</div>

[Laravel][1] 提供了 `file`、`cookie`、`database`、`memcached`、`array` 五種方式來存取 [Session][2]，預設的使用方式會是 `file` 存取，如果要跨 Domain 存取 Session 基本上只要設定 `php.ini` 裡面的 Session 相關參數即可，請注意底下 3 個參數。

  * [session.save_handler][3]
  * [session.save_path][4]
  * [session.cookie_domain][5]

<!--more--> 完成後，只要是相同主網域內的 sub domain session 都可以互相存取，然而在 Laravel 內該如何設定，請先打開 

`app/config/session.php` 檔案，Laravel 預設使用 Native File Session Driver，看看原本設定

<div>
  <pre class="brush: php; title: ; notranslate" title="">'files' => storage_path().'/sessions',
'cookie' => 'laravel_session',
'domain' => null,</pre>
</div>

這三個參數都必須修改成底下

<div>
  <pre class="brush: php; title: ; notranslate" title="">'files' => 'your session folder path',
'cookie' => 'PHPSESSID',
'domain' => '.domain.com',</pre>
</div>

PHP 預設 Session cookie name 是 `PHPSESSID`，另外 Laravel Session 存放位置請跟 `php.ini` 內設定位置一樣。到這邊設定倒是沒有什麼問題，如果改成使用 [Memcached][6] 來存放 Session，會發生無法存取同一個 Session。請先將 php.ini 改成底下設定

<div>
  <pre class="brush: bash; title: ; notranslate" title="">php_value[session.save_handler] = memcached
php_value[session.save_path] = "192.168.1.102:11211"
php_value[session.cookie_domain] = ".example.com"</pre>
</div>

另外 Laravel Session 設定請改成

<div>
  <pre class="brush: php; title: ; notranslate" title="">'driver' => 'memcached',
'cookie' => 'PHPSESSID',
'domain' => '.example.com',</pre>
</div>

要設定 Memcached Server 請修改 `app/config/cache.php`

<div>
  <pre class="brush: php; title: ; notranslate" title="">'memcached' => array(
    array('host' => '192.168.1.102', 'port' => 11211, 'weight' => 100),
),</pre>
</div>

但是這樣是不會通的，因為如果改成 Laravel Memcached Session Driver，那麼寫入跟讀出的 Session handle 將會被 Laravel Driver 取代，所以永遠拿不到一樣的 Session，此解法就是將 Session Driver 調回 Native Driver，並且修改 `HttpFoundation/Session/Storage/Handler/NativeFileSessionHandler.php` 檔案，此檔案放在 `vendor/symfony/http-foundation/Symfony/Component/` 將底下兩行程式碼註解掉即可。

<div>
  <pre class="brush: php; title: ; notranslate" title="">ini_set('session.save_path', $savePath);
ini_set('session.save_handler', 'files');</pre>
</div>

這不是很正規的解法，不過提供給有需要搭配 Memcached 的開發者一個方向。

 [1]: http://laravel.com/
 [2]: http://laravel.com/docs/session
 [3]: http://tw1.php.net/manual/en/session.configuration.php#ini.session.save-path
 [4]: http://tw1.php.net/manual/en/session.configuration.php#ini.session.save-handler
 [5]: http://tw1.php.net/manual/en/session.configuration.php#ini.session.cookie-domain
 [6]: http://memcached.org/