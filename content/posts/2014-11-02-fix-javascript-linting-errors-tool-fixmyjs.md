---
title: 自動修復 JavaScript Linting-errors 好工具 Fixmyjs
author: appleboy
type: post
date: 2014-11-02T02:32:24+00:00
url: /2014/11/fix-javascript-linting-errors-tool-fixmyjs/
dsq_thread_id:
  - 3181791094
categories:
  - javascript
tags:
  - fixmyjs
  - gulp
  - JSHint

---
前端工程師撰寫 [JavaScript][1] 程式碼後一定會透過 [JSHint][2] 驗證程式碼品質，但是 JSHint 只會提醒各位開發者哪些代碼需要修正，工程師還是需要手動去修復這些錯誤，這有點麻煩，所以今天來介紹一套自動修正 JSHint 錯誤的好工具 [Fixmyjs][3]，如果大家有寫過 PHP，一定有聽過 [PHP-FIG][4] 制定了 [PSR-0][5], [PSR-1][6], [PSR-2][7] 等標準，希望 PHP 工程師可以遵守這些規則，而 [PHP-CS-Fixer][8] 就是根據 PHP-FIG 來自動修復 PHP 程式碼，讓程式碼可以遵守這些共同制定的標準。

<!--more-->

[Fixmyjs][3] 的出現解決了 JSHint 的問題，但是大家會問 FixMyJS 幫我們解決了哪些問題，請看底下

  * 自動幫忙補上分號 semicolons
  * 強制轉換 camelCase
  * 幫忙移除 debugger 程式碼
  * 執行雙引號或單引號
  * 自動補上空白
  * Mixed spaces/tabs
  * 去除行尾空白
  * 自動轉換 array literal 和 object literal

更多支援請[參考這裡][9]，給個範例大家比較有感覺，可以看一下底下程式碼

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var a = Array();
var b = Object();
var c = [];
var d
debugger;
delete c;
a == null;
var e = undefined;
var foo = new Foo;
foo([1, 2, 3,]);
a = 1;
a++;
var x = 1;;
a == NaN;
a != NaN
var q = .25;</pre>
</div>

透過 fixmyjs 指令轉換，可以得到底下結果

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var a = [];
var b = {};
var c = [];
var d;
c = undefined;
a == null;
var e;
var foo = new Foo();
foo([
  1,
  2,
  3
]);
a = 1;
a++;
var x = 1;
isNaN(a);
!isNaN(a);
var q = 0.25;</pre>
</div>

透過命令列可以直接轉換 JavaScript 檔案

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ npm install fixmyjs -g
$ fixmyjs app.js</pre>
</div>

另外如果有使用 [Sublime Text][10] 編輯器可以直接找 [sublime-fixmyjs][11]，當然也可以透過 [gulp-fixmyjs][12] 來導入自動修復流程。[gulp][13] 可以參考底下

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">gulp.task 'jshint', ->
  gulp.src 'app/assets/js/**/*.js'
    .pipe $.fixmyjs
      legacy: true
    .pipe gulp.dest 'app/assets/js/'
    .pipe $.jshint()
    .pipe $.jshint.reporter 'jshint-stylish'
    .pipe $.if !browserSync.active, $.jshint.reporter 'fail'</pre>
</div>

如果你將 `legacy` 設定為 `false`，你會發現 JavaScript 的空白 Line 會被移除，這已經回報到[官方 Issue][14]，所以現在建議大家還是將 `legacy` 設定為 `true` 會比較好，否則程式碼會擠成一團 XD

更多介紹可以直接參考 [Explorations In Automatically Fixing JavaScript Linting-errors][15]

 [1]: http://en.wikipedia.org/wiki/JavaScript
 [2]: http://www.jshint.com/
 [3]: https://github.com/jshint/fixmyjs/
 [4]: http://www.php-fig.org/
 [5]: http://www.php-fig.org/psr/psr-0/
 [6]: http://www.php-fig.org/psr/psr-1/
 [7]: http://www.php-fig.org/psr/psr-2/
 [8]: https://github.com/fabpot/PHP-CS-Fixer
 [9]: https://github.com/jshint/fixmyjs/#currently-supports
 [10]: http://www.sublimetext.com/
 [11]: https://sublime.wbond.net/packages/FixMyJS
 [12]: https://github.com/kirjs/gulp-fixmyjs
 [13]: http://gulpjs.com/
 [14]: https://github.com/jshint/fixmyjs/issues/105
 [15]: http://addyosmani.com/blog/fixmyjs/