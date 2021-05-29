---
title: JavaScript 的 if 條件判斷式
author: appleboy
type: post
date: 2013-01-25T08:26:09+00:00
url: /2013/01/you-must-be-known-js-condition/
dsq_thread_id:
  - 1045681167
categories:
  - javascript
tags:
  - javascript

---
網路上看到這篇 <a href="http://rmurphey.com/blog/2012/12/10/js-conditionals/" target="_blank">Two Things About Conditionals in JavaScript</a>，比較另我訝異的是第一點 `One: There is no else if`，該作者提到在 JavaScript 的寫法裡面沒有 else if，底下直接看例子:

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">function saySomething( msg ) {
  if ( msg === 'Hello' ) {
    console.log('Hello there');
  } else if ( msg === 'Yo' ) {
    console.log('Yo dawg');
  }
}</pre>
</div>

上面是我們一般在寫 JS 會用到的條件子句，但是實際上 JS 寫的就是

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">function saySomething( msg ) {
  if ( msg === 'Hello' ) {
    console.log('Hello there');
  } else {
    if ( msg === 'Yo' ) {
      console.log('Yo dawg');
    }
  }
}</pre>
</div>

<!--more-->

作者說原因是 `That’s because there is no else if in JavaScript`，網路上似乎查不到有人這樣說？另外不建議底下寫法:

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">if ( foo ) bar()</pre>
</div>

此寫法不易閱讀，但是如果你是寫 CoffeeScript，你會發現轉成 JS 的語法就是上面那樣。結論就是在 JS 裡面還是一樣可以寫 else if，只是大家必需要瞭解 JS 運作方式就會如上面所提。第二點 "<span style="color:green"><strong>Two: return Means Never Having to Say else</strong></span>"，在 function 裡面如果使用 return 的話，就不需要有 else 語法，舉例:

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">function howBig( num ) {
  if ( num &lt; 10 ) {
    return 'small';
  } else if ( num &gt;= 10 && num &lt; 100 ) {
    return 'medium';
  } else if ( num &gt;= 100 ) {
    return 'big';
  }
}</pre>
</div>

你可以在簡化寫成:

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">function howBig( num ) {
  if ( num &lt; 10 ) {
    return 'small';
  }

  if ( num &lt; 100 ) {
    return 'medium';
  }

  if ( num &gt;= 100 ) {
    return 'big';
  }
}</pre>
</div>

有看到嗎？前兩個條件如果都未符合，最後就可以直接 return 即可

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">function howBig( num ) {
  if ( num &lt; 10 ) {
    return 'small';
  }

  if ( num &lt; 100 ) {
    return 'medium';
  }

  return 'big';
}</pre>
</div>

這樣是不是在閱讀上更方便了呢？這點比較是在講 Coding Style。