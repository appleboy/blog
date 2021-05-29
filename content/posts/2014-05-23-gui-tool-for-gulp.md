---
title: Gulp.js 工具包
author: appleboy
type: post
date: 2014-05-23T03:23:59+00:00
url: /2014/05/gui-tool-for-gulp/
dsq_thread_id:
  - 2706249017
categories:
  - javascript
  - NodeJS
tags:
  - Grunt.js
  - GruntJS
  - gulp
  - gulp.js
  - Sublime Text

---
<div style="margin:0 auto; text-align:center;">
  <a href="https://www.flickr.com/photos/appleboy/11616755494/" title="gulp by appleboy46, on Flickr"><img src="https://i0.wp.com/farm8.staticflickr.com/7354/11616755494_06ef5c0fa5.jpg?w=840&#038;ssl=1" style="max-height: 250px" alt="gulp" data-recalc-dims="1" /></a>
</div>

本篇來整理關於 [Gulp.js][1] 的一些 GUI 工具，對於不瞭解 Gulp.js 可以參考之前我寫的 [The streaming build system Gulp][2]，會紀錄這篇最主要是看到有人在 Github 發了這篇 [Is there any GUI tool for Gulp?][3] 而 Gulp.js 底層作者 [@robrich][4] 跳出來列出了很多工具，整理如下

<!--more-->

  * [Gulpfiction][5] 如果不會寫 gulp.js 可以直接用此工具產生
  * [Gulp Dev Tools][6] 這是 Chrome Devtool Plugin
  * [Webstorm 編輯器下次 Release 就會支援][7]
  * [Visual Studio 也是下次 Release 就會支援][8]
  * [Sublime Text][9] 請直接裝 [sublime-gulp][10]

如果開發環境為 [Apple Mac][11] 你可以直接裝 [@sindresorhus][12] 寫的 [gulp-app][13]，或者是 g0v 作者 [clkao][14] 開發的 [gullet][15]。看大家喜歡哪些工具，請自行安裝。我比較推薦 Gulp Dev Tools for Chrome，可以在瀏覽器上直接執行 Gulp 所有 Task，如果之前有玩過 [Grunt.js][16] 大家應該都知道也有 [Grunt Devtools][17]。

有使用 CoffeeScript 寫 Gulp.js 請務必在 `gulpfile.coffee` 加上

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">module.exports = gulp</pre>
</div>

接著修改 `gulpfile.js` 如下

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">require('coffee-script/register');
var gulp = require('./gulpfile.coffee');
module.exports = gulp;
</pre>
</div>

程式碼可以直接參考 [html5-template-engine][18]

 [1]: http://gulpjs.com/
 [2]: http://blog.wu-boy.com/2013/12/streaming-build-system-gulp/
 [3]: https://github.com/gulpjs/gulp/issues/468
 [4]: https://github.com/robrich
 [5]: http://gulpfiction.divshot.io/
 [6]: https://chrome.google.com/webstore/detail/gulp-devtools/ojpmgjhofceebfifeajnjojpokebkkji/
 [7]: http://blog.jetbrains.com/webstorm/2014/05/webstorm-9-development-roadmap-discussion/
 [8]: https://twitter.com/mkristensen/status/466401181003448320
 [9]: http://www.sublimetext.com/
 [10]: https://github.com/NicoSantangelo/sublime-gulp
 [11]: http://www.apple.com/tw/mac/
 [12]: https://github.com/sindresorhus
 [13]: https://github.com/sindresorhus/gulp-app
 [14]: https://www.facebook.com/clkao
 [15]: https://github.com/clkao/gullet
 [16]: http://gruntjs.com/
 [17]: https://chrome.google.com/webstore/detail/grunt-devtools/fbiodiodggnlakggeeckkjccjhhjndnb?hl=en
 [18]: https://github.com/appleboy/html5-template-engine/