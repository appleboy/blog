---
title: Backbone Routing pushState in IE
author: appleboy
type: post
date: 2013-05-09T05:26:58+00:00
url: /2013/05/backbone-routing-pushstate-in-ie/
dsq_thread_id:
  - 1274100121
categories:
  - Backbone.js
  - javascript
tags:
  - Backbone.js
  - IE
  - pushState

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/7059615321/" title="backbone by appleboy46, on Flickr"><img src="https://i1.wp.com/farm6.staticflickr.com/5338/7059615321_097833dea8.jpg?resize=451%2C80&#038;ssl=1" alt="backbone" data-recalc-dims="1" /></a>
</div> Backbone.js 幫忙處理掉所有瀏覽器 

<a href="http://diveintohtml5.info/history.html" target="_blank">Html5 History pushState</a> 功能，除了 IE 9 以下(含 IE 9)不支援 **history.pushState()** 跟 **history.replaceState()**，其他 Browser 幾乎都支援了，在 <a href="http://backbonejs.org" target="_blank">Backbone.js</a> 如何處理 URL 變化呢？以往透過 handle URL hash 來決定網頁要處理哪些資料，這也是 Backbone 預設的處理方式，範例如下 URL: 

> http://xxx/#!/user/list http://xxx/#!/user/add<!--more-->

<pre class="brush: jscript; title: ; notranslate" title="">Backbone.Router.extend({
  routes: {
    "!/user/:action": "user"
  },
  initialize: function() {

  },
  user: function(action, id) {
    
  }
});
Backbone.history.start();</pre> 上面方法是通解，在各種瀏覽器包含 IE 都適用，那如果是使用 history.pushState 請改成底下: URL: 

> http://xxx/user/list http://xxx/user/add<pre class="brush: jscript; title: ; notranslate" title="">Backbone.Router.extend({
  routes: {
    "/user/:action": "user"
  },
  initialize: function() {

  },
  user: function(action, id) {
    
  }
})
Backbone.history.start({pushState: true, root: '/'});</pre> 此作法在支援 html pushState 時候是可以按照您定義的 url 運作，但是在 IE 9 版本，網址就會被改成 URL: 

> http://xxx/#/user/list http://xxx/#/user/add 一樣會被加上 hash 值，該如何解決此問題呢，請把 Backbone.history.start 改成 

<pre class="brush: jscript; title: ; notranslate" title="">Backbone.history.start({pushState: true, hashChange: false, root: '/'});</pre> 設定 

**hashChange** property 為 false，讓 IE 9 不要使用 # 來取代網址，這樣就沒問題了。