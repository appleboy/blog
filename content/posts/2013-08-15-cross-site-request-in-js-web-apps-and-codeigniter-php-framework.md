---
title: Cross Site Request Forgery in JS Web Apps and CodeIgniter PHP Framework
author: appleboy
type: post
date: 2013-08-15T03:43:44+00:00
url: /2013/08/cross-site-request-in-js-web-apps-and-codeigniter-php-framework/
dsq_thread_id:
  - 1607146479
categories:
  - AJAX
  - CodeIgniter
  - javascript
  - jQuery
  - php
tags:
  - CodeIgniter
  - CSRF
  - jQuery
  - Ruby

---
Cross Site Request Forgery 簡稱 <a href="http://en.wikipedia.org/wiki/Cross-site_request_forgery" target="_blank">CSRF</a> 是網路上最常見的攻擊方式，由於前端的盛行，現在開發網站偏向前後端拆開，前端使用大量的 Javascript 及 CSS3 效果，後端則是使用 PHP, Ruby, Python… 等，前端如何拿到資料庫資料呢，必需透 過 AJAX 方式來存取，常見的後端 API 會設計成 <a href="http://en.wikipedia.org/wiki/Representational_state_transfer" target="_blank">RESTful</a> (GET/PUT/POST/DELETE)，後端為了擋住 CSRF 攻擊，所以限定了特殊 Content-Type Header，前端需要帶 application/json 給後端才可以拿到資料，這只能透過 Ajax requests 才可以做到。 <!--more--> 但是很不幸的是使用者還是透過 header injection 方式來達到目的 (Flash exploits)，所以透過判斷 Content-Type Header 這方式是不夠的。正確的防護方式就是在每個 request 給上一組 token，因為 same origin policy 關係，攻擊者無法拿到此 token，無法達到攻擊效果。 如果你是 Ruby 愛好者，可以透過 

<a href="https://github.com/baldowl/rack_csrf" target="_blank">Rack CSRF</a> 來產生 token，並且放在網頁 Head 內 

<meta content="nuSbBkEs6jRewNJUzrJTP1amsuqHkFn1G19lI0y07bs=" name="csrf-token" />
在 jQuery 部份，必須使用 
<a href="http://api.jquery.com/jQuery.ajaxPrefilter/" target="_blank">ajaxPrefilter</a> 將每個 Request 加上 CSRF token 傳給伺服器 

<pre class="brush: jscript; title: ; notranslate" title="">var CSRF_HEADER = 'X-CSRF-Token';
var setCSRFToken = function(securityToken) {
  jQuery.ajaxPrefilter(function(options, _, xhr) {
    if ( !xhr.crossDomain ) xhr.setRequestHeader(CSRF_HEADER, securityToken);
  });
};
setCSRFToken($('meta[name="csrf-token"]').attr('content'));</pre> 如果是在 Head 內加上 csrf-token 就必須透過上述作法，但是 

<a href="http://www.codeigniter.org.tw/" target="_blank">CodeIgniter</a> 並非是使用此方式，要將 CSRF 打開可以透過 config/config.php 內的 

<pre class="brush: php; title: ; notranslate" title="">$config['csrf_protection'] = FALSE;
$config['csrf_token_name'] = 'csrf-token';
$config['csrf_cookie_name'] = 'csrf-token';
$config['csrf_expire'] = 7200;</pre> 將 csrf_protection 改成 true，這樣透過 from helper 產生的 form 表單，你會發現會多出 hidden input value，這樣送出表單的時候就可以驗證此 token 是否正確，如果你不是透過 CI form 表單產生，那也可以在 Client 端抓取 csrf-token 的 Cookie 資料，因為 CI 也會同時將 csrf-token value 寫入 Cookie，Cookie 可以透過 

<a href="https://github.com/carhartl/jquery-cookie" target="_blank">jQuery cookie plugin</a> 來讀取。 另外如果你也想透過最上面 head 方式來處理，CI 那邊也可以透過 **<span style="color:green">$this->security->get_csrf_hash()</span>** 來取 hash 資料，將此資料放到 html head 裡面即可。