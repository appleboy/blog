---
title: Backbone.js Model and Collection Tregger Event
author: appleboy
type: post
date: 2012-11-22T05:10:05+00:00
url: /2012/11/backbone-js-model-and-collection-tregger-event/
dsq_thread_id:
  - 938707958
categories:
  - Backbone.js
tags:
  - Backbone.js

---
<div style="margin: 0 auto; text-align: center;">
  <a title="backbone by appleboy46, on Flickr" href="https://www.flickr.com/photos/appleboy/7059615321/"><img src="https://i1.wp.com/farm6.staticflickr.com/5338/7059615321_097833dea8.jpg?resize=451%2C80&#038;ssl=1" alt="backbone" data-recalc-dims="1" /></a>
</div> 之前寫過一篇 

<a href="http://blog.wu-boy.com/2012/04/introduction-to-backbone-js-event/" target="_blank">Backbone.js Event 的介紹</a>，最近開發專案遇到一個奇怪問題，就是只要我重複呼叫 backbone.model.fetch()，如果資料相同的話，就不會重新 trigger render() 畫面，但是專案架構是以 <a href="http://backbonejs.org" target="_blank">Backbone.js</a> MVC 下去開發，這樣畫面就會卡在 init 狀態，無法將畫面顯示出來。先來探討 Backbone.js Model 跟 Collection 預設的事件。 <!--more-->

### Catalog of Events 參考

<a href="http://backbonejs.org/#FAQ-events" target="_blank">此連結</a>可以看到所有的 Events 

<pre class="brush: bash; title: ; notranslate" title="">"add" (model, collection) — when a model is added to a collection.
"remove" (model, collection) — when a model is removed from a collection.
"reset" (collection) — when the collection's entire contents have been replaced.
"change" (model, options) — when a model's attributes have changed.
"change:[attribute]" (model, value, options) — when a specific attribute has been updated.
"destroy" (model, collection) — when a model is destroyed.
"sync" (model, collection) — triggers whenever a model has been successfully synced to the server.
"error" (model, collection) — when a model's validation fails, or a save call fails on the server.
"route:[name]" (router) — when one of a router's routes has matched.
"all" — this special event fires for any triggered event, passing the event name as the first argument.</pre> 在 bind event 時候，切記盡量不要 bind 在 all 上面，這樣畫面會被 render 好幾次，雖然肉眼看不出來，但是 render 就是跑了好幾次，Model 就綁定 change 事件即可，如果是 Collection 可以綁定 reset 事件，讓 fetch 完後可以重新顯示畫面，比較不同的是 Collection 不會去比較前一次跟這一次資料是否相同來決定是否 trigger 事件，只要重新取得資料就會 trigger reset 事件。如果是 Model 的話，就利用 

<a href="http://backbonejs.org/#Model-hasChanged" target="_blank">hasChanged()</a> 來判斷是否 trigger change 事件。 

<pre class="brush: jscript; title: ; notranslate" title="">if (!this.view_group) {
    this.view_group = new View({
        template_name: 'group_edit',
        el: '#main',
        model: this.group_model
    });
} else {
    // trigger change event if model is not changed
    if (!this.group_model.hasChanged()) {
        this.group_model.trigger('change');
    }
}

this.group_model.id = id;
this.group_model.fetch();</pre> 程式碼大致上如上，第一次 initial 不需要判斷 hasChanged()，因為 fetch 資料後肯定會跑 render()。如果有寫錯的地方，請多多指教。