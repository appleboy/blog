---
title: Coding on workspace of Chrome Developer tools
author: appleboy
type: post
date: 2013-07-21T10:48:36+00:00
url: /2013/07/coding-on-workspace-of-chrome-developer-tools/
dsq_thread_id:
  - 1516913169
categories:
  - Browser
  - Chrome
  - CSS
  - javascript
tags:
  - Backbone.js
  - Chrome
  - Chrome Developer Tool
  - GruntJS
  - LiveReload
  - RequireJs

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i2.wp.com/farm8.staticflickr.com/7350/9333443162_20e7e5d5f2_m.jpg?w=840&#038;ssl=1" alt="Google Chrome" data-recalc-dims="1" />
</div>

相信網頁設計師並不陌生 <a href="https://developers.google.com/chrome-developer-tools/" target="_blank">Chrome DevTools</a>，善用 DevTools 可以減少很多 Debug 時間，今天來介紹如何在 <a href="https://www.google.com/intl/zh-TW/chrome/browser/" target="_blank">Chrome 瀏覽器</a>上直接編輯程式，並且存檔，重新整理網頁後便可看到結果。聽到這裡大家一定會很好奇，不就開系統編輯器 (sublime, pspad, vim ...) 工具，直接修改 => 存檔 => 重新整理嘛？但是這並不稀奇阿，重點是 Chrome 瀏覽器可以直接支援 `線上編輯檔案`，而不是透過系統工具做編輯。這就是 Chrome 強大的地方，今天就來介紹 <a href="https://developers.google.com/chrome-developer-tools/docs/settings?hl=en#workspace" target="_blank">Chrome workspace</a>。 <!--more-->

### 啟動 Workspace

打開 Chrome 瀏覽器，在網址列輸入: `chrome://flags/`，並且找到 `Enable Developer Tools experiments`，啟動此選項，最後重新啟動瀏覽器

[<img src="https://i0.wp.com/farm6.staticflickr.com/5336/9330724801_a7033d870c.jpg?resize=500%2C147&#038;ssl=1" alt="Selection_004" data-recalc-dims="1" />][1]

打開 Chrome Console 介面，並且點選右下角 Setting 會看到此畫面

[<img src="https://i0.wp.com/farm6.staticflickr.com/5338/9330739963_0963070e6d_o.png?resize=570%2C458&#038;ssl=1" alt="Selection_005" data-recalc-dims="1" />][2]

點選到 `Experiment` 後，將 `File system folders in Source Panel` 勾選，並且重新啟動瀏覽器

### 使 Workspace 編輯檔案

完成上述步驟，接著就是將 local 目錄掛到 Chrome Dev Tool 介面，請先打開瀏覽器，打 local 網址，並且將 console 介面打開

[<img src="https://i2.wp.com/farm4.staticflickr.com/3823/9330772493_a3d4de749c_z.jpg?resize=640%2C132&#038;ssl=1" alt="Selection_006" data-recalc-dims="1" />][3]

指定好 path 後，可以將 setting 頁面關閉，然後切換到 Sources Tab，你會發現如下圖

[<img src="https://i2.wp.com/farm3.staticflickr.com/2860/9334436126_21ff82e482_o.png?resize=465%2C248&#038;ssl=1" alt="Selection_007" data-recalc-dims="1" />][4]

我們可以開啟 app/index.html，直接在 console 介面編輯並且存檔

[<img src="https://i1.wp.com/farm4.staticflickr.com/3807/9334446622_cc553501cb_z.jpg?resize=640%2C307&#038;ssl=1" alt="Selection_008" data-recalc-dims="1" />][5]

接著直接 refresh 網頁即可。

### 心得

用 `Workspace` 其實重點就是你可以直接開 browser 然後旁邊的 console 介面可以直接編輯，而不是切換到系統編輯器修改，當然這還不是很方便，如果搭配了 <a href="http://gruntjs.com/" target="_blank">GruntJS</a> 及 <a href="http://livereload.com/" target="_blank">LiveReload</a>，你會發現，編輯程式碼後，Grunt 也是會自動跑相關設定，LiveReload 也會自動幫忙更新網頁喔。

可以參考之前的文章: <a href="http://blog.wu-boy.com/2013/05/2013-javascript-conference-front-tool-grunt-js/" target="_blank">2013 Javascript Conference: 你不可不知的前端開發工具</a>

另外可以直接拿下面兩專案來跑 <a href="http://requirejs.org/" target="_blank">RequireJS</a> + <a href="http://backbonejs.org/" target="_blank">Backbone.js</a> + <a href="http://gruntjs.com/" target="_blank">GruntJS</a>

  * Github: <a href="https://github.com/appleboy/html5-template-engine" target="_blank">html5-template-engine</a>
  * Github: <a href="https://github.com/appleboy/backbone-template-engine" target="_blank">backbone-template-engine</a>

 [1]: https://www.flickr.com/photos/appleboy/9330724801/ "Selection_004 by appleboy46, on Flickr"
 [2]: https://www.flickr.com/photos/appleboy/9330739963/ "Selection_005 by appleboy46, on Flickr"
 [3]: https://www.flickr.com/photos/appleboy/9330772493/ "Selection_006 by appleboy46, on Flickr"
 [4]: https://www.flickr.com/photos/appleboy/9334436126/ "Selection_007 by appleboy46, on Flickr"
 [5]: https://www.flickr.com/photos/appleboy/9334446622/ "Selection_008 by appleboy46, on Flickr"