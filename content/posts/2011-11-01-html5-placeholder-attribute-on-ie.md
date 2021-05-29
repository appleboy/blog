---
title: HTML5 placeholder attribute 在 IE 上顯示
author: appleboy
type: post
date: 2011-11-01T07:38:08+00:00
url: /2011/11/html5-placeholder-attribute-on-ie/
dsq_thread_id:
  - 458491687
categories:
  - javascript
  - jQuery
tags:
  - html5
  - javascript
  - jQuery

---
程式設計師在網頁表單上通常會設計很多提示的功能，而在 <a href="http://dev.w3.org/html5/spec/Overview.html" target="_blank">Html5</a> 提供了 <a href="http://dev.w3.org/html5/spec/Overview.html#the-placeholder-attribute" target="_blank">placeholder attribute</a> 這功能，目前 <a href="http://moztw.org/" target="_blank">FireFox</a> <a href="http://www.apple.com/tw/safari/download/" target="_blank">Safari</a> <a href="http://www.google.com/chrome?hl=zh-TW" target="_blank">Google Chrome</a> 都沒有顯示上的問題，唯獨 IE8(含以下)都沒辦法顯示這功能，所以必須透過 javascript 來解決這部份問題了，網路上找到這篇<a href="https://gist.github.com/1105055" target="_blank">解決方式</a>，底下是原始碼 

<pre class="brush: jscript; title: ; notranslate" title=""><!--[if IE]>

<![endif]--></pre> 解決原理其實很簡單，那就先將 placeholder 寫入到 input value 裡面，在 focus event 當下比對 input value 是否等於 placeholder 的值，如果是就清空，反之透過 onblur event 來寫回原先的 placeholder 值，缺點就是如果當 input type = password 的時候會很麻煩。底下提供轉成 

<a href="http://jashkenas.github.com/coffee-script/" title="CoffeeScript is a little language that compiles into JavaScript. " target="_blank">CoffeeScript</a> 的程式碼： 

<pre class="brush: jscript; title: ; notranslate" title="">add_placeholder = (id, placeholder) ->
    el = document.getElementById(id)
    el.placeholder = placeholder

    el.onfocus = () ->
        if(this.value == this.placeholder)
            this.value = ''
            el.style.cssText  = ''

    el.onblur = () ->
        if(this.value.length == 0)
            this.value = this.placeholder
            el.style.cssText = 'color:#A9A9A9;'

    el.onblur()

# Login Form
add_placeholder('myInputField', 'IE Placeholder Text')</pre> 如果有用 jQuery 的話，可以把第二個參數改寫成 

<pre class="brush: jscript; title: ; notranslate" title="">$("#input_id").attr("placeholder")</pre>