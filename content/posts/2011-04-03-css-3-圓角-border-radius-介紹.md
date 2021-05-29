---
title: CSS 3 圓角 border-radius 介紹
author: appleboy
type: post
date: 2011-04-03T12:29:13+00:00
url: /2011/04/css-3-圓角-border-radius-介紹/
views:
  - 467
bot_views:
  - 186
dsq_thread_id:
  - 269880218
categories:
  - CSS
tags:
  - CSS
  - CSS3
  - jQuery

---
目前各家瀏覽器分別開始支援 [CSS3][1]，現在 MS 瀏覽器系列只有 IE 9 開始支援 CSS3，所以大家還是趕快升級到 [IE 9.0][2]，或者是使用 [Google Chrome][3]，[FireFox 4.0][4] 吧，以前還沒有 CSS 3 的時候，圓角功能都是靠 [jQuery Plugin][5]: [Corner][6]，有了 CSS3 大家就不用這麼麻煩了，一行就可以搞定喔。 

### CSS Border Radius Generator 大家可以參考 

[CSS Border Radius Generator][7] 這網站，只要輸入4個角所需要的圓角半徑，就會自動產生 CSS 3 的語法喔 

<pre class="brush: css; title: ; notranslate" title="">/* support Safari, Chrome */
-webkit-border-radius: 5px;
/* support firefox */
-moz-border-radius: 5px;
border-radius: 5px;
</pre> 也可以個別設定角度 右上圓角： 

<pre class="brush: css; title: ; notranslate" title="">border-topright-radius: 5px; 
-moz-border-topright-radius: 5px; 
-webkit-border-topright-radius: 5px;</pre> 左上圓角： 

<pre class="brush: css; title: ; notranslate" title="">border-topleft-radius: 5px; 
-moz-border-topleft-radius: 5px; 
-webkit-border-topleft-radius: 5px;</pre> 右下圓角： 

<pre class="brush: css; title: ; notranslate" title="">border-bottomright-radius: 5px; 
-moz-border-bottomright-radius: 5px; 
-webkit-border-bottomright-radius: 5px;</pre> 左下圓角： 

<pre class="brush: css; title: ; notranslate" title="">border-bottomleft-radius: 5px; 
-moz-border-bottomleft-radius: 5px; 
-webkit-border-bottomleft-radius: 5px;</pre> 非常簡單，大家以後不用再自己做圓角的圖，CSS3 一行搞定啦 Ref: 

[css圓角(border-radius)介紹][8] [螞蟻的 CSS border-radius][9] [developer mozilla border-radius][10]

 [1]: http://zh.wikipedia.org/wiki/CSS
 [2]: http://www.microsoft.com/taiwan/promo/ie9/
 [3]: http://www.google.com/chrome
 [4]: http://moztw.org/
 [5]: http://plugins.jquery.com/
 [6]: http://jquery.malsup.com/corner/
 [7]: http://border-radius.com/
 [8]: http://blog.mukispace.com/css-border-radius/
 [9]: http://ant4css.blogspot.com/2009/03/border-radius.html
 [10]: https://developer.mozilla.org/en/CSS/border-radius#Browser_compatibility