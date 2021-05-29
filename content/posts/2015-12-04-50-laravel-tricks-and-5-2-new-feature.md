---
title: Laravel 50 個小技巧 + Laravel 5.2 新功能
author: appleboy
type: post
date: 2015-12-04T15:14:25+00:00
url: /2015/12/50-laravel-tricks-and-5-2-new-feature/
categories:
  - Laravel
  - MySQL
  - php
tags:
  - JSON
  - Laravel
  - MySQL
  - php

---
<div style="margin:0 auto; text-align:center">
  <a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23207680879/in/dateposted-public/" title="laravel"><img src="https://i1.wp.com/farm6.staticflickr.com/5765/23207680879_9c86233e9b.jpg?resize=300%2C300&#038;ssl=1" alt="laravel" data-recalc-dims="1" /></a>
</div>

在學習 [Laravel][1] 階段，一定會天天看 [Laravel Documentation][2]，但是有很多小技巧是在文件內沒寫出來的，網路上找到這篇 [50 Laravel Tricks in 50 Minutes][3]，寫了 50 個 Laravel 小技巧，包含了 IoC Container, Blade, Eloquent, Middleware, Routing, Commands, Queues, Events, Caching 等模組。

<!--more-->

當然作者最後不只介紹了 50 個小技巧，另外也展示了 Laravel 5.2 的新功能，像是可以在 Routing 內寫 Modle Binding，所以非常推薦大家看這 Slides。底下列出 Laravel 5.2 新功能

### 在 Routing 內可以直接 binding Model

<div>
  <pre class="brush: php; title: ; notranslate" title="">Route::get('/api/posts/{post}', function(Post $post) {
    return $post;
});</pre>
</div>

### scheduled tasks 支援 log 連續寫入檔案

<div>
  <pre class="brush: php; title: ; notranslate" title="">$schedule->command('emails:send')
    ->hourly()
    ->appendOutputTo($filePath);</pre>
</div>

### 支援 Array 驗證

html 寫法如下

<div>
  <pre class="brush: xml; title: ; notranslate" title=""><p>
  <input type="text" name="person[1][id]">
  <input type="text" name="person[1][name]">
</p>
<p>
  <input type="text" name="person[2][id]">
  <input type="text" name="person[2][name]">
</p></pre>
</div>

在 Laravel 5.1 要用 loop 方式驗證，但是 5.2 可以改寫如下

<div>
  <pre class="brush: php; title: ; notranslate" title="">$v = Validator::make($request->all(), [
  'person.*.id' => 'exists:users.id',
  'person.*.name' => 'required:string',
]);</pre>
</div>

### Collection 支援 Wildcards 功能

要讀取 posts 底下所有的 Title 可以寫成如下

<div>
  <pre class="brush: php; title: ; notranslate" title="">$posts->pluck('posts.*.title');</pre>
</div>

### Database Session Driver 多支援兩個欄位

資料庫 Session Driver 多支援 `user_id` 及 `ip_address`，這樣就可以很快速的清除單一帳號的 Session。

### MySQL 支援 JSON Type

[MySQL][4] 5.7.8 之後支援 [JSON Type][5]，現在 Laravel 5.2 也會開始支援 JSON Type。

 [1]: http://laravel.tw/
 [2]: http://laravel.tw/docs/5.1
 [3]: https://speakerdeck.com/willroth/50-laravel-tricks-in-50-minutes
 [4]: https://www.mysql.com/
 [5]: https://dev.mysql.com/doc/refman/5.7/en/json.html