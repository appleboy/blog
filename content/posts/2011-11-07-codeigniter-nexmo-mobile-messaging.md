---
title: CodeIgniter 透過 Nexmo 傳送簡訊 Mobile Messaging
author: appleboy
type: post
date: 2011-11-07T13:17:48+00:00
url: /2011/11/codeigniter-nexmo-mobile-messaging/
dsq_thread_id:
  - 464132021
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - Nexmo
  - SMS

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div> 在 gslin 大神看到這篇

[用 Nexmo 送簡訊][1]，自己也來測試看看，先到 [Nexmo][2] 註冊好會員，馬上就會有 EUR$2 可以使用，[傳送一封簡訊價錢][3]是 EUR$0.011，大概是台幣 0.45 元，目前支援[中華電信][4]、[台灣大哥大][5]、[遠傳][6]、[威寶電信][7]，官方有提供一些 API Library，自己寫了一套 for <a href="http://www.CodeIgniter.org.tw" target="_blank">CodeIgniter</a> 支援 JSON 及 XML 兩種格式，並且在 <a href="http://getsparks.org/" target="_blank">getsparks</a> 放上[一份][8]。 

### 透過 getparks 安裝 直接參考網站安裝: 

<a href="http://getsparks.org/packages/Nexmo-SMS-Message/versions/HEAD/show" target="_blank">Get the Latest</a> 

<pre class="brush: bash; title: ; notranslate" title="">php tools/spark install -v1.0.0 Nexmo-SMS-Message</pre> 讀取 spark library: 

<pre class="brush: php; title: ; notranslate" title="">// Load the spark
$this->load->spark('Nexmo-SMS-Message/1.0.0');
// Load the library
$this->load->library('nexmo');</pre>

### 透過 git 安裝 直接看 

<a href="https://github.com/appleboy/CodeIgniter-Nexmo-Message" target="_blank">CodeIgniter-Nexmo-Message</a> README 安裝方法。

 [1]: http://blog.gslin.org/archives/2011/11/06/2771/%E7%94%A8-nexmo-%E9%80%81%E7%B0%A1%E8%A8%8A/
 [2]: http://nexmo.com
 [3]: http://nexmo.com/pricing/index.html
 [4]: http://www.cht.com.tw/
 [5]: http://www.taiwanmobile.com/
 [6]: http://www.fetnet.net/
 [7]: http://www.vibo.com.tw
 [8]: http://getsparks.org/packages/Nexmo-SMS-Message/versions/HEAD/show