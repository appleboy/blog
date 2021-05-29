---
title: 安全使用 JavaScript Global Variables
author: appleboy
type: post
date: 2014-06-11T03:42:00+00:00
url: /2014/06/safely-reference-javascript-global-variables/
dsq_thread_id:
  - 2754334512
categories:
  - javascript
tags:
  - CoffeeScript
  - javascript

---
剛開始學習 [JavaScript][1] 時候，一定會大量使用 Global Variables。但是使用 Global Variables 的同時，請務必使用 `var` 宣告，而不是直接使用阿，否則會常常遇到 `ReferenceError` 的錯誤。

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">function addToBlockList (item) {
  block_List.push(item);
}

addToBlockList ("add 127.0.0.1");</pre>
</div>

執行後你可以發現 console 噴出 `Uncaught ReferenceError: block_List is not defined`，加上一個判斷試試看。程式碼改成底下

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">function addToBlockList (item) {
  if (block_list) {
    block_List.push(item);
  }
}

addToBlockList ("add 127.0.0.1");</pre>
</div>

<!--more-->

會噴出一樣的錯誤訊息，原因也是 `block_List is not defined`，最後將程式碼換成底下

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">function addToBlockList (item) {
  if (window.block_list) {
    window.block_List.push(item);
  }
}

addToBlockList ("add 127.0.0.1");</pre>
</div>

就可以正常跑了，也不會出現任何錯誤訊息，建議大家不要寫這樣的程式碼，能夠少用 window.xxxx 這種全域變數就盡量少用，不要任意宣告或修改 window 全域變數，上面程式碼可以換成底下會更好

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">(function() {
  var block_list = [];
  var addToBlockList = function (item) {
    if (block_list) {
      block_list.push(item);
    }
  };
    
  addToBlockList("127.0.0.1");
  console.log(block_list);
  
})();</pre>
</div>

這樣可以避免渲染 window Global Variable。如果你是用 [CoffeeScript][2] 來寫，可以寫成底下

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">(->
  block_list = []
  addToBlockList = (item) ->
    block_list.push item  if block_list
    return

  return
)()</pre>
</div>

但是我建議可以使用 `block_list?` 寫法

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">(->
  block_list = []
  addToBlockList = (item) ->
    block_List?.push item
    return

  return
)()</pre>
</div>

轉成的 JavaScript 會是

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">(function() {
  var addToBlockList, block_list;
  block_list = [];
  addToBlockList = function(item) {
    if (typeof block_List !== "undefined" && block_List !== null) {
      block_List.push(item);
    }
  };
})();</pre>
</div>

 [1]: https://developer.mozilla.org/en-US/docs/Web/JavaScript
 [2]: http://coffeescript.org/