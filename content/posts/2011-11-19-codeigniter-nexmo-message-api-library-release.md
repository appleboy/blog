---
title: 新版 CodeIgniter Nexmo Message API Library Release
author: appleboy
type: post
date: 2011-11-19T07:42:53+00:00
url: /2011/11/codeigniter-nexmo-message-api-library-release/
dsq_thread_id:
  - 477101097
categories:
  - CodeIgniter
  - php
tags:
  - API
  - CodeIgniter
  - Nexmo
  - SMS

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div> 繼上次釋出第1版 

<a href="http://blog.wu-boy.com/2011/11/codeigniter-nexmo-mobile-messaging/" target="_blank">CodeIgniter 透過 Nexmo 傳送簡訊 Mobile Messaging</a> 之後，該版本只有支援簡訊傳送功能，如果大家想測試，可以上 <a href="http://nexmo.com/" target="_blank">Nexmo</a> 官網<a href="http://dashboard.nexmo.com/register" target="_blank">申請帳號</a>，就可以使用了，不過在官網 Documentation 裡面有新增了 Developer API 部份，這次改版就一次把全部加入到 Library 裡面。 <!--more-->

  * Account: Get Balance
  * Account: Get Pricing
  * Account: Settings
  * Account: Numbers
  * Number: Search
  * Number: Buy
  * Number: Cancel 開發過程碰到 Account: Settings 部份沒辦法 Update，所以跟國外官方開發者溝通之後，官方終於把 API 修正了，目前都可以正常使用了，大家可以透過底下方式安裝: 

### Github 下載網址：

<a href="https://github.com/appleboy/CodeIgniter-Nexmo-Message" target="_blank">https://github.com/appleboy/CodeIgniter-Nexmo-Message</a> 請先閱讀 Readme 使用方式。 

### getsparks 下載網址：

<a href="http://getsparks.org/packages/Nexmo-SMS-Message/versions/HEAD/show" target="_blank">http://getsparks.org/packages/Nexmo-SMS-Message/versions/HEAD/show</a> 一步安裝法： 

<pre class="brush: bash; title: ; notranslate" title="">php tools/spark install -v1.0.2 Nexmo-SMS-Message</pre>