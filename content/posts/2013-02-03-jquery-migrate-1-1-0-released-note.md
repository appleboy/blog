---
title: jQuery Migrate 1.1.0 Released 注意事項
author: appleboy
type: post
date: 2013-02-03T03:53:29+00:00
url: /2013/02/jquery-migrate-1-1-0-released-note/
dsq_thread_id:
  - 1062014561
categories:
  - javascript
  - jQuery
tags:
  - jQuery
  - jQuery Migrate plugin

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8442641115/" title="OQAAAI1PPrJY0nBALB7mkvju3mkQXqLmzMhxEjeb4gp8aujEUQcLfLyy-Sn4gZdkAas6-k8eYbQlGDE-GCjKfF5gIrUA15jOjFfLRv77VBd5t-WfZURdP9V3PdmT by appleboy46, on Flickr"><img src="https://i0.wp.com/farm9.staticflickr.com/8378/8442641115_8564013cea.jpg?resize=500%2C123&#038;ssl=1" alt="jquery logo" data-recalc-dims="1" /></a>
</div> 上個月大家可以注意到 

<a href="http://blog.wu-boy.com/2013/01/jquery-1-9-final-jquery-2-0-beta-migrate-final-released/" target="_blank">jQuery 釋出 1.9 及 2.0 版本</a>，官方團隊也同時推出 <a href="https://github.com/jquery/jquery-migrate/" target="_blank">jQuery Migrate Plugin</a> 1.0.0 版本，此 Plugin 是跟 <a href="http://jquery.com" target="_blank">jQuery</a> 1.9 或 2.0 一起搭配使用，偵測 jQuey 已移除或者是將被移除的功能，讓您之前開發的 jQuey 功能可以持續使用，但是似乎很多使用者不知道此 plugin 用處，就直接升級 1.9 或 2.0，並未載入 migrate plugin，造成官方收到很多 feed back 都是關於一些舊功能不能使用。半個月後 jQuery 官方收到很多 migrate plugin 回報問題，這次一樣可以透過 jQuuery CDN 載入，程式碼如下。 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 壓縮版本 

<pre class="brush: jscript; title: ; notranslate" title=""></pre>

<!--more--> 以一個完美的 jQuery 升級是不需要 migrate plugin，但是團隊為了讓部份已經移除的功能可以正常使用，所以開發 migrate plugin 讓開發者使用。此次 migrate plugin 改版最主要是增加 debug mode 並且預設打開，讓開發者可以知道哪些程式必須要修正才可以在 jQuery 1.9 以上正常使用。底下是 1.1.0 版本新增的功能。 1. 預設將 Trace 功能打開，所有的 Browser 如果有支援 

**<span style="color:green">console.trace()</span>**，migrate 預設就會直接顯示在 console 介面，如果線上網站不想使用此功能，可以透過 jQuery.migrateTrace = false 將其功能關閉。 2. "Logging is active" 訊息: 如果看到此訊息代表的是網頁已經載入 migrate plugin，只是讓開發者知道已經正確載入。 3. 在 jQuery 1.9.0 版本以前 **<span style="color:green">$.parseJSON()</span>** 支援 invalid JSON 值，像是 "" 或 undefined，回傳 null 而不是 error message，此 Migrate 1.1.0 也開始支援此功能，並且會顯示錯誤提示。 4. **<span style="color:green">$("<button>", { type: "button" })</span>** 寫法在 1.9 裏面並不支援 IE6/7/8 版本，一樣在 Migrate 1.1.0 同樣支援此功能，並且顯示錯誤訊息。 5. 你可在 <a href="http://plugins.jquery.com/" target="_blank">jQuery Plugin</a> 網站看到 <a href="http://plugins.jquery.com/migrate/" target="_blank">Migrate plugin</a> 了，或者是在 <a href="https://github.com/jquery/jquery-migrate/" target="_blank">Github</a> 上面找到。 Ref: 參考 <a href="http://blog.jquery.com/2013/01/31/jquery-migrate-1-1-0-released/" target="_blank">jQuery Migrate 1.1.0 Released</a>