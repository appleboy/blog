---
title: Laravel 5.1 is released
author: appleboy
type: post
date: 2015-06-10T01:38:00+00:00
url: /2015/06/laravel-5-1-is-released/
dsq_thread_id:
  - 3835846827
categories:
  - Laravel
  - php
tags:
  - Laravel
  - php

---
<img src="https://i2.wp.com/d1zj60nuin5mrx.cloudfront.net/media/2015/06/07203934/laravel-5.1-released.png?w=640&#038;ssl=1" alt="" data-recalc-dims="1" />

很高興昨天收到 [Laravel][1] 釋出 5.1 版本，此版本在 Laravel 發展過程中第一個長期支援的版本，底下我們就來看看 Taylor Otwell 作者在此版本釋出有什麼新功能或變化。

<!--more-->

### 長期支援 5.1 版本 (第一個 LTS 版本)

自從 Laravel 在 2011 年釋出第一個版本以來，作者都採用 "release early, release often" 的方式讓開發者享有最新的功能，所以在全世界各大 PHP Framework 評比底下，[Laravel 始終擁有第一名的頭銜][2]，這時間點要開始規劃一個長期使用的版本，讓大型專案可以專注於安全性修正，而並非快速升級版本。所以 Laravel 5.1 官方打算支援 <span style="color:red;font-weight: bold">3 年的安全性修正</span>。

長期支援是 5.1 的新功能之一，當然 5.1 也有更多新功能。

### 新文件

Laravel 作者將文件整個翻過一遍，讓開發者可以更清楚地閱讀，這是一個非常艱鉅的任務，花了無數個小時來微調每一頁。Taylor 說他寧用延遲釋出的時間，也不要是出一個不好閱讀的文件，花這麼多的時間是值得的，因為[新版文件][3]支援快速搜尋，讓開發者可以快速找到您要的關鍵字文件

<img src="https://i0.wp.com/d1zj60nuin5mrx.cloudfront.net/media/2015/06/09091213/laravel-documentation-search-1024x412.png?w=640&#038;ssl=1" alt="" data-recalc-dims="1" /> 

### PSR-2

很高興聽到作者終於將整個專案支援 [PSR-2 Coding Style][4]，其實最主要是將 tabs 全部轉換成 spaces，另外將 control structures 全部改成在同一行，例如底下

<div>
  <pre class="brush: php; title: ; notranslate" title="">if (....)
{
}
</pre>
</div>

改成

<div>
  <pre class="brush: php; title: ; notranslate" title="">if (....) {
}
</pre>
</div>

### Resolve a service from blade

現在可以直接在 Blade Template 內 resolve a service

<div>
  <pre class="brush: php; title: ; notranslate" title="">@extends('layouts.app')
@inject('stats', 'StatisticsService')
<div>{{ $stats->getCustomerCount() }}</div></pre>
</div>

### Broadcasting Events 廣播事件

Laravel 已經支援強大的事件系統，現在更支援 Broadcasting Events，讓開發者可以透過 websocket 方式將資料傳給 client 端，此功能讓您簡單地開發一套 real-time 系統。

### Better Application Unit Testing 更強大的測試

導入 laracasts 的測試套件讓開發者可以更簡單的寫測試程式

<div>
  <pre class="brush: php; title: ; notranslate" title="">public function testNewUserRegistration()
{
    $this->visit('/register')
         ->type('Taylor', 'name')
         ->check('terms')
         ->press('Register')
         ->seePageIs('/dashboard');
}</pre>
</div>

如果想了解更多 5.1 新功能，請參考 [Everything we know about Laravel 5.1 – Updated][5]，另外可以到 [Laracasts video series][6] 觀看 5.1 功能，或者是 [Matt Stauffer 寫了一系列 5.1 文章][7]。

參考: [Laravel 5.1 is released][8]

 [1]: http://laravel.com/
 [2]: https://laravel-news.com/2015/03/laravel-is-number-one-again/
 [3]: http://laravel.com/docs/5.1
 [4]: https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-2-coding-style-guide.md
 [5]: https://laravel-news.com/2015/04/laravel-5-1/
 [6]: https://laracasts.com/series/whats-new-in-laravel-5-1
 [7]: https://mattstauffer.co/blog/series/new-features-in-laravel-5.1
 [8]: https://laravel-news.com/2015/06/laravel-5-1-released