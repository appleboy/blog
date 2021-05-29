---
title: PHP 7 vs HHVM Benchmark 比較
author: appleboy
type: post
date: 2015-12-09T02:12:01+00:00
url: /2015/12/the-definitive-php-7-final-version-hhvm-benchmark/
dsq_thread_id:
  - 4387782434
categories:
  - php
  - wordpress
tags:
  - Drupal
  - HHVM
  - php
  - PHP 7
  - wordpress

---
<div style="margin: 0 auto;text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6034284842/" title="php-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm7.static.flickr.com/6186/6034284842_351ff33711_m.jpg?resize=240%2C127&#038;ssl=1" alt="php-logo" data-recalc-dims="1" /></a>
</div>

2015-12-03 [PHP][1] 終於釋出 [7.0 版本][2]，[kinsta][3] 工程師馬上寫出一篇 [PHP7 vs HHVM 效能比較文章][4]，直接先講結論，就是 HHVM 效能還是大於 PHP 7，所以 kinsta 最終還是採用 [HHVM][5] 來 Host [WordPress][6] 網站，文章內容都是以 CMS 平台做比較，而不是以各大 Framework 來比較，但是看結果來說，`HHVM > PHP7 >> PHP 5`，所以建議可以升級到 PHP 7 或者是直接上 HHVM 也可以了。底下是 WordPress benchmark 比較圖。

<!--more-->

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23594864116/in/dateposted-public/" title="Copy-of-Copy-of-Transactions-per-second"><img src="https://i1.wp.com/farm1.staticflickr.com/632/23594864116_b202a30a60_z.jpg?resize=640%2C360&#038;ssl=1" alt="Copy-of-Copy-of-Transactions-per-second" data-recalc-dims="1" /></a>

WordPress 效能看起來非常相近，如果是測試 [Drupal][7] 8.0.1 效能差距會比較大 (Drupal 每分鐘線上 15 人)

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/22994012943/in/dateposted-public/" title="Drupal-8"><img src="https://i1.wp.com/farm1.staticflickr.com/633/22994012943_1136a42a4d_z.jpg?resize=640%2C360&#038;ssl=1" alt="Drupal-8" data-recalc-dims="1" /></a>

要升級到 7.0 的開發者，請先看完 [PHP Migration Guide][8]。

 [1]: http://php.net
 [2]: http://php.net/index.php#id2015-12-03-1
 [3]: https://kinsta.com
 [4]: https://kinsta.com/blog/the-definitive-php-7-final-version-hhvm-benchmark/
 [5]: http://hhvm.com/
 [6]: https://wordpress.com/
 [7]: https://www.drupal.org/
 [8]: http://php.net/manual/en/migration70.php