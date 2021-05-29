---
title: 用 Google PageSpeed Insights 計算 Desktop 或 Mobile 網站分數
author: appleboy
type: post
date: 2014-06-12T02:33:34+00:00
url: /2014/06/pagespeed-insights-with-reporting/
dsq_thread_id:
  - 2757171201
categories:
  - javascript
  - NodeJS
tags:
  - google
  - gpagespeed
  - Grunt.js
  - gulp
  - gulp.js
  - PageSpeed
  - PageSpeed Insights

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/14077059487" title="new-google-logo-knockoff by Bo-Yi Wu, on Flickr"><img src="https://i0.wp.com/farm3.staticflickr.com/2930/14077059487_58046d689e_n.jpg?resize=320%2C124&#038;ssl=1" alt="new-google-logo-knockoff" data-recalc-dims="1" /></a>
</div>

相信工程師在調整網站效能一定會使用 [Google PageSpeed Insights][1] 來得到測試效能數據報表，但是這僅限於使用 Chrome 或 Firefox 瀏覽器。每次跑 PageSpeed 時候，Chrome 就會出現哀號，並且吃下許多記憶體。有沒有 command line 可以直接用 Google PageSpeed Insights 測試 Desktop 或 Mobile 的分數。Google 工程師 [@addyosmani][2] 寫了一套 [PageSpeed Insights for Node - with reporting][3] 稱作 [PSI][3]，可以直接透過 Node 來產生基本 report，這 report 真的算很基本，跟 Chrome 的 extension 跑起來的 report 是不一樣的。這工具可以用來紀錄每次 deploy 網站時的一些數據變化。底下附上 Google 網站報告

[<img src="https://i2.wp.com/farm4.staticflickr.com/3857/14401120872_38d23bc763_z.jpg?resize=640%2C586&#038;ssl=1" alt="google_psi_report" data-recalc-dims="1" />][4]

<!--more-->

此工具是透過 [gpagespeed][5] 完成，如果你有用 [GruntJS][2] 可以直接參考 [grunt-pagespeed][6]。使用 psi command line 非常簡單，透過底下指令就可以正確產生出上面報表

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ npm install -g psi
$ psi http://www.google.com</pre>
</div>

如果有用 [GulpJS][7] 可以寫成兩個 Task 來跑

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">
var gulp = require('gulp');
var psi = require('psi');
var site = 'http://www.html5rocks.com';
var key = '';

// Please feel free to use the `nokey` option to try out PageSpeed
// Insights as part of your build process. For more frequent use,
// we recommend registering for your own API key. For more info:
// https://developers.google.com/speed/docs/insights/v1/getting_started

gulp.task('mobile', function (cb) {
  psi({
    // key: key
    nokey: 'true',
    url: site,
    strategy: 'mobile'
  }, cb);
});

gulp.task('desktop', function (cb) {
  psi({
    nokey: 'true',
    // key: key,
    url: site,
    strategy: 'desktop'
  }, cb);
});</pre>
</div>

上面程式碼來自 [psi-gulp-sample][8]，psi 有提供 callback function

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">function(err, data){
  console.log(data.score);
  console.log(data.responseCode);
  console.log(data.id );
}</pre>
</div>

上面的 Task 可以改成

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">gulp.task('desktop', function (cb) {
  psi({
    nokey: 'true',
    // key: key,
    url: site,
    strategy: 'desktop'
  }, function(err, data){
    console.log(data.score);
    console.log(data.responseCode);
    console.log(data.id );
    cb();
  });
});</pre>
</div>

用此工具來紀錄每次網站更新後的測試數據，對於調整 Web Performance 來說是一個可以參考的指標。如果 API 使用量很大，請記得申請 Google API Key。

 [1]: https://developers.google.com/speed/docs/insights/v1/getting_started
 [2]: https://github.com/addyosmani
 [3]: https://github.com/addyosmani/psi
 [4]: https://www.flickr.com/photos/appleboy/14401120872 "google_psi_report by Bo-Yi Wu, on Flickr"
 [5]: https://github.com/zrrrzzt/gpagespeed
 [6]: https://github.com/jrcryer/grunt-pagespeed
 [7]: http://gulpjs.com/
 [8]: https://github.com/addyosmani/psi-gulp-sample/blob/master/gulpfile.js