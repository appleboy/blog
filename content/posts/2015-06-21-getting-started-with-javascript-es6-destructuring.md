---
title: 簡介 JavaScript ES6 物件及陣列
author: appleboy
type: post
date: 2015-06-21T08:01:30+00:00
url: /2015/06/getting-started-with-javascript-es6-destructuring/
dsq_thread_id:
  - 3866113526
categories:
  - ECMAScript 6
  - javascript
tags:
  - Array
  - Babel
  - ES2015
  - ES6
  - javascript
  - Object

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/16407404782" title="es6-logo by Bo-Yi Wu, on Flickr"><img src="https://i1.wp.com/farm8.staticflickr.com/7306/16407404782_8b9c57eab3_m.jpg?resize=240%2C240&#038;ssl=1" alt="es6-logo" data-recalc-dims="1" /></a>
</div>

今年 2015 六月 17 號 [Ecma International][1] 已經同意 [ECMA-262 6th edition][2] 版本，這是在 [ECMAScript 2015 Has Been Approved][3] 看到的消息，而現在主流就是以 [Babeljs][4] 為主，將 ES2015 語法直接轉換成 ES5，讓各大瀏覽器可以繼續支援 ES2015 寫法。今天來介紹 ES2015 內如何使用物件 (Object) 或陣列 (Array)。

<!--more-->

## 陣列 Array Destructuring

直接舉例子來說明，假設有一個 Array [1, 2, 3, 4, 5]，我們需要三個變數分別對應到 1, 2, 3 這時候在 ES5 答案會是底下

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var value = [1, 2, 3, 4, 5];
var el1 = value[0];
var el2 = value[1];
var el3 = value[2];</pre>
</div>

這時候可以發現 [el1, el2, el3] 就是 [1, 2, 3] 了，但是在 ES6 寫法內，可以直接宣告 Array 變數來直接對應 value

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var value = [1, 2, 3, 4, 5];
var [el1, el2, el3] = value;</pre>
</div>

上述語法轉換成 ES5，就會是最上面的程式碼，ES6 可以不必宣告 el1, el2, el3 等變數，當然你也可以宣告後再做對應

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var el1, el2, el3;
[el1, el2, el3] = [1, 2, 3, 4, 5];</pre>
</div>

在 ES6 內要怎麼寫 swapping values 呢，請看底下

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">[el1, el2] = [el2, el1];</pre>
</div>

上述結果就是將 el1 及 el2 的值互相對調。陣列裡面還可以有陣列對應

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var value = [1, 2, [3, 4, 5]];
var [el1, el2, [el3, el4]] = value;
</pre>
</div>

這時 el3 = 3, el4 = 4，非常簡單，如果是 function return array value 也可以直接對應

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">function tuple() {
  return [1, 2];
}
 
var [first, second] = tuple();</pre>
</div>

如果要跳過陣列內其中一個值，可以直接寫成底下

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var value = [1, 2, 3, 4, 5];
var [el1, , el3, , el5] = value;</pre>
</div>

這時 el3 就是 3，正規語法就需要此功能

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var [, firstName, lastName] = "John Doe".match(/^(w+) (w+)$/);

// firstName = John, lastName = Doe</pre>
</div>

還有在 ES5 我們常常要寫 default value 功能，現在可以用簡短程式碼取代

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var [firstName = "John", lastName = "Doe"] = [];</pre>
</div>

這時候由於 firstName 跟 lastName 都是 `undefined`，所以可以使用預設 values，如果是 null 就會是 null 值喔

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var [firstName = "John", lastName = "Doe"] = [null, null];</pre>
</div>

上述程式碼結果會是 firstName = lastName = null，最後還有 Spread operator 的功能

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var value = [1, 2, 3, 4, 5];
var [el1, el2, el3, ...tail] = value;
</pre>
</div>

可以發現 tail 的值會是 [4, 5]，但是目前只有支援剩餘 Array 的寫法，底下寫法是不支援的

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var value = [1, 2, 3, 4, 5];
var [...rest, lastElement] = value;
var [firstElement, ...rest, lastElement] = value;</pre>
</div>

## 物件 Object Destructuring

物件的寫法其實跟陣列沒有很大的差異，一樣是用物件包變數的方式宣告

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var person = {firstName: "John", lastName: "Doe"};
var {firstName, lastName} = person;</pre>
</div>

物件內還有物件寫法

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var person = {name: {firstName: "John", lastName: "Doe"}};
var {name: {firstName, lastName}} = person;</pre>
</div>

物件內有 Array 寫法

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var person = {dateOfBirth: [1, 1, 1980]};
var {dateOfBirth: [day, month, year]} = person;</pre>
</div>

或者是 Array 包物件都支援

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var person = [{dateOfBirth: [1, 1, 1980]}];
var [{dateOfBirth}] = person;</pre>
</div>

看看物件預設值寫法

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var {firstName = "John", lastName: userLastName = "Doe"} = {};</pre>
</div>

如果是 null 跟陣列一樣都會是 null

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var {firstName = "John", lastName = "Doe"} = {firstName: null, lastName: null};</pre>
</div>

## 函示宣告 Destructuring Function Arguments

一般開發者在寫 ES5 function 時，最後帶的參數一定會是物件 options，用來判斷此函示是否有其他特定需求變數

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">function findUser(userId, options) {
  if (options.includeProfile) ...
  if (options.includeHistory) ...
}</pre>
</div>

現在 ES6 可以直接寫成

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">function findUser(userId, {includeProfile, includeHistory}) {
  if (includeProfile) ...
  if (includeHistory) ...
}</pre>
</div>

這樣可以更清楚了解此函示的功能，而不用看程式碼了 ＸＤ，想開始嘗試寫 ES6 嗎？這時候就要強烈推薦 [Babel.js][4] 了，參考文章：[Getting Started with JavaScript ES6 Destructuring][5]

 [1]: http://www.ecma-international.org/
 [2]: http://www.ecma-international.org/publications/standards/Ecma-262.htm
 [3]: http://www.infoq.com/news/2015/06/ecmascript-2015-es6
 [4]: https://babeljs.io
 [5]: https://strongloop.com/strongblog/getting-started-with-javascript-es6-destructuring