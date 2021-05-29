---
title: jQuery 1.9 final, jQuery 2.0 beta and Migrate plugin 釋出
author: appleboy
type: post
date: 2013-01-16T03:29:22+00:00
url: /2013/01/jquery-1-9-final-jquery-2-0-beta-migrate-final-released/
dsq_thread_id:
  - 1028184858
categories:
  - jQuery
tags:
  - jQuery
  - jQuery Migrate plugin

---
今天早上來到公司就發現一個令人振奮的訊息，那就是 <a href="http://blog.jquery.com/2013/01/15/jquery-1-9-final-jquery-2-0-beta-migrate-final-released/" target="_blank">jQuery 1.9 and 2.0 beta Release</a> 了，相信大家對於 <a href="http://jquery.com" target="_blank">jQuery</a> 應該都不是很陌生了，釋出同時官網也有寫一份 <a href="http://jquery.com/upgrade-guide/1.9/" target="_blank">jQuery 1.9 upgrade guide</a> 文件，來幫助大家升級舊版本。那為什麼這次會同時釋出 1.9 以及 2.0 beta 呢？我們來看看 jQuery 團隊如何定位 jQuery 1.9 及 2.0: 1. jQuery 1.9 和 2.0 擁有相同的 API，一些官方打算移除的 API 像是 $.bowser，在這兩版本都已經移除，更多的訊息可以參考 jQuery 1.9 upgrade guide 2. jQuery 1.9 可以執行在 IE 6,7 和 8 版本("old IE")，就如同之前的版本一樣升級 3. jQuery 2.0 將不在 old IE 版本上執行，此版本會比 1.9 版本還要小以及效能好 4. jQuery 團隊會持續維護 jQuery 1.9 及 2.0 版本，所以開發者根據自己的需求下載對應版本 <!--more--> jQuery 官方很貼心的製作 

<a href="https://github.com/jquery/jquery-migrate/" target="_blank">jQuery Migrate plugin</a>，可以用在 1.9 或 2.0 上，主動偵測 deprecated 或 removed 的功能，讓原本舊有的功能暫時不用修改還可以正常運作在新版本上面，請注意 2.0 一樣不能運作在 IE 6,7,8 上面，所以選擇對應的 jQuery 版本非常重要，可以使用 jQuery CDN jQuery 1.9 版本 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> jQuery 2.0 beta 1 版本 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 不管使用任何版本搭配此 plugin 都必須先看 

<a href="https://github.com/jquery/jquery-migrate/blob/master/warnings.md" target="_blank">plugin documentation</a> 注意事項，最好的解法，還是將舊式的寫法改掉，會是比較恰當的。 

### 1.9 版本新功能 1. Streamlined API: 許多 deprecated and dubious features 已經被移除了，請大家務必先看 upgrade guide 2. New .css() multi-property getter: 現在可以傳入 array of CSS property 名稱，API 將會回傳相對應的 value 回來 舉例: 

<pre class="brush: jscript; title: ; notranslate" title="">var dims = $("#box").css([ "width", "height", "backgroundColor" ]);
// return { width: "10px", height: "20px", backgroundColor: "#D00DAD" }</pre> 3. 加強 cross-browser CSS3 支援: 針對所有瀏覽器，jQuery 1.9 支援 CSS3 selectors :nth-last-child, :nth-of-type, :nth-last-of-type, :first-of-type, :last-of-type, :only-of-type, :target, :root, and :lang. 4. 新 .finish() 方法: 此功能可以直接結束單一 element 所有的 animations，直接看

<a href="http://jsfiddle.net/dmethvin/AFGgJ/" target="_blank">官網給的範例</a> 5. 修正一大堆在 IE 6,7,8 的 bugs，可以直接上官網看看 change log。 

### 使用 2.0 版本 本篇重點就在 2.0 開始不支援 IE 6,7,8，那還會有人用 2.0 嗎？沒關係的，透過小技巧，讓你可以安心使用 2.0 

<pre class="brush: jscript; title: ; notranslate" title=""><!--[if lt IE 9]>
    
<![endif]-->


<!--[if gte IE 9]><!-->
    


<!--[endif]--></pre> 結論: jQuery 就是想讓各位業者捨棄支援 IE 6,7,8 版本，也就是讓開發者最頭痛的版本啦，不管是不是 javascript，連 CSS 也都不喜歡 IE。