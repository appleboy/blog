---
title: Automating your workflow with Gulp.js
author: appleboy
type: post
date: 2014-07-20T02:11:13+00:00
url: /2014/07/automating-your-workflow-with-gulp-js/
dsq_thread_id:
  - 2857532611
categories:
  - javascript
  - NodeJS
tags:
  - Grunt.js
  - gulp
  - Gulp-compass
  - gulp.js
  - Node.js

---
<div style="margin:0 auto; text-align:center;">
  <a href="https://www.flickr.com/photos/appleboy/11616755494/" title="gulp by appleboy46, on Flickr"><img src="https://i0.wp.com/farm8.staticflickr.com/7354/11616755494_06ef5c0fa5.jpg?w=840&#038;ssl=1" style="max-height: 250px" alt="gulp" data-recalc-dims="1" /></a>
</div>

今年 2014 [COSCUP][1] 在 7/19,20 中研院舉辦，由於 [JSDC][2] 今年比往年還要晚半年舉辦，所以本來想投在 JSDC 的議程，就先拿到投到 COSCUP 議程。去年 JSDC 講了 [Javascript command line tool GruntJS 介紹][3]，講完經過半年，[Gulp.js][4] 就出來了，我馬上跳過去嘗試，用過之後，就像變了心的女朋友，回不來了，底下是 Gulp.js Slides。

<!--more-->

<div style="margin-bottom:5px">
  <strong> <a href="https://www.slideshare.net/appleboy/automating-your-workflow-with-gulp" title="Automating your workflow with Gulp.js" target="_blank">Automating your workflow with Gulp.js</a> </strong> from <strong><a href="http://www.slideshare.net/appleboy" target="_blank">Bo-Yi Wu</a></strong>
</div>

最後提到 [Slush.js][5] 這套 streaming scaffolding system，我寫了 [html5 template engine generator][6]，產生最簡單的開發環境以及 Gulp.js 設定檔，大家可以透過底下安裝嘗試:

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ npm install -g slush bower
$ npm install -g slush-html5-template</pre>
</div>

產生專案檔案

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ slush html5-template</pre>
</div>

這套 Slush html5 generator 程式檔來自 [html5-template-engine][7]。

 [1]: http://coscup.org/
 [2]: http://jsdc.tw/
 [3]: http://blog.wu-boy.com/2013/03/javascript-command-line-tool-gruntjs/
 [4]: http://gulpjs.com/
 [5]: http://slushjs.github.io/
 [6]: https://github.com/appleboy/slush-html5-template
 [7]: https://github.com/appleboy/html5-template-engine