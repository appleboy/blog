---
title: Laravel 搭配 Google, Facebook, Twitter 第三方 OAuth 認證
author: appleboy
type: post
date: 2016-01-14T14:53:27+00:00
url: /2016/01/laravel-socialite-with-google-facebook-twitter/
dsq_thread_id:
  - 4490615321
categories:
  - Laravel
  - php
tags:
  - google
  - Laravel
  - php
  - Socialite
  - Twitter

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23493872563/in/dateposted-public/" title="laravel"><img src="https://i1.wp.com/farm2.staticflickr.com/1655/23493872563_4f01a9c336_o.png?resize=400%2C400&#038;ssl=1" alt="laravel" data-recalc-dims="1" /></a>

[Laravel][1] 提供了 [Socialite][2] 套件讓開發者可以快速整合 Facebook, Twitter, [Google][3], LinkedIn, GitHub and Bitbucket 等第三方服務的登入認證，我挑了大家最常使用的 Facebook, Twitter, Google 來整合，用 Google 跟 Twitter 需要注意一些小細節，首先是 Google 部分，如果大家去 [Developer console][4] 把 Oauth Callback 寫完，注意的是，這樣是不夠的，要去把 `Contacts API` 及 `Google+ API` 啟用，才可以真正使用 Google OAuth 認證服務。

<!--more-->

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/24267964012/in/dateposted-public/" title="Screen Shot 2016-01-14 at 10.28.14 PM"><img src="https://i2.wp.com/farm2.staticflickr.com/1673/24267964012_3308c7aa69_z.jpg?resize=640%2C167&#038;ssl=1" alt="Screen Shot 2016-01-14 at 10.28.14 PM" data-recalc-dims="1" /></a>

另外 [Twitter App][5] 部分，建立 App 請注意不要寫 localhost，要寫 127.0.0.1 這樣就可以送出了，預設的 Twitter App 是不給授權帳戶 Email 欄位，如果要拿到使用者 Email，請填寫[此表單][6]請官方開啟 Email 欄位權限服務即可，過幾天就會收來自 Twitter 底下信件

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/24293707031/in/dateposted-public/" title="Screen Shot 2016-01-12 at 8.38.09 AM"><img src="https://i1.wp.com/farm2.staticflickr.com/1487/24293707031_0504e2439f_z.jpg?resize=640%2C636&#038;ssl=1" alt="Screen Shot 2016-01-12 at 8.38.09 AM" data-recalc-dims="1" /></a>

最後到 App Console 介面就會看到多出額外權限設定選項，將其打勾就可以了。

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/24293706651/in/dateposted-public/" title="Screen Shot 2016-01-12 at 9.20.15 AM"><img src="https://i0.wp.com/farm2.staticflickr.com/1534/24293706651_99a919a1b7_z.jpg?resize=640%2C341&#038;ssl=1" alt="Screen Shot 2016-01-12 at 9.20.15 AM" data-recalc-dims="1" /></a>

 [1]: https://laravel.com/
 [2]: https://github.com/laravel/socialite
 [3]: https://www.google.com
 [4]: https://console.developers.google.com
 [5]: https://apps.twitter.com/
 [6]: https://support.twitter.com/forms/platform