---
title: 6to5 JavaScript Transpiler 重新命名為 Babel
author: appleboy
type: post
date: 2015-02-22T11:55:09+00:00
url: /2015/02/the-6to5-javascript-transpiler-has-renamed-to-babel/
categories:
  - ECMAScript 6
  - javascript
tags:
  - 6to5
  - Babel
  - JavaScrpt

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/16407404782" title="es6-logo by Bo-Yi Wu, on Flickr"><img src="https://i1.wp.com/farm8.staticflickr.com/7306/16407404782_8b9c57eab3_m.jpg?resize=240%2C240&#038;ssl=1" alt="es6-logo" data-recalc-dims="1" /></a>
</div>

先前寫了一篇 [CoffeeScript 轉 ES6][1]，裡面有提到 [6to5 專案][2]，此專案幫助開發者可以直接寫 JavaScript ECMAScript 6，該專案則會將 ES6 轉成 ES5，但是目前瀏覽器對於 ES6 的支援度還沒有很高，可以直接參考 [ECMAScript 6 compatibility table][3]，但是看到專案名稱 6to5，就會覺得如果之後 ES7 出來，不就要多開一個 7to6 專案，果然官方在 [Blog 宣佈將名稱正式轉為 Babeljs][4]。[Babel][2] 也會持續使用最新 JavaScript Standard 開發 JavaScript transpiler 相關工具，讓各種平台程式都可以使用。

現在就可以透過 Babel 來開發 ES6

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ npm install --global babel</pre>
</div>

ES6 轉 ES5

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ babel script.js</pre>
</div>

一些來自 [Mozilla][5], [Esprima][6], [jQuery Foundation][7], Acorn, 6to5, ESLint 組織成員，也合力開了 [ESTree][8]，而 Babel 以 ESTree 為基底來開發相關 Tool，所以最新的 Standard 也可以直接參考 ESTree。

 [1]: http://blog.wu-boy.com/2015/01/replace-coffeescript-with-es6/
 [2]: http://babeljs.io
 [3]: http://kangax.github.io/compat-table/es6/
 [4]: http://babeljs.io/blog/2015/02/15/not-born-to-die/
 [5]: https://www.mozilla.org/en-US/
 [6]: http://esprima.org/
 [7]: https://jquery.org/
 [8]: https://github.com/estree/estree