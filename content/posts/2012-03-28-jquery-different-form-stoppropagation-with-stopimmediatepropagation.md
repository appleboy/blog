---
title: jQuery stopPropagation 和 stopImmediatePropagation 比較
author: appleboy
type: post
date: 2012-03-28T09:14:08+00:00
url: /2012/03/jquery-different-form-stoppropagation-with-stopimmediatepropagation/
dsq_thread_id:
  - 626898504
categories:
  - Backbone.js
  - jQuery
tags:
  - Backbone.js
  - JavaScrpt
  - jQuery

---
近期在幫公司導入 <a href="http://documentcloud.github.com/backbone/" target="_blank">Backbone.js</a> 技術，把後台全面改寫成 Javascript MVC 架構，技術包含 <a href="http://jQuery.com" target="_blank">jQuery</a> + Backbone.js + <a href="http://documentcloud.github.com/underscore/" target="_blank">Underscore.js</a> + <a href="http://mustache.github.com/" target="_blank">Mustache Template</a>，這些技術我想可以寫另外一篇 Backbone.js 初體驗，這邊就先不多說了，在 Backbone.js 的 View 架構裡，可以任意 bind events，程式碼如下:

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">RT.View = Backbone.View.extend({

    initialize: function() {   
        if (this.model) {
            this.model.bind("change", this.render, this);
        }
        if (this.collection) {
            this.collection.bind("all", this.render, this);
        }
    },

    events: { 
      'click .add': 'add',
      'click .edit': 'edit',
      'click .delete': 'delete_item',
      'click .delete_all': 'delete_all'
    },

   add: function(e) {
   
   },
)};</pre>
</div>

上面程式碼可以看到，將 click 事件綁在不同 Class 上，但是問題來了，如果同時 new 兩個 RT.View 物件，當我觸發 click 事件時，就會發生兩次一樣的效果，該如何解決這問題呢，可以透過 jQuery 的 <a href="http://api.jquery.com/event.stopPropagation/" target="_blank">stopPropagation</a> 或 <a href="http://api.jquery.com/event.stopImmediatePropagation/" target="_blank">stopImmediatePropagation</a>，這兩個其實很好區分，<span style="color:green"><strong>前者只會防止目前 Dom Tree 的上一層事件，後者則是會防止全部 Dom Tree 事件</strong></span>。

不多說直接看個例子，先以 <a href="http://api.jquery.com/event.stopPropagation/" target="_blank">stopPropagation</a> 當例子

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">
$("p").click(function(event){
  event.stopPropagation();
});
$("p").click(function(event){
  alert('test');
});
$("div").click(function(event){
  alert('test');    
}); </pre>
</div>

執行過後，你會發現點選該區域只會跳出一個 alert 視窗，如果把 `event.stopPropagation()` 換成 `event.stopImmediatePropagation()` 則完全不會跳出 alert 視窗。