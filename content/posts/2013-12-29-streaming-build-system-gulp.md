---
title: The streaming build system Gulp
author: appleboy
type: post
date: 2013-12-29T08:25:22+00:00
url: /2013/12/streaming-build-system-gulp/
categories:
  - Compass CSS Framework
  - CSS
  - javascript
tags:
  - CoffeeScript
  - Compass
  - GruntJS
  - gulp
  - LiveReload

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/11616755494/" title="gulp by appleboy46, on Flickr"><img src="https://i0.wp.com/farm8.staticflickr.com/7354/11616755494_06ef5c0fa5.jpg?resize=197%2C388&#038;ssl=1" alt="gulp" data-recalc-dims="1" /></a>
</div>

看到 <a href="https://github.com/yeoman" target="_blank">Yeoman</a> 作者之一 <a href="https://github.com/addyosmani" target="_blank">Addy Osmani</a> 開始 <a href="https://github.com/yeoman/yeoman/issues/1232" target="_blank">review Gulp build system</a>，由於 Yeoman framework 跟 <a href="http://gruntjs.com/" target="_blank">GruntJS</a> 是很緊密結合的，但是 GruntJS 套件愈來愈多，漸漸的執行 GruntJS 後，開始吃了系統 CPU 及記憶體，這對於開發環境而言，會是一大負擔阿，大家不知道有無發現，跑 [Nodejs][1] GruntJS 時，每當存檔的時候，CPU 就開始哀嚎了，我自己是有這方面的體會，加上團隊內並不是每位同仁的電腦都是很 powerful，原本是好意讓團隊開發更遵守 coding style 及統一開發環境，但是 Grunt 的肥大，讓整個 Client 環境 Loading 飆高。所以 Yeoman 看到了 <a href="https://github.com/gulpjs/gulp" target="_blank">Gulp</a>。也有考慮如何將 Gulp 整合到 Yeoman 專案。 <!--more-->

### Gulp 簡介

大家可以把 Gulp 跟 Grunt 用途想成一樣，只是處理 Task 的原理不相同。Grunt 是透過 Task 的概念下去實作，JS 程式存檔後，Grunt 會依序處理使用者定義的 task，例如執行 jslint task 接著 uglify task，最後將檔案搬到您想的目錄。而 Gulp 則是平行處理，假設有5個 js 檔案，Gulp 則是透過 pipeline 方式處理檔案，所以 Gulp 會加速處理結果。

Grunt 原理: 

<pre class="brush: bash; title: ; notranslate" title="">Grunt jslint task -> Grunt uglify task -> Grunt copy task
  ---處理5個檔案--- ->  ---處理5個檔案---   -> ---處理5個檔案---</pre>

Gulp 原理 

<pre class="brush: bash; title: ; notranslate" title="">Grunt jslint task -> Grunt uglify task -> Grunt copy task
  ---處理檔案(1)--- ->  ---處理檔案(1)---  -> ---處理檔案(1)---
  ---處理檔案(2)--- ->  ---處理檔案(2)---  -> ---處理檔案(2)---
  ---處理檔案(3)--- ->  ---處理檔案(3)---  -> ---處理檔案(3)---
  ---處理檔案(4)--- ->  ---處理檔案(4)---  -> ---處理檔案(4)---
  ---處理檔案(5)--- ->  ---處理檔案(5)---  -> ---處理檔案(5)---</pre>

### Gulp 用法

我們假設寫 <a href="http://coffeescript.org/" target="_blank">Coffeescript</a> 程式，通常寫完會經過 <a href="http://www.coffeelint.org/" target="_blank">coffeelint</a> 檢查 coffee script 的 Coding style 語法，最後才透過 coffee command 轉換成 javascript 檔案。

在 Grunt 套件，我們會這樣寫

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">
coffeelint:
    options:
        'force': true
        'no_trailing_whitespace':
            'level': 'error'
        'max_line_length':
            'level': 'ignore'
        'indentation':
            'value': 4
            'level': 'error'
    dev: ['**/*.coffee', '!**/node_modules/**', '!**/vendor/**']
watch:
    coffee:
        files: ['**/*.coffee', '!**/node_modules/**', '!**/vendor/**'],
        tasks: ['coffeelint']
</pre>
</div>

如果是用 Gulp 寫法會非常簡單

<pre class="brush: jscript; title: ; notranslate" title="">gulp.task('coffee', function() {
    gulp.src('app/assets/coffeescript/**/*.coffee')
        .pipe(coffeelint({"indentation": {
            "name": "indentation",
            "value": 4,
            "level": "error"
        }}))
        .pipe(coffeelint.reporter())
        .pipe(coffee({bare: true}))
        .pipe(gulp.dest('app/assets/js/'))
        .pipe(refresh(server));
});</pre>

有沒有變得很容易閱讀？設定方式也變得很容易，執行速度更不用說了，不會吃太多記憶體及 CPU 了，但是我覺得要取代 Grunt 實在很困難，Grunt 能處理大部分的事情，包含 Deploy 及驗證等等，我覺得 Gulp 就專門用在 RD 開發環境的建置，RD 平時會用到哪些套件？`Coffscript`，`Compass or sass`，`livereload`，`watch event`，大致上這些就已經很足夠了。

  * <a href="https://npmjs.org/package/gulp-coffee" target="_blank">Coffscript</a>
  * <a href="https://npmjs.org/package/gulp-compass" target="_blank">Compass</a> by <a href="https://github.com/appleboy" target="_blank">appleboy</a>
  * <a href="https://npmjs.org/package/gulp-sass" target="_blank">sass</a>
  * <a href="https://npmjs.org/package/gulp-livereload" target="_blank">livereload</a>

由於沒找到 Compass Gulp plugin，只看到 sass plugin，所以我寫了簡易的 Gulp plugin，有用 compass 務必安裝

<pre class="brush: bash; title: install command; notranslate" title="install command">$ npm install gulp-compass --save-dev</pre>

使用方式可以參考 <a href="https://github.com/appleboy/gulp-compass/blob/master/README.md" target="_blank">Readme</a>。

 [1]: http://nodejs.org/