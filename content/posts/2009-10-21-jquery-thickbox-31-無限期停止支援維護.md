---
title: '[jQuery] ThickBox 3.1 無限期停止支援維護'
author: appleboy
type: post
date: 2009-10-21T09:00:59+00:00
url: /2009/10/jquery-thickbox-31-無限期停止支援維護/
views:
  - 8089
bot_views:
  - 1037
dsq_thread_id:
  - 247043879
categories:
  - javascript
  - jQuery
tags:
  - fancybox
  - javascript
  - jQuery

---
在 [Oceanic / 人生海海][1] 看到這篇 [thickbox 停止維護][2]，[ThickBox][3] [jQuery][4] plugin 裡面算是不錯用的工具，在網路上常常會聽到這個名詞，thickbox 作者也推薦了底下類似套件： 

  * [colorbox][5]
  * [jQueryUI Dialog][6]
  * [fancybox][7]
  * [DOM window][8]
  * [shadowbox.js][9] 上面我還蠻推薦 

[fancybox][7] 的，目前開發專案都以它為主，因為在瀏覽整頁圖片，我覺得效果不錯，剛剛去 try 了一下 [colorbox][5]，發覺這套也不錯用。在 fancybox 裡面設定 zoomSpeedIn 或者是 frameWidth 的值，就直接設定數字，不用在加上引號，不然會沒出現效果。 

<pre class="brush: jscript; title: ; notranslate" title="">$(document).ready(function() {
	$("a.group").fancybox({
		'zoomSpeedIn': 300, 
		'zoomSpeedOut': 300
	});
});</pre>

 [1]: http://tzangms.com
 [2]: http://tzangms.com/programming/2496
 [3]: http://jquery.com/demo/thickbox/
 [4]: http://jquery.com
 [5]: http://colorpowered.com/colorbox/
 [6]: http://jqueryui.com/demos/dialog/
 [7]: http://fancybox.net/
 [8]: http://swip.codylindley.com/DOMWindowDemo.html
 [9]: http://www.shadowbox-js.com/index.html