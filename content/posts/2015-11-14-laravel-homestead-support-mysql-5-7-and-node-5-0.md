---
title: Laravel Homestead 支援 MySQL 5.7 和 Node 5.0
author: appleboy
type: post
date: 2015-11-14T06:43:34+00:00
url: /2015/11/laravel-homestead-support-mysql-5-7-and-node-5-0/
dsq_thread_id:
  - 4317554737
categories:
  - Laravel
  - php
tags:
  - Homestead
  - Laravel
  - Laravel Homestead
  - Laravel news
  - php

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6248708214/" title="Laravel PHP Framework by appleboy46, on Flickr"><img src="https://i0.wp.com/farm7.static.flickr.com/6038/6248708214_ef1133d0e9_o.png?resize=283%2C101&#038;ssl=1" alt="Laravel PHP Framework" data-recalc-dims="1" /></a>
</div>

昨天半夜看到 [Laravel News][1] 發佈[支援 MySQL 5.7 和 Node 5.0 的消息][2]，作者已經將 Homestead Vagrant box 更新上最新版了，如果你是用 PHP7 版本，請更新到 0.1.1 (laravel/homestead-7 branch)，如果非用 PHP 5.7 請更新到 0.3.3 版本，此 Box 更新兩個項目，就是支援 [MySQL][3] 5.7 版本，及 [NodeJS][4] 5.0 版本，已經非常新的版號，透過底下指令就可以更新 Local 端的 Box Image:

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ vagrant box update</pre>
</div>

MySQL 5.7 版本支援了 [JSON Format][5] 真是太令人振奮了，另外此 Box 也是為了將來要釋出 [Laravel 5.2][6] 版本搭配用。最後補上升級後版本截圖

<div style="margin:0 auto; text-align:center">
  <a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/22583759038/in/datetaken-public/" title="Screen Shot 2015-11-14 at 2.41.31 PM"><img src="https://i1.wp.com/farm1.staticflickr.com/759/22583759038_e9558fda0c_z.jpg?resize=640%2C178&#038;ssl=1" alt="Screen Shot 2015-11-14 at 2.41.31 PM" data-recalc-dims="1" /></a>
</div>

 [1]: https://laravel-news.com
 [2]: https://laravel-news.com/2015/11/laravel-homestead-now-with-mysql-5-7-and-node-5-0/
 [3]: https://www.mysql.com/
 [4]: https://nodejs.org/en/
 [5]: https://dev.mysql.com/doc/refman/5.7/en/json.html
 [6]: https://laravel-news.com/2015/11/laravel-5-2-a-look-at-whats-coming/