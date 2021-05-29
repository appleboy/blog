---
title: 將 Backbone Framework 升級到 1.1.0 注意事項
author: appleboy
type: post
date: 2013-11-14T06:26:23+00:00
url: /2013/11/upgrade-backbone-framework-to-1-1-0-tips/
dsq_thread_id:
  - 1964657243
categories:
  - Backbone.js
  - javascript
tags:
  - Backbone.js
  - JavaScrpt

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/7059615321/" title="backbone by appleboy46, on Flickr"><img src="https://i1.wp.com/farm6.staticflickr.com/5338/7059615321_097833dea8.jpg?resize=451%2C80&#038;ssl=1" alt="backbone" data-recalc-dims="1" /></a>
</div>

<a href="http://backbonejs.org/" target="_blank">Backbone.js</a> 經過了半年終於在 10 月 [Release 了 1.1.0 版本][1]，這次升級最重要的一點就是，Backbone 本來在 View 有支援 options，讓你可以透過初始化過程，將自定額外的 key 及 value 帶入，並且可以隨時透過 this.options.key 的方式取得資料。直接給例子來解說好了 

<pre class="brush: jscript; title: ; notranslate" title="">this.example = new Backbone.View.extend({
  template_name: "user_edit",
  el: "#main"
});</pre> 上面是宣告 Backbone.view 的寫法，程式設計師可以傳入 object 設定，並且可以在程式任意地方，使用 

**<span style="color:green">this.example.options.template_name</span>** 方式來得到 **<span style="color:green">user_edit</span>** 值，如果是使用 Backbone 1.1.0 之前的版本都沒問題，要升級到 1.1.0，又想要此功能，請務必在 view 的宣告前就必須加一段程式碼(後面解說)。為什麼作者會拿掉呢？因為有開發者發 issue 說<a href="https://github.com/jashkenas/backbone/issues/2458" target="_blank">為什麼 View 有這功能，那 Model 為什麼沒有呢？</a>，這會讓未來加入開發的程式設計師感到困擾，所以作者就決定拿掉這塊 <!--more-->

<pre class="brush: jscript; title: ; notranslate" title="">_configure: function(options) {
  if (this.options) options = _.extend({}, _.result(this, 'options'), options);
  _.extend(this, _.pick(options, viewOptions));
  this.options = options;
},</pre> 當然，也有熱心的開發者

<a href="https://github.com/jashkenas/backbone/issues/2458#issuecomment-26162608" target="_blank">提供相容性解法</a> 

<pre class="brush: jscript; title: ; notranslate" title="">var View = Backbone.View
Backbone.View = View.extend({
  constructor: function (options) {
    this.options = options;
    View.apply(this, arguments);
  }
});</pre> 其他的修正就沒什麼地方需要注意的了，這也難怪 Backbone 一些 Plugin 尚未升級到 1.1.0 相容性的關係 XD

 [1]: http://backbonejs.org/#changelog