---
title: Backbone.js event bind 新功能 listenTo and stopListening
author: appleboy
type: post
date: 2013-02-13T04:42:03+00:00
url: /2013/02/backbone-js-event-bind-listento-and-stoplistening/
dsq_thread_id:
  - 1080399681
categories:
  - Backbone.js
tags:
  - Backboe Event
  - Backbone.js

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/7059615321/" title="backbone by appleboy46, on Flickr"><img src="https://i1.wp.com/farm6.staticflickr.com/5338/7059615321_097833dea8.jpg?resize=451%2C80&#038;ssl=1" alt="backbone" data-recalc-dims="1" /></a>
</div> 之前寫了一篇 

<a href="http://blog.wu-boy.com/2012/04/introduction-to-backbone-js-event/" target="_blank">Backbone.js Event 事件介紹</a>，簡介 <a href="http://backbonejs.org/#Events" target="_blank">Backbone.js Events</a> 如何使用 <a href="http://backbonejs.org/#Events-on" target="_blank">on</a> 跟 <a href="http://backbonejs.org/#Events-off" target="_blank">off</a> 來處理事件，在升級 Backbone 到 0.9.9 過程中，其中一項重大新功能就是 Backbone <a href="http://backbonejs.org/#Events-listenTo" target="_blank">listenTo</a> and <a href="http://backbonejs.org/#Events-stopListening" target="_blank">stopListening</a>，大家來看看 Change logs: 

> Added listenTo and stopListening to Events. They can be used as inversion-of-control flavors of on and off, for convenient unbinding of all events an object is currently listening to. view.remove() automatically calls view.stopListening(). <!--more--> 如果大家想更了解 listenTo and stopListening 可以直接看國外這篇 

<a href="http://lostechies.com/derickbailey/2013/02/06/managing-events-as-relationships-not-just-references/" target="_blank">Managing Events As Relationships, Not Just References</a>，或者是看看<a href="https://github.com/documentcloud/backbone/commit/1191640d84b24fde145eebd10dbd49e2335db506" target="_blank">此 commit log</a>，裡面詳細介紹為什麼 Backbone 會增加此功能，其實最主要的重點是以前在 Backbone View 寫法都是像底下這樣 

<pre class="brush: jscript; title: ; notranslate" title="">initialize: function() {
    if (this.model) {
        this.model.on("change", this.render, this);
    }
},

render: function () {

}</pre> 上面我們可以看到當 model 有任何改變時，就會 trigger render function，這是最簡單的寫法，當我們移除 View 的時候，此事件就會跟著消失，但是如果是 Reference 到其他 Object 物件方法，如底下 

<pre class="brush: jscript; title: ; notranslate" title="">myObject.on("some:event", anotherObject.someHandler);</pre> 當 anotherObject 物件被移除時，這時 myObject 還是綁定事件在 anotherObject 上面，這就會出現 

<a href="lostechies.com/derickbailey/2011/09/15/zombies-run-managing-page-transitions-in-backbone-apps/" target="_blank">zombie objects in JavaScript apps</a>，當然這是有解法的，我們只需要在移除 anotherObject 之前呼叫底下程式碼: 

<pre class="brush: jscript; title: ; notranslate" title="">myObject.off("some:event", anotherObject.someHandler);</pre> 透過上面解法，我們可以將 Backbone.js View 寫法改成底下: 

<pre class="brush: jscript; title: ; notranslate" title="">Backbone.View.extend({

    initialize: function(){
        this.model.on("change:foo", this.doStuff, this);
    },

    doStuff: function(foo){
        // do stuff in response to "foo" changing
    },

    remove: function(){
        this.model.off("change:foo", this.doStuff, this);

        // call the base type's method, since we are overriding it
        Backbone.View.prototype.remove.call(this);
    }

})</pre> 將 

<a href="http://backbonejs.org/#View-remove" target="_blank">Backbone.js View Remove</a> 改寫如下 

<pre class="brush: jscript; title: ; notranslate" title="">remove: function(){
    this.model.off("change:foo", this.doStuff, this);

    // call the base type's method, since we are overriding it
    Backbone.View.prototype.remove.call(this);
}</pre> 這樣就可以解決僵屍事件，但是如果有十個事件，那在 remove 裏面就會寫的很雜，所以在 0.9.9 版本出現 listenTo 和 stopListening 來解決此問題。程式碼改成如下 

<pre class="brush: jscript; title: ; notranslate" title="">Backbone.View.extend({

    initialize: function(){
        this.listenTo(this.model, "change:foo", this.doStuff);
    },

    doStuff: function(foo){
        // do stuff in response to "foo" changing
    }

    // we don't need this. the default `remove` method calls `stopListening` for us
    // remove: function(){
        // this.stopListening();
        // ...
    //}
})</pre> 注意四大要點 1. 在 Backbone.View 裡面改用 listenTo 寫法 2. 將 this.model 傳入 listenTo function 3. 不用傳入最後一個參數 this 當作 context 變數 4. 不需要再 override Backbone.View 的 remove function 了，因為在程式碼裏面就會自動呼叫 

<span style="color:green">this.stopListening()</span> 所以以後不要在寫 <span style="color:green">this.model.on</span> 了，請全面改寫成 <span style="color:green">this.listenTo(this.model, ..)</span> 寫法。