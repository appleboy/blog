---
title: Plurk API 2.0 beta 出來了 (OAuth Core 1.0a)
author: appleboy
type: post
date: 2011-05-19T04:01:04+00:00
url: /2011/05/plurk-api-2-0-beta-出來了-oauth-core-1-0a/
views:
  - 267
bot_views:
  - 102
dsq_thread_id:
  - 307619054
categories:
  - www
tags:
  - Plurk API

---
之前 [Plurk][1] 剛推出 [API][2] 讓大家可以使用，當時蠻多使用者相繼推出各式語言的支援，像是 [php-plurk-api][3]: PHP implementation，而我也將此程式改寫到 [CodeIgniter-Plurk-API][4]，然而現在官方又推出了 [Plurk API 2.0 beta][5]，不同的是 2.0 用了 [OAuth][6] 保護個人隱私，它提供了標準讓開發者可以利用 OAuth 實做任何 application，噗浪官網也希望各位開發者可以儘快將 API 轉成 2.0，當然也是要額外[註冊 Plurk App][7]。 底下幾點是 API 2.0 跟原來 API 的差異處: 

  * Plurk API 2.0 不需要登入作認證，然而原來的 API 是基於 session base 做開發
  * 網址改變，用 **<span style="color:green">http://www.plurk.com/APP/</span>** 取代原來的 **<span style="color:green">http://www.plurk.com/API/</span>**
  * 現在每個 Plurk API 2.0 請求都會按照 OAuth Core 1.0a 標準
  * 所有 input/output 參數跟原來都是一樣，只是現在不需要 api_key 在參數里面 大家註冊之後，可以拿到一組 App Key，就可以開始使用了 ^^

 [1]: http://www.plurk.com
 [2]: http://www.plurk.com/API/
 [3]: http://code.google.com/p/php-plurk-api/
 [4]: https://github.com/appleboy/CodeIgniter-Plurk-API
 [5]: http://www.plurk.com/API/2/
 [6]: http://zh.wikipedia.org/wiki/OAuth
 [7]: http://www.plurk.com/PlurkApp/register