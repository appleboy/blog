---
title: 認識現今 Google 搜尋引擎
author: appleboy
type: post
date: 2014-05-25T07:04:38+00:00
url: /2014/05/understanding-google-search-engine/
dsq_thread_id:
  - 2710960390
categories:
  - Google
  - javascript
tags:
  - AJAX
  - google
  - javascript
  - Webmaster

---
**感謝 [@Ly Cheng][1] 針對第三點補充**

<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/14077059487" title="new-google-logo-knockoff by Bo-Yi Wu, on Flickr"><img src="https://i1.wp.com/farm3.staticflickr.com/2930/14077059487_58046d689e.jpg?resize=500%2C194&#038;ssl=1" alt="new-google-logo-knockoff" data-recalc-dims="1" /></a>
</div>

1995 年 [JavaScript][2] 第1版出現，到了 1998 年 [Google][3] 推出[第一代搜尋引擎][4]，當時的 Google 根本不用在乎網頁如何使用 [CSS][5] 或 JavaScript，而當時的網頁也顯少使用 JavaScript 及 CSS。轉眼間到現在 2014 年，如今現在的 Web，已經離不開 JavaScript 及 CSS 了，而目前 [SPA (Single Page Application)][6] 的流行，也造成 Google 搜尋引擎讀取資料的困擾，所以 Google 團隊目前也正在朝這方向努力邁進。

<!--more-->

傳統的網頁，Google 根本不需要在乎 JavaScript 或 CSS，直接從 Http Response 拿到 Body 內的資料進行分析，然而 JavaScript 的盛行，已經改變了此作法，Google 再也不能從 Body 內準確的拿到資料，原因就是現今的網頁，都已經由 JavaScript 透過 AJAX 方式跟後端存取資料，這樣對於 Google 搜尋引擎是非常不好的結果。

Google 為了改善此問題，現階段也開始著手改善爬蟲，讓爬蟲可以正確執行 JavaScript，當然也要根據 Client 端是否有打開 JavaScript。由於現在大多數的網站已經漸漸變成 SPA 方式，看到如今盛行的 JavaScript Framework 像是 [Backbone.js][7]，[AngularJS][8] 等。Google Webmaster 也開始正視這問題。

為了能讓 Google 可以正確取得網頁資料，底下有些資訊可以提供給開發者，可以對 Google 爬蟲更友善

  * 請不要將 JavaScript 或 CSS 寫入 `robots.txt`，這樣只是讓 Google 無法正確拿到 JavaScript 檔案
  * 注意 Server 不要拒絕 crawl requests，也就是要有能力承受 crawl 讀取 XD
  * 讓網頁可以支援舊版瀏覽器或尚未實做 JavaScript 的搜尋引擎，一樣可以正確取得網頁內容
  * JavaScript 寫的太複雜，導致 Google crawl 無法正確執行
  * 使用 JavaScript 移除 content 遠大於新增 content，避免影響 Google 做 index

現在 [Google Webmaster Tools][9] 也著手進行後台開發，讓開發者可以正確看到 Google crawl 行為。

此篇文章參考 [Understanding web pages better][10] 及 [It took Google’s Web crawlers 15 years to come to terms with JavaScript][11]

 [1]: https://www.facebook.com/yhsiang
 [2]: http://zh.wikipedia.org/wiki/JavaScript
 [3]: https://www.google.com/
 [4]: https://www.google.com/about/company/history/#1998
 [5]: http://en.wikipedia.org/wiki/Cascading_Style_Sheets
 [6]: http://en.wikipedia.org/wiki/Single-page_application
 [7]: http://backbonejs.org/
 [8]: https://angularjs.org/
 [9]: https://www.google.com/webmasters/tools/home
 [10]: http://googlewebmastercentral.blogspot.tw/2014/05/understanding-web-pages-better.html
 [11]: http://venturebeat.com/2014/05/23/it-took-googles-web-crawlers-15-years-to-come-to-terms-with-javascript/