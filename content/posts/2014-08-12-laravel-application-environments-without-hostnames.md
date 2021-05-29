---
title: Laravel 不同開發環境設定
author: appleboy
type: post
date: 2014-08-12T02:09:41+00:00
url: /2014/08/laravel-application-environments-without-hostnames/
dsq_thread_id:
  - 2919595747
categories:
  - Laravel
  - php
tags:
  - Framework
  - Laravel
  - php

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6248708214/" title="Laravel PHP Framework by appleboy46, on Flickr"><img src="https://i0.wp.com/farm7.static.flickr.com/6038/6248708214_ef1133d0e9_o.png?resize=283%2C101&#038;ssl=1" alt="Laravel PHP Framework" data-recalc-dims="1" /></a>
</div>

[Laravel][1] 本來預設的 [Environment Configuration][2] 是透過 Domain Name 來區分，程式碼 `bootstrap/start.php` 如下

<div>
  <pre class="brush: php; title: ; notranslate" title="">&lt;?php
$env = $app-&gt;detectEnvironment(array(
    'local' =&gt; array('your-machine-name'),
));</pre>
</div>

我們可以根據上述程式碼產生不同的開發環境，像是 develop, production, staging… 等，根據不同的 Domain 給予不同的環境設定檔。但是根據使用 Domain Name 來區分各種不同的環境換產生兩種問題

<!--more-->

  * 如果想單一 Domain 跑多種環境？
  * 多個 Domain 增加 Nginx 或 Apache 的設定檔

老實講用 Domain 來分類蠻不方便的，如果突然想要在同一個 Domain 使用不同的環境設定，又要改 Domain mapping。所以 Laravel 也不是強制要使用這方法，我們可以透過增加 `environment.php` 來決定目前專案跑哪一種環境設定，該程式碼只有一行

<div>
  <pre class="brush: php; title: ; notranslate" title="">&lt;?php

return "production";
/* End of bootstrap/environment.php */</pre>
</div>

那當然我們也要將 `detectEnvironment` 改成

<div>
  <pre class="brush: php; title: ; notranslate" title="">$env = $app-&gt;detectEnvironment(function() {

    // Defined in the server configuration
    if ( isset( $_SERVER['APP_ENVIRONMENT'] ) ) {
        return $_SERVER['APP_ENVIRONMENT'];

    // Look for ./environment.php
    } elseif ( file_exists( __DIR__ . '/environment.php' ) ) {
        return include __DIR__ . '/environment.php';

    // set default configuration
    } else {
        return 'local';
    }

});</pre>
</div>

Apaceh 可以直接在設定檔內定義變數如下，Laravel 可以透過 `$_SERVER['APP_ENVIRONMENT']` 取環境變數。如果沒有設定 Apache 變數，則讀取 `bootstrap/environment.php`，最後才會讀取預設值。

<div>
  <pre class="brush: bash; title: ; notranslate" title="">SetEnv APP_ENVIRONMENT development</pre>
</div>

 [1]: http://laravel.com/
 [2]: http://laravel.com/docs/configuration#environment-configuration