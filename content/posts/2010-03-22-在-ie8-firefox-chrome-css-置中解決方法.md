---
title: 在 IE8 FireFox Chrome CSS 置中解決方法
author: appleboy
type: post
date: 2010-03-22T13:40:54+00:00
url: /2010/03/在-ie8-firefox-chrome-css-置中解決方法/
views:
  - 7599
bot_views:
  - 512
dsq_thread_id:
  - 246859125
categories:
  - CSS
tags:
  - CSS

---
在 IE8 還沒出來之前，都是利用 margin: 0 auto; 的方式來解決 div 置中的問題，但是這在 IE8 並沒有發揮作用，無效了，底下在網路上發現兩種解法，分享給大家知道： **<span style="color:green;font-size:1.2em">1. Width:100%</span>** 在最外層 div 加入 Width:100% 的屬性，程式碼如下： 

<pre class="brush: css; title: ; notranslate" title="">#container {width:100%;}
#centered {width:400px; margin:0 auto;}</pre>

**<span style="color:green;font-size:1.2em">2. Text-Align:Center</span>** 在 div tag 裡面加入 Text-Align:Center，這樣 IE8 會偵測到此語法，就會服從 margin:0 auto; 之屬性，不過這樣內容會被全部至中，如果您有需要將其 div 內容往左邊對齊，那就必須在加上語法 Text-Align:left，底下是範例程式碼： 

<pre class="brush: css; title: ; notranslate" title="">#container {text-align:center;}
#centered {width:400px; margin:0 auto;text-align:left;}</pre> IE6，IE7 則是利用下面語法： 

<pre class="brush: css; title: ; notranslate" title="">#wrap {
  margin: 0px auto; /* firefox */
  *margin: 0px auto; /* ie7 */
  _margin: 0px auto; /* ie6 */
  height:100px; 
  width:860px;
  border:5px solid red;    
}</pre> reference: 

[Centering a Div in IE8 Using margin:auto][1] [【CSS 語法教學】區塊置中的三種寫法][2]

 [1]: http://stever.ca/web-design/centering-a-div-in-ie8-using-marginauto/
 [2]: http://www.flycan.com/board/topic3374.html