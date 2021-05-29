---
title: PHP function 參數 default value
author: appleboy
type: post
date: 2011-08-06T12:58:55+00:00
url: /2011/08/php-function-參數-default-value/
dsq_thread_id:
  - 378707362
categories:
  - javascript
  - php
tags:
  - JavaScrpt
  - php

---
<div style="margin: 0 auto;text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6034284842/" title="php-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm7.static.flickr.com/6186/6034284842_351ff33711_m.jpg?resize=240%2C127&#038;ssl=1" alt="php-logo" data-recalc-dims="1" /></a>
</div>

**2011.08.06 Update: 感謝 jaceju 指正筆誤** 自己定義 <a href="http://www.php.net" target="_blank">PHP</a> Function 的時候，假設該函式有1個參數，您可以傳入該參數或者是不傳，但是函式裡面如何判斷是否有傳入該參數呢？先看看底下例子: 

<pre class="brush: php; title: ; notranslate" title="">function test($arg_1 = NULL)
{
    // 判斷 $arg_1 參數是否傳入
    $arg_1 = $arg_1 || 'test';
    echo $arg_1; 
}</pre> 你會發現上面結果會是 

<span style="color:red"><strong>1</strong></span>，而不是 test，大家會懷疑為什麼這樣寫不行呢，那是因為 || 是 <span style="color:green"><strong>boolean operators</strong></span>，他只會 return true 或是 false，而不是回傳 string，如果想這這樣寫，大概可以用 javascript 或 perl 語言來寫，javascript 可以參考之前的文章 <a href="http://blog.wu-boy.com/2009/11/javascript-%E5%9C%A8%E5%87%BD%E6%95%B8%E8%A3%A1%E8%A8%AD%E5%AE%9A%E5%8F%83%E6%95%B8%E9%A0%90%E8%A8%AD%E5%80%BC/" target="_blank">[Javascript] 在函數裡設定參數預設值</a>，然而 PHP 的正確寫法要用 ?: 來取代 

<pre class="brush: php; title: ; notranslate" title="">function test($arg_1 = NULL)
{
    // 判斷 $arg_1 參數是否傳入
    $arg_1 = (isset($arg_1)) ? $arg_1 : 'test';
    // 或者是
    $arg_1 = $arg_1 ? $arg_1 : 'test';
    echo $arg_1; 
}</pre> 請參考 

<a href="http://php.net/manual/en/language.operators.logical.php" target="_blank">Logical Operators</a>