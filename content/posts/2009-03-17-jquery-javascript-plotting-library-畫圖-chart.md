---
title: '[jQuery] Javascript plotting library 畫圖 chart'
author: appleboy
type: post
date: 2009-03-17T02:00:28+00:00
url: /2009/03/jquery-javascript-plotting-library-畫圖-chart/
views:
  - 8242
bot_views:
  - 398
dsq_thread_id:
  - 246908914
categories:
  - AJAX
  - jQuery
  - php
tags:
  - jQuery

---
沒想到 [jQuery][1] 可以做到畫圖的功能，[Flot][2] 是 Javascript plotting library for jQuery，目前支援瀏覽器：Internet Explorer 6/7/8，Firefox 2.x+，Safari 3.0+，Opera 9.5 和 Konqueror 4.x+，瀏覽器跑起來都還不錯快，唯獨 Internet Explorer 有另外寫一個 excanvas 模擬器，也就是在 IE 上面看還需要 include 另外一個 js 檔案，才可以顯示圖形，我在 google 找到一些也是 PHP Chart 的好用工具，都是國外開發的：[Libchart - Simple PHP chart drawing library][3]，[XML/SWF Charts][4]，其實還蠻多的，自己 google 就會出現一堆，不過要上去試試看。 我個人還蠻喜歡 [jQuery][1] 的，所以我就推薦 Flot 這一個 jQuery 的 library，在官網上面有很多 example 的介紹，可以去看看[這裡][5]。 畫最簡單的圖，還有支援 cos sin 的三角函數喔 $(function () { /\* [橫座標,縱座標] Math.sin 支援三角函數 \*/ var d1 = []; for (var i = 0; i < 14; i += 0.5) d1.push([i, Math.cos(i)]); var d2 = [[0, 3], [4, 8], [8, 5], [9, 13]]; // a null signifies separate line segments var d3 = [[0, 12], [7, 12], null, [7, 2.5], [12, 2.5]]; $.plot($("#placeholder"), [ d1, d2, d3 ]); });[/code] 畫出來的圖如下： [<img src="https://i0.wp.com/farm4.static.flickr.com/3589/3359261523_4dca591215.jpg?resize=500%2C290&#038;ssl=1" title="flot_01 (by appleboy46)" alt="flot_01 (by appleboy46)" data-recalc-dims="1" />][6] <!--more--> 也可以加上 label 標籤喔 $(function () { var d1 = []; for (var i = 0; i < 14; i += 0.5) d1.push([i, Math.cos(i)]); var d2 = [[0, 3], [4, 8], [8, 5], [9, 13], [15, 20]]; var d3 = []; for (var i = 0; i < Math.PI * 5; i += 0.25) d3.push([i, Math.sin(i)]); $.plot($("#placeholder"), [ { label: "線條一", data: d1}, { label: "線條二", data: d2}, { label: "線條三", data: d3} ] ); });[/code] 圖形如下： 

[<img src="https://i0.wp.com/farm4.static.flickr.com/3655/3360096396_3cf7e259a9.jpg?resize=500%2C292&#038;ssl=1" title="flot_02 (by appleboy46)" alt="flot_02 (by appleboy46)" data-recalc-dims="1" />][7] 參考文章： [flot - 用 jQuery 畫圖的 library][8]

 [1]: http://jquery.com/
 [2]: http://code.google.com/p/flot/
 [3]: http://naku.dohcrew.com/libchart/pages/introduction/
 [4]: http://www.maani.us/xml_charts/index.php
 [5]: http://people.iola.dk/olau/flot/examples/
 [6]: https://www.flickr.com/photos/appleboy/3359261523/ "flot_01 (by appleboy46)"
 [7]: https://www.flickr.com/photos/appleboy/3360096396/ "flot_02 (by appleboy46)"
 [8]: http://blog.gslin.org/archives/2008/12/11/1880/