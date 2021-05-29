---
title: PHP CodeIgniter Google URL Shortener API Library
author: appleboy
type: post
date: 2011-02-17T05:38:24+00:00
url: /2011/02/php-codeigniter-google-url-shortener-api-library/
views:
  - 544
bot_views:
  - 281
dsq_thread_id:
  - 246992912
categories:
  - CodeIgniter
  - Google
  - php
tags:
  - CodeIgniter
  - Google API
  - php

---
<div style="margin: 0 auto; text-align: center;">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div>

### **原由** 由於 bbs 的盛行，從最早的 

[0rz.tw][1] 短網址出現，陸陸續續出來很多更好用的網址: [tinyurl.com][2], [bit.ly][3]，後來 Google 也推出 [goo.gl][4] 服務，讓大家可以使用，提供了 [Google URL Shortener API][5] 讓程式開發者可以順利使用此 API，當然在使用 API 之前一定要跟 Google 申請一組 API Key，先到 [Google API Console][6] 申請，Shortener API 的規定每天可以存取 1,000,000 次(100萬)，我想這樣也足夠個人或者是公司使用了，除非真的比這個大量，可以跟 Google 再提出額外申請。 

### **系統需求**

  * [CodeIgniter Reactor 版本][7]
  * PHP 5.2 版本支援 Curl

### **下載檔案** 我已經將檔案都放在 

[github][8] 上面，為了保持程式最新版本，請大家到底下連結進行下載 

## [CodeIgniter-Google-URL-Shortener-API][9]

### **系統文件**

##### 安裝 此安裝檔案共有三個: 

  * application/config/google\_url\_api.php
  * application/controllers/google_url.php
  * application/libraries/Google\_url\_api.php 請將檔案放入到相對應的 application 目錄即可 

##### 設定 打開 

<span style="color:green">application/config/google_url_api.php</span> 檔案，將申請好的 API Key 填入即可 

##### 第一次執行 請在網址列打入 

<span style="color:green">http://your_host/index.php/google_url/</span> 即可，如果有任何問題，可以在 Controller 部份將 debug mode 打開 

<pre class="brush: php; title: ; notranslate" title="">$this->google_url_api->enable_debug(TRUE);</pre>

<!--more-->

## English Version

### **Requirements**

  * [CodeIgniter Reactor Version][7]
  * PHP 5.2 Curl

### **Download** In order to keep the latest and greatest version of this library online, I've now migrated my code to github. You can download the latest version of the library on the github project page: 

## [CodeIgniter-Google-URL-Shortener-API][9]

### **Documentation**

##### Installation The package comes with 3 main files: 

  * application/config/google\_url\_api.php
  * application/controllers/google_url.php
  * application/libraries/Google\_url\_api.php Move the files to their corresponding places within your 

<span style="color:green">codeigniter application</span> directory 

##### Configure Open 

<span style="color:green">application/config/google_url_api.php</span> file and enter your Google API Key. You can register you api key from [Google API Console Register Page][6] 

##### First Run Visit: 

<span style="color:green">http://your_host/google_url/</span> as you would a normal controller (using your correct URL of course). If you're having problems, then enable debugging in your controller code: 

<pre class="brush: php; title: ; notranslate" title="">$this->google_url_api->enable_debug(TRUE);</pre>

 [1]: http://0rz.tw/
 [2]: http://tinyurl.com/
 [3]: http://bit.ly/
 [4]: http://goo.gl/
 [5]: http://code.google.com/intl/zh-TW/apis/urlshortener/
 [6]: https://code.google.com/apis/console/
 [7]: https://bitbucket.org/ellislab/codeigniter-reactor
 [8]: https://github.com/appleboy/
 [9]: https://github.com/appleboy/CodeIgniter-Google-URL-Shortener-API