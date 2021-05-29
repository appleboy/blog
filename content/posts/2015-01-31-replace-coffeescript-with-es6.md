---
title: CoffeeScript 轉 ES6
author: appleboy
type: post
date: 2015-01-31T08:53:29+00:00
url: /2015/01/replace-coffeescript-with-es6/
dsq_thread_id:
  - 3471975202
categories:
  - ECMAScript 6
tags:
  - 6to5
  - ECMAScript 6
  - javascript

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/16407404782" title="es6-logo by Bo-Yi Wu, on Flickr"><img src="https://i1.wp.com/farm8.staticflickr.com/7306/16407404782_8b9c57eab3_m.jpg?resize=240%2C240&#038;ssl=1" alt="es6-logo" data-recalc-dims="1" /></a>
</div>

# 開始嘗試 ES6

最近有時會看看 [JavaScript ECMAScript 6][1] 的相關文件，今年也是時候將新專案用 ES6 來撰寫，在還沒使用 ES6 以前，我個人比較偏好使用 [CoffeeScript][2] 或 [LiveScript][3]，如果嚐試過 CoffeeScript 後，你會發現轉換成 ES6 是相當容易。網路上可以直接看 [6to5][4] 專案，提供 [Sprockets][5], [Broccoli][6], [Browserify][7], [Grunt][8], [Gulp][9], [Webpack][10] ..等，要嘗試 ES6 語法轉成 Javascript 可以透過 [ES6 repl][11] 介面來嘗鮮。

<!--more-->

# Classes

來看看用 CoffeeScript 怎麼寫 JavaScript Class:

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">class Person
  constructor: (@firstName, @lastName) ->

  name: ->
    "#{@first_name} #{@last_name}"

  setName: (name) ->
    names = name.split " "

    @firstName = names[0]
    @lastName = names[1]

boy = new Person "Bo-Yi", "Wu"
boy.setName("Boy Apple")
console.log boy.name()</pre>
</div>

在 ES6 可以使用 classes, getters, and setters

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">class Person {
  constructor(firstName, lastName) {
    this.firstName = firstName;
    this.lastName = lastName;
  }

  get name() {
    return this.firstName + " " + this.lastName;
  }

  set name(name) {
    var names = name.split(" ");

    this.firstName = names[0];
    this.lastName = names[1];
  }
}

var boy = new Person("Bo-Yi", "Wu");
boy.name = "Boy Apple";
console.log(boy.name);</pre>
</div>

從上面可以發現 2 點不一樣的地方

  * 可以忽略 `function` 字串
  * 每個 function 後面不需要分號(;)

# Interpolation

ES6 開始支援 [Template String][12]，詳細可以參考 Addy Osmani 最新寫的 [Getting Literal With ES6 Template Strings][13]

CoffeeScript:

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">"multi-line strings with interpolation like 1 + 1 = #{1 + 1}"</pre>
</div>

JavaScript:

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">"multi-line strings with interpolation like 1 + 1 = " + (1 + 1)</pre>
</div>

ES6 template strings:

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">
// 這邊需要注意的是，兩邊並非是雙引號或單引號，而是 ` 符號
`multi-line strings with interpolation like 1 + 1 = ${1 + 1}`
</pre>
</div>

注意 ES6 並非用雙引號了。所以上面的 `get name` function 可以改成底下

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">get name() {
  return `${this.firstName} ${this.lastName}`;
}</pre>
</div>

# Fat Arrows

在寫 Javascript 要如何把目前的 `this` 綁定到現在函式內，可以透過 CoffeeScript 的 `=>` 符號，現在 ES6 也支援了

純 JavaScript 寫法

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var self = this;

$("button").on("click", function() {
  // do something with self
});</pre>
</div>

CoffeeScript:

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">$("button").on "click", =>
  # do something with this</pre>
</div>

ES6:

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">$("button").on("click", () => {
  // do something with this
});</pre>
</div>

# Default arguments

CoffeeScript 可以定義函式傳入預設值

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">hello = (name = "guest") ->
  console.log(name)</pre>
</div>

ES6 現在也可以了

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var hello = function(name = "guest") {
  alert(name);
}</pre>
</div>

# Splats functions

PHP 5.6 開始也支援了 [Variadic functions][14]，而 CoffeeScript 也有此功能

PHP 5.6:

<div>
  <pre class="brush: php; title: ; notranslate" title=""><?php
function sum(...$numbers) {
    $acc = 0;
    foreach ($numbers as $n) {
        $acc += $n;
    }
    return $acc;
}

echo sum(1, 2, 3, 4);
?></pre>
</div>

CoffeeScript:

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">awards = (first, second, others...) ->
  gold = first
  silver = second
  honorable_mention = others
</pre>
</div>

ES6：

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var awards = function(first, second, ...others) {
  var gold = first;
  var silver = second;
  var honorableMention = others;
}</pre>
</div>

# Destructuring

Destructuring 讓變數可以直接對應物件或陣列內容

CoffeeScript:

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">[first, _, last] = [1, 2, 3]</pre>
</div>

ES6:

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var [first, , last] = [1, 2, 3];</pre>
</div>

我們可以將 set name 函式改成底下

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">set name(name) {
  [this.firstName, this.lastName] = name.split(" ");
}</pre>
</div>

# 結論

更多學習資源可以直接參考 [6to5 專案][15]，從現在開始擁抱 ES6 吧。

參考: [Replace CoffeeScript with ES6][16]

 [1]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/New_in_JavaScript/ECMAScript_6_support_in_Mozilla
 [2]: http://coffeescript.org/
 [3]: http://livescript.net/
 [4]: https://6to5.org
 [5]: https://github.com/sstephenson/sprockets
 [6]: https://github.com/broccolijs/broccoli
 [7]: http://browserify.org/
 [8]: http://gruntjs.com/
 [9]: http://gulpjs.com/
 [10]: http://webpack.github.io/
 [11]: https://6to5.org/repl
 [12]: https://www.chromestatus.com/feature/4743002513735680
 [13]: http://updates.html5rocks.com/2015/01/ES6-Template-Strings
 [14]: http://php.net/manual/en/functions.arguments.php#functions.variable-arg-list
 [15]: https://6to5.org/docs/learn-es6/
 [16]: http://robots.thoughtbot.com/replace-coffeescript-with-es6