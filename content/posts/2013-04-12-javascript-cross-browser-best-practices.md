---
title: '[小技巧] JavaScript Cross Browser Best Practices'
author: appleboy
type: post
date: 2013-04-12T02:50:55+00:00
url: /2013/04/javascript-cross-browser-best-practices/
dsq_thread_id:
  - 1204736542
categories:
  - AJAX
  - Browser
  - Chrome
  - Firefox
  - IE
  - javascript
  - jQuery
tags:
  - IE
  - JavaScrpt
  - jQuery
  - modern.IE

---
<div style="margin: 0 auto; text-align: center;">
  <a title="ie-logo-small by appleboy46, on Flickr" href="https://www.flickr.com/photos/appleboy/8443574444/"><img alt="ie-logo-small" src="https://i2.wp.com/farm9.staticflickr.com/8216/8443574444_c01f821c31_m.jpg?resize=240%2C240&#038;ssl=1" data-recalc-dims="1" /></a>
</div> 先前寫了一篇 

<a href="http://blog.wu-boy.com/2013/02/testing-for-internet-explorer-with-web-page/" target="_blank">modern.IE 的使用方式及介紹</a>，今天在 <a href="http://Facebook.com" target="_blank">Facebook</a> 上看到 <a href="https://twitter.com/ericsk" target="_blank">Eric Shangkuan</a> 說已經有了<a href="http://www.modern.ie/zh-tw" target="_blank">中文介面</a>，如果你的瀏覽器是中文版，應該就可以直接看到中文介面了，裡面有篇文章非常重要，寫 Web 的工程師都必須注意，那就是 <a href="http://www.modern.ie/zh-tw/cross-browser-best-practices" target="_blank">Cross Browser Best Practices</a>，這篇文章教您如何撰寫相容於舊版 IE 瀏覽器的一些小技巧，這些技巧也不只用在 IE 上，更是教您在實做 CSS，JavaScript 的注意事項。我們來看看 Javascript 的小技巧。 <!--more-->

### 不要再使用 navigator.userAgent 為了知道使用者 Browser 資訊，之前有寫篇 

<a href="http://blog.wu-boy.com/2010/10/jquery-%E5%81%B5%E6%B8%AC%E7%80%8F%E8%A6%BD%E5%99%A8%E7%89%88%E6%9C%AC-%E4%BD%9C%E6%A5%AD%E7%B3%BB%E7%B5%B1os-detection/" target="_blank">jQuery 偵測瀏覽器版本, 作業系統(OS detection)</a>，內容使用 navigator.userAgent 來取得使用者瀏覽器及裝置資訊，開發者為了 IE 各版本的相容，所以透過此方式來知道 IE 各版本，進而在 JS 做處理，但是有時候並不是這麼準確，因為目前市面上裝置實在是太多種了，手機，平板，電視一堆等等，為了支援各種裝置，請不要再用 navigator.userAgent 來判斷了，現在取而代之的就是用 <a href="http://modernizr.com/" target="_blank">Modernizr</a>，用來偵測您的 Browser 有無任何您所想要的功能，像是 Html5 的 <a href="http://www.w3schools.com/html/html5_canvas.asp" target="_blank">Canvas</a>，利用 <a href="http://modernizr.com/" target="_blank">Modernizr</a> 來判斷是否支援，這時候各種裝置就不會因為 JS 沒有判斷到而產生錯誤 ，尤其是在電視介面或 Android 平板，踩到很多雷阿。詳細資訊可以參考此<a href="http://msdn.microsoft.com/en-us/magazine/hh475813.aspx" target="_blank">連結</a>。 簡單來說 Canvas 在 IE9 才有支援，所以針對 IE 部份，我們使用 navigator.userAgent 來判斷 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 但是如果遇到 Safari, Chrome, Android, IPad, IPhone 版本呢，也很好解決，就是一直些判斷式，那為什麼不換個角度去想，直接判斷有無 Cnavas 功能即可，透過 

<a href="http://modernizr.com/" target="_blank">Modernizr</a> 套件可以簡單做到。另外 jQuery 在 1.9 版也直接捨棄了 <a href="http://api.jquery.com/jQuery.browser/" target="_blank">jQuery.browser</a> API 功能，取而代之的也是推薦 <a href="http://modernizr.com/" target="_blank">Modernizr</a>。 

<pre class="brush: jscript; title: ; notranslate" title="">if (Modernizr.canvas) {
  console.info('Your browser support canvas');
}</pre>

### 在 document ready 內不要執行大量 script 現在大部分的網站缺少不了的就是 jQuery，jQuery 提供了 $(document).ready() 在 html load 完成後可以快速執行 JavaScript，在大多的狀況下都可以正確執行的，但是如果在 $(document).ready() 寫入大量及複雜的 Script，只會讓瀏覽器呆滯而不能使用，所以盡可能減少執行的程式碼，等到使用者真正要執行功能的時候在進行呼叫即可。通常像是 tooltip 或 dialog 可以延遲等到要出現的時候在初始化即可。 簡單舉個例子，在 form 表單大家常用的 jQuery Plugin datepicker，通常初始化會透過底下方式來寫: 

<pre class="brush: jscript; title: ; notranslate" title="">$(document).ready( function() {
    $("input.date").datepicker({
        minDate: moment().subtract( "months", 1 ).toDate(),
        maxDate: moment().add( "months", 1 ).toDate(),
        dateFormat: "d M, y",
        constrainInput: true,
        beforeShowDay: $.datepicker.noWeekends
    });
});</pre> 用這缺點就是當 html 完成載入後，jQuery 會開始找 input 並且符合 class 為 date 的 元件，這會 delay 使用者正常使用網頁，比較好的解決方式就是 bind 在 input 的 focus 事件上。 

<pre class="brush: jscript; title: ; notranslate" title="">$(document).on( "focus", "input.date:not(.hasDatepicker)", function() {
    $(this).datepicker({
        minDate: moment().subtract( "months", 1 ).toDate(),
        maxDate: moment().add( "months", 1 ).toDate(),
        dateFormat: "d M, y",
        constrainInput: true,
        beforeShowDay: $.datepicker.noWeekends
    });
});</pre> 此寫法有另外的優點就是當如果有建立新的 input.date 元件，可以動態初始化元件。初始過的元件，我們就動態增加 hasDatepicker class 來判斷是否已經初始化。 

### 網頁開始先優先執行 AJAX 由於執行 AJAX 需要一段時間，所以請在 html load 之前就開始執行，並不需要等到 $(document).ready() 後才執行，另外在 AJAX 完成執行後的 Complete function 加入 $(document).ready() 函式確保 html 已載入完成。 

### 延遲載入 social button(Facebook Like, Google +1, Twitter) 現在大多網站都有一大堆分享機制（social networks），像是 Facebook Like、Twitter 等等，但是這些 JS 的載入，都大大影響到網頁的載入時間，其實最主要的解決方式就是務必思考哪些頁面才需要這些 button，能減少載入外部 JS 就是提昇網頁載入速度，在以前載入外部 JS 的作法就是底下 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 現在請改寫成底下 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 由於各瀏覽器相容問題，所以判斷是否支援 addEventListener 或 attachEvent，在 onload 後才開始執行。更多詳細內容可以參考 

<a href="http://www.aaronpeters.nl/blog/why-loading-third-party-scripts-async-is-not-good-enough" target="_blank">requesting these scripts</a>