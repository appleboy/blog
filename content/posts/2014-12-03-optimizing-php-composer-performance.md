---
title: 加速 PHP Composer 執行效率
author: appleboy
type: post
date: 2014-12-03T05:33:54+00:00
url: /2014/12/optimizing-php-composer-performance/
dsq_thread_id:
  - 3285452727
categories:
  - php
tags:
  - Composer
  - Laravel
  - php

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/15747689648" title="logo-composer-transparent by Bo-Yi Wu, on Flickr"><img src="https://i2.wp.com/farm9.staticflickr.com/8658/15747689648_a4e7ccfca9_m.jpg?resize=202%2C240&#038;ssl=1" alt="logo-composer-transparent" data-recalc-dims="1" /></a>
</div>

早上剛起床就看到 [DK][1] 發表一篇[增加一行程式碼讓 PHP Composer 效率爆增][2]，[Composer][3] 是 PHP 套件管理工具，現在各大 Framework 都用 Composer 管理套件相依性，但是最讓人擔憂的是，每次執行 `composer install` 或 update 的時候，機器就會開始哀號，然後等了很久指令才執行完成。今天看到 [Github][4] 上 Composer 為了改善執行效率及時間[就把 gc disabled][5]。這 commit 引發了很多人迴響，超多搞笑留言圖片。底下有兩種方式可以加速 Composer 執行效率

<!--more-->

## 更新 Composer 到最新版

請透過 `composer self-update` 將 composer 更新到最新版，因為今天已經將 `gc_disable` 納入官方程式碼內了。

<div>
  <pre class="brush: php; title: ; notranslate" title="">/**
* Run installation (or update)
*
* @return int 0 on success or a positive error code on failure
*
* @throws \Exception
*/
public function run()
{
    gc_disable();</pre>
</div>

測試數據如下，原本

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ composer update --dry-run --profile
# Memory usage: 164.29MB (peak: 393.37MB), time: 82.9s</pre>
</div>

關閉 gc 後

<div>
  <pre class="brush: bash; title: ; notranslate" title=""># Memory usage: 163.99MB (peak: 318.46MB), time: 47.14s</pre>
</div>

如果尚未更新 composer 到最新版，可以透過底下指令:

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ php -d zend.enable_gc=0 composer update --dry-run --profile</pre>
</div>

其實真正原因是出在 GC，可以參考[此留言][6]

> This might indeed be a GC issue. If there are many objects created - all of which cannot be cleaned-up. PHP's GC will kick in frequently trying to clean-up, only to discover that it cannot clean-up anything, and just wastes time/CPU cycles. This might be the reason why you see the effect for big projects (= many objects), but not so much for small projects (= GC is not kicking in frequently). In these cases, disabling GC entirely is a lot faster (at the cost of some more memory consumption ofc). If no-one has checked yet, it might be worth to add gc_disable() to the update/install command.
## 保留 composer.lock

在還沒有關閉 GC ([Garbage Collection][7]) 之前，可以透過 cache 來減少 composer 執行時間，[Laravel][8] 本來將 `composer.lock` 放入 `.gitignore` 內，現在我們將此行拿掉，也就是不要任意升級版本，避免讓程式 crash 掉。並且透過底下指令來初始化專案，保留 `composer.lock` 有兩個好處

  * 不會因為 `composer update` 讓整個專案爛掉
  * Deploy 時 `composer install` 會直接從本地端抓取相依程式碼

底下為 Deploy 上 Production 時所執行的指令

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ composer install --prefer-dist --no-dev --no-scripts</pre>
</div>

第一次由於沒有 cache，會比較慢，等到第二次安裝時，就可以減少一大半時間。

 [1]: https://blog.gslin.org
 [2]: https://blog.gslin.org/archives/2014/12/02/5383/%E5%A2%9E%E5%8A%A0%E4%B8%80%E8%A1%8C%E7%A8%8B%E5%BC%8F%E7%A2%BC%E8%AE%93-php-composer-%E6%95%88%E7%8E%87%E7%88%86%E5%A2%9E/
 [3]: https://getcomposer.org/
 [4]: http://github.com
 [5]: https://github.com/composer/composer/commit/ac676f47f7bbc619678a29deae097b6b0710b799
 [6]: https://github.com/composer/composer/pull/3482#issuecomment-65131942
 [7]: http://php.net/manual/en/features.gc.php
 [8]: http://laravel.tw