---
title: Using firebug for firefox 除錯 javascript
author: appleboy
type: post
date: 2010-01-05T15:57:34+00:00
url: /2010/01/using-firebug-for-firefox-除錯-javascript/
views:
  - 7233
bot_views:
  - 546
dsq_thread_id:
  - 246716195
categories:
  - javascript
tags:
  - Firebug
  - FrieFox
  - javascript

---
在 Web 程式設計，不管是 html 或者是 CSS、甚至 javascript，都可以利用 [FireFox Plugin][1]: [firebug][2] 來除錯，順便推薦另一套 Web Develper 工具：[Web Developer 1.1.8][3]，這兩套都可以玩看看，在網路看自己[東華電機][4]學長 [gasolin][5] 寫過一篇：[3 分鐘學會用 firebug 除錯][6] ，裡面有一個影片，建議大家看看：[影片][7]，如何利用 firebug 來對 javaascript 除錯，介紹了 firebug 優點。底下整理我看到的內容 

## 1. 利用 console.log() 來針對變數除錯 以往都是利用 window.alert() 的方式來看看變數是否正確，現在只要在 javascript 裡面加入 console.log() 針對不同變數取值出來觀看 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 輸出會顯示： 

<pre class="brush: bash; title: ; notranslate" title="">a is test
[1, 2, 3, 4]</pre>

## 2. 印出有圖示的訊息 console.info/console.warn/console.error 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 這功能跟 console.log 差不多，只有差在前面有圖示符號，請看下圖： 

[<img src="https://i2.wp.com/farm5.static.flickr.com/4039/4247585921_8063dedd60.jpg?resize=500%2C126&#038;ssl=1" title="firebug_01 (by appleboy46)" alt="firebug_01 (by appleboy46)" data-recalc-dims="1" />][8] 

## 3. 使用 firebug 除錯 debugger;

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 只要在 js 裡面加入 debugger; 就會進行

**逐步除錯**，我想如果寫過 Window form 的使用者，C# ASP.net 最常用的就是逐步徵測錯誤，這功能相當方便，每一行跑了哪些變數，都可以逐一在旁邊顯示喔 [<img src="https://i1.wp.com/farm5.static.flickr.com/4014/4248370238_4d2bf876fe.jpg?resize=500%2C177&#038;ssl=1" title="firebug_02 (by appleboy46)" alt="firebug_02 (by appleboy46)" data-recalc-dims="1" />][9] 大家看到逐步偵錯到第19行，前面變數都會在旁邊顯示喔，原本都是 null。 

## 4. 計算 js 花費時間 console.time/console.timeEnd

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 只要加上 console.time("do this"); 跟最後 console.timeEnd("do this"); 就可以在 console 看到執行時間喔，很方便吧。Firebug 還有很多除錯功能，像 CSS 可以直接註解馬上看到結果，這都是 Web 工程師必備的工具。

 [1]: https://addons.mozilla.org/en-US/firefox/
 [2]: https://addons.mozilla.org/en-US/firefox/addon/1843
 [3]: https://addons.mozilla.org/en-US/firefox/addon/60
 [4]: http://www.ee.ndhu.edu.tw
 [5]: http://inet6.blogspot.com/
 [6]: http://inet6.blogspot.com/2007/02/3-firebug.html?obref=obinsite
 [7]: http://www.digitalmediaminute.com/screencast/firebug-js/
 [8]: https://www.flickr.com/photos/appleboy/4247585921/ "firebug_01 (by appleboy46)"
 [9]: https://www.flickr.com/photos/appleboy/4248370238/ "firebug_02 (by appleboy46)"