---
title: 開發 iPhone Mobile Web App 一些小技巧
author: appleboy
type: post
date: 2012-07-17T05:49:30+00:00
url: /2012/07/develop-iphone-moblie-web-app-tip/
dsq_thread_id:
  - 768516124
categories:
  - Mobile
tags:
  - CSS
  - iPhone
  - Mobile Web

---
開發 Mobile Web App 有好一陣子，底下來紀錄過去開發的一些經驗以及 iPhone 上面一些 meta 的設定小技巧，適用於 Mobile Web 開發，如果有任何錯誤，請大家可以留言給我，也或者有不錯的建議都可以一起討論。不過此篇文章會比較偏向 iOS iPhone Device 上面的開發技巧。那廢話不多說了，來看看設計 Mobile 需要注意哪些事項。 

### 良好的設計模式 底下是 Web 程式設計師應該注意的事項 

  * html 檔案必須宣告 DOCTYPE 型態  
    以目前 HTML5 就必須寫成 <!DOCTYPE html>
  * 完全區隔 HTML, CSS, 和 JavaScript 檔案，以便將來好維護或擴充
  * 完整的 html 架構，不要少個單引號或雙引號，或是少寫 close tag

<!--more-->

### 優化 Web Content 為了區分手機跟桌面版本不同的 content，我們可以使用 

<a href="http://www.w3.org/TR/css3-mediaqueries/" target="_blank">Media Queries</a> 來區分，在加上 **<span style="color:blue">max-device-width</span>** 和 **<span style="color:blue">min-device-width</span>** 去偵測整個頁面大小 (screen size)。 舉例來說，偵測 iPhone and iPod touch 裝置，可以透過底下載入 CSS 

<pre class="brush: bash; title: ; notranslate" title="">&lt;link media="only screen and (max-device-width: 480px)" href="small-device.css" type= "text/css" rel="stylesheet"></pre> 另外如果是 Desktop 版本可以加入底下 

<pre class="brush: xml; title: ; notranslate" title=""><link media="screen and (min-device-width: 481px)" href="not-small-device.css" type="text/css" rel="stylesheet" />
</pre> 另外或者是直接在 CSS 裡面判斷: 

<pre class="brush: xml; title: ; notranslate" title="">@media screen and (min-device-width: 481px) { ... }</pre> 另外針對 screen 或 print 可以直接在 head 裡面寫入 

<pre class="brush: xml; title: ; notranslate" title=""><link rel="stylesheet" type="text/css" media="screen" href="sans-serif.css" />

<link rel="stylesheet" type="text/css" media="print" href="serif.css" />
</pre> 或者在 CSS 裡面寫入 

<pre class="brush: css; title: ; notranslate" title="">@media screen {
    #text { color: white; background-color: black; }
}

@media print {
    #text { color: black; background-color: white; }
    #nav  { display: none; }
}</pre>

### Viewport Meta Tag 設定 開發 iPhone 手機版 Web，為了符合 device 真正寬度，必須設定 viewport 的 width 等於 device-width。 

<pre class="brush: xml; title: ; notranslate" title=""><meta name="viewport" content="width=device-width" />
</pre> 另外可以針對使用者可否放大或縮小螢幕，以及是否可以縮放 

<pre class="brush: xml; title: ; notranslate" title=""><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0,user-scalable=no" />
</pre> initial-scale: 畫面初始化倍率 maximum-scale: 畫面最大倍率 minimum-scale: 畫面最小倍率 user-scalable: 用戶是否可以縮放畫面 

### 設定 Web Applications 設定將網頁儲存為 home screen icon 的圖片路徑，預設值為 57x57 

<pre class="brush: xml; title: ; notranslate" title=""><link rel="apple-touch-icon" href="/custom_icon.png" />
</pre> 定義其他裝置 size 圖片 

<pre class="brush: xml; title: ; notranslate" title=""><link rel="apple-touch-icon" href="touch-icon-iphone.png" />

<link rel="apple-touch-icon" sizes="72x72" href="touch-icon-ipad.png" />

<link rel="apple-touch-icon" sizes="114x114" href="touch-icon-iphone4.png" />
</pre> 設定載入頁面時 loading 圖片 

<pre class="brush: xml; title: ; notranslate" title=""><link rel="apple-touch-startup-image" href="/startup.png" />
</pre> 隱藏底部 iPhone button bar，看起來更像 iPhone App 

<pre class="brush: xml; title: ; notranslate" title=""><meta name="apple-mobile-web-app-capable" content="yes" />
</pre> 更改 status bar 樣式 

<pre class="brush: xml; title: ; notranslate" title=""><meta name="apple-mobile-web-app-status-bar-style" content="black" />
</pre> 另外一個重點，當網頁載入完成後，可以隱藏 URL bar 

<pre class="brush: jscript; title: ; notranslate" title="">window.onload = function(){
    setTimeout(function(){
        window.scrollTo(0, 1);
    }, 100);
}</pre> 如果旋轉裝置，則必須在加上 resize event 

<pre class="brush: jscript; title: ; notranslate" title="">// jQuery resize event
$(window).resize(function() {
  window.scrollTo(0, 1);
});</pre> 如果不想讓使用者滑動網頁，可以加入底下 

<pre class="brush: jscript; title: ; notranslate" title="">document.addEventListener("touchmove", function(event){
    event.preventDefault();
}, false);</pre> Reference: 

<a href="http://mobile.tutsplus.com/tutorials/iphone/iphone-web-app-meta-tags/" target="_blank">Configuring an iPhone Web App With Meta Tags</a> <a href="http://developer.apple.com/library/ios/#DOCUMENTATION/AppleApplications/Reference/SafariWebContent/Introduction/Introduction.html#//apple_ref/doc/uid/TP40002079-SW1" target="_blank">iOS Developer Library</a>