---
title: Backbone.js 1.1.1 Release 釋出 AMD 版本
author: appleboy
type: post
date: 2014-02-17T05:48:00+00:00
url: /2014/02/backbone-js-1-1-1-amd-release/
dsq_thread_id:
  - 2278146932
categories:
  - Backbone.js
  - javascript
tags:
  - Backbone.js
  - javascript

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/7059615321/" title="backbone by appleboy46, on Flickr"><img src="https://i1.wp.com/farm6.staticflickr.com/5338/7059615321_097833dea8.jpg?resize=451%2C80&#038;ssl=1" alt="backbone" data-recalc-dims="1" /></a>
</div>

[Backbone.js][1] 在 2014.02.13 推出 1.1.1 版本，此次改版沒有推出重大功能，距離上次 [1.1.0 版本][2]只有經過四個月，時間也沒有很長。之前版本尚未支援 [AMD][3]，所以都是使用 [amdjs/backbone][4] 版本，但是這次 Backbone 官方直接釋出 AMD 版本，那之後就照官方版本走就可以了，底下是這次改版 Release note

  * 釋出 AMD ([require.js][5]) 版本
  * 新增 `execute` hook 讓開發者可以處理特定 route arguments
  * Backbone Event 效能改善
  * 處理相容舊瀏覽器 URL Unicode

近幾年 Javascript Framework 串起，似乎現在大家瘋狂的跟 [Angularjs][6]，所以 Backbone 似乎進度也沒有很快了，就像 PHP Framework 一樣，[Laravel][7] 的出現，讓其他 Framework 變得比較少討論了

 [1]: http://backbonejs.org/
 [2]: http://blog.wu-boy.com/2013/11/upgrade-backbone-framework-to-1-1-0-tips/
 [3]: https://github.com/amdjs/amdjs-api/wiki/AMD
 [4]: https://github.com/amdjs/backbone
 [5]: http://requirejs.org/
 [6]: http://angularjs.org/
 [7]: http://laravel.com/