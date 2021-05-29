---
title: gulp-imagemin 在 Ubuntu 出現錯誤
author: appleboy
type: post
date: 2014-04-29T06:55:47+00:00
url: /2014/04/gulp-imagemin-lossy-operations-are-not-currently-supported/
dsq_thread_id:
  - 2646840507
categories:
  - javascript
  - Linux
  - Ubuntu
tags:
  - gulp
  - gulp-imagemin
  - OptiPNG
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/11616755494/" title="gulp by appleboy46, on Flickr"><img src="https://i0.wp.com/farm8.staticflickr.com/7354/11616755494_06ef5c0fa5.jpg?resize=197%2C388&#038;ssl=1" alt="gulp" data-recalc-dims="1" /></a>
</div>

在 deploy 程式碼到 production server 前，透過 [gulp-imagemin][1] 工具將全部圖片優化，上傳到 [Amazon S3][2]，Windows 底下正常運作，到了 Ubuntu 環境之下噴出底下錯誤訊息

> Error: Lossy operations are not currently supported
後來在 [grunt-contrib-imagemin@issues/180][3] 有提人出此問題，解決方案就是升級 [OptiPNG][4]，因為 Ubuntu 的 apt 套件只有支援到 0.6.4 版本，請到 OptiPNG 官網下載最新 tar 檔，編譯重新安裝

<!--more-->

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ wget http://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.5/optipng-0.7.5.tar.gz
$ tar -zxvf optipng-0.7.5.tar.gz
$ cd optipng-0.7.5.tar
$ ./configure && make && make install</pre>
</div>

附上 gulp-imagemin 設定方式

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">gulp.task('images', function() {
  return gulp.src('app/images/**/*.{jpg,jpeg,png,gif}')
    .pipe(imagemin({
      progressive: true,
      interlaced: true
    }))
    .pipe(gulp.dest('dist/images'))
    .pipe(size());
});</pre>
</div>

 [1]: https://www.npmjs.org/package/gulp-imagemin
 [2]: http://aws.amazon.com/s3/
 [3]: https://github.com/gruntjs/grunt-contrib-imagemin/issues/180
 [4]: http://optipng.sourceforge.net/