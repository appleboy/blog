---
title: Backbone.js Event 事件介紹
author: appleboy
type: post
date: 2012-04-12T13:06:28+00:00
url: /2012/04/introduction-to-backbone-js-event/
dsq_thread_id:
  - 646418890
categories:
  - Backbone.js
  - jQuery
  - Uderscore.js
tags:
  - Backbone.js
  - jQuery
  - Underscore.js

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/7059615321/" title="backbone by appleboy46, on Flickr"><img src="https://i1.wp.com/farm6.staticflickr.com/5338/7059615321_097833dea8.jpg?resize=451%2C80&#038;ssl=1" alt="backbone" data-recalc-dims="1" /></a>
</div> 今天我們可以來介紹 

<a href="http://documentcloud.github.com/backbone/#Events" target="_blank">Backbone.js Event</a> 事件，介紹 Event 之前，大家可以先看看 <a href="http://blog.wu-boy.com/2012/04/backbonejs-framework-tutorial-example-1/" target="_blank">Backbone.js 的初學介紹</a>，該教學文件可以學習如何載入 Backbone.js library，利用此套件如何去制定各種事件。Backbone.js 提供了3個 method 去控制事件產生、移除、執行，分別是 <a href="http://documentcloud.github.com/backbone/#Events-on" target="_blank">on(bind)</a>、<a href="http://documentcloud.github.com/backbone/#Events-off" target="_blank">off(unbind)</a>、<a href="http://documentcloud.github.com/backbone/#Events-trigger" target="_blank">trigger</a>。文字上寫得很清楚 on 就等於 bind，off 就是 unbind，最後就是如何去 trigger 事件。底下就來簡單舉例: <!--more-->

### 綁定事件 底下例子可以幫助我們建立一個事件 html: 

<pre class="brush: xml; title: ; notranslate" title=""><div>
  <h3>
    backbone.js bind event
  </h3>
      
  
  <button class="btn btn-primary add_1">Click one event</button>
  
</div></pre> backbone.js 

<pre class="brush: jscript; title: ; notranslate" title="">Backbone.Events.on('test', function(){ alert('I am appleboy'); });
$(document).on('click', '.add_1', function(event){
    Backbone.Events.trigger('test');
});</pre> 上面可以看到我們點選按鈕後，backbone.js 會觸發已註冊的 test 事件，那也許讀者會覺得每次都要寫 Backbone.Events 這麼長的字串很不方便，我們也可以自訂變數喔，把 js 改成底下即可 

<pre class="brush: jscript; title: ; notranslate" title="">var object = {};
_.extend(object, Backbone.Events);
object.on('click_me', function(){ alert('click me'); });
$(document).on('click', '.add_2', function(event){
    object.trigger('click_me');
});</pre> 建立一個空 object，再利用 

<a href="http://documentcloud.github.com/underscore/" target="_blank">underscore.js</a> 套件 extend Backbone.Events 物件，這樣就可透過 object.on 來使用了，另外如果想要綁定全部事件，那就第一個參數帶入 **<span style="color:green">all</span>**，也就是 

<pre class="brush: jscript; title: ; notranslate" title="">object.on('all', function(){ alert('click me'); });
$(document).on('click', '.add_2', function(event){
    object.trigger('click_me2');
    object.trigger('click_me2');
});</pre> 當我們點選按鈕時，就會跳出兩次 click me 

### 移除事件 透過 Backbone.Events.off 可以移除事件內的單一 callback，或者是移除任何 event 或是移除全部 events，底下我們先建立三個事件 

<pre class="brush: jscript; title: ; notranslate" title="">var change_1 = function() {
    alert('change_1');
};
var change_2 = function() {
    alert('change_2');
};
var change_3 = function() {
    alert('change_3');
};
object.on('click_event', change_1);
object.on('click_event', change_2);
object.on('click_event', change_3);
$(document).on('click', '.add_3', function(event){
    object.trigger('click_event');
});</pre> 上面程式碼可以看到，點選按鈕後會跳出三個不同 alert 訊息，接著透過 object.off('click\_event', change\_1); 來移除事件 callback 

<pre class="brush: jscript; title: ; notranslate" title="">$(document).on('click', '.remove_1', function(event){
    object.off('click_event', change_1);
    alert('remove change_1 function');
});
$(document).on('click', '.remove_2', function(event){
    object.off('click_event', change_2);
    alert('remove change_2 function');
});
$(document).on('click', '.remove_3', function(event){
    object.off('click_event', change_3);
    alert('remove change_3 function');
});</pre> 如果不想這麼麻煩，那該如何移除事件全部 callbacks 呢，可以透過 

<pre class="brush: jscript; title: ; notranslate" title="">$(document).on('click', '.remove_event', function(event){
    object.off('click_event');
    alert('remove all event');
});</pre> 移除全部綁定的 events 可以透過 

<pre class="brush: jscript; title: ; notranslate" title="">$(document).on('click', '.remove_all_event', function(event){
    object.off();
    alert('remove all event');
});</pre>

### trigger 事件 用法很單純，如果要 trigger 單一 callback 可以透過底下: 

<pre class="brush: jscript; title: ; notranslate" title="">object.trigger('click_event');</pre> trigger 多個 callback function，利用 space 區隔開就可以了 

<pre class="brush: jscript; title: ; notranslate" title="">object.trigger('click_event_1 click_event_2 click_event_3');</pre>

<a href="http://appleboy.github.com/backbone.js/example_2/" target="_blank"><span style="font-size:1.2em">直接看 Demo</span></a>