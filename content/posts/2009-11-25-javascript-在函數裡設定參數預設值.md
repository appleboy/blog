---
title: '[Javascript] 在函數裡設定參數預設值'
author: appleboy
type: post
date: 2009-11-25T03:56:13+00:00
url: /2009/11/javascript-在函數裡設定參數預設值/
views:
  - 4850
bot_views:
  - 489
dsq_thread_id:
  - 248986109
categories:
  - javascript
tags:
  - javascript

---
在網路上看到一篇：『[Setting default values for missing parameters in a Javascript function][1]』，提到在 Javascript 函式參數如果未定義，就會出現 undefine 的錯誤訊息，請看底下範例： 

<pre class="brush: jscript; title: ; notranslate" title="">function foo(a, b, c) {
    document.write('a: ' + a + ' ');
    document.write('b: ' + b + ' ');
    document.write('c: ' + c + ' ');
    document.write('<br />');
}</pre> 測試函數： 

<pre class="brush: jscript; title: ; notranslate" title="">foo();
foo(1);
foo(1, 2);
foo(1, 2, 3);</pre> 輸出結果： 

<pre class="brush: jscript; title: ; notranslate" title="">a: undefined b: undefined c: undefined
a: 1 b: undefined c: undefined
a: 1 b: 2 c: undefined
a: 1 b: 2 c: 3</pre> 底下有兩種方式可以解決此問題： 1. 加入 if 判斷： 

<pre class="brush: jscript; title: ; notranslate" title="">function foo(a, b, c) {

    if(typeof a == 'undefined') {
        a = 'AAA';
    }
    if(typeof b == 'undefined') {
        b = 'BBB';
    }
    if(typeof c == 'undefined') {
        c = 'CCC';
    }

    document.write('a: ' + a + ' ');
    document.write('b: ' + b + ' ');
    document.write('c: ' + c + ' ');
    document.write('<br />');

}</pre> 測試： 

<pre class="brush: jscript; title: ; notranslate" title="">foo();
foo(1);
foo(1, 2);
foo(1, 2, 3);</pre> 結果輸出： 

<pre class="brush: jscript; title: ; notranslate" title="">a: AAA b: BBB c: CCC
a: 1 b: BBB c: CCC
a: 1 b: 2 c: CCC
a: 1 b: 2 c: 3</pre> 2. 網友提供的最佳解法： 

<pre class="brush: jscript; title: ; notranslate" title="">function foo(a, b, c) {

    a = a || "AAA";
    b = b || "BBB";
    c = c || "CCC";

    document.write('a: ' + a + ' ');
    document.write('b: ' + b + ' ');
    document.write('c: ' + c + ' ');
    document.write('<br />');

}</pre> 假設 a 尚未被定義，就會以 AAA 預設值顯示，程式碼也相當好閱讀。

 [1]: http://www.electrictoolbox.com/default-values-missing-parameters-javascript/