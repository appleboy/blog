---
title: Javascript 前端工具 Backbone.js Framework 初學介紹
author: appleboy
type: post
date: 2012-04-09T12:01:27+00:00
url: /2012/04/backbonejs-framework-tutorial-example-1/
dsq_thread_id:
  - 642068307
categories:
  - AJAX
  - Backbone.js
  - javascript
  - jQuery
  - Uderscore.js
tags:
  - Backbone.js
  - jQuery
  - Underscore.js

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/7059615321/" title="backbone by appleboy46, on Flickr"><img src="https://i1.wp.com/farm6.staticflickr.com/5338/7059615321_097833dea8.jpg?resize=451%2C80&#038;ssl=1" alt="backbone" data-recalc-dims="1" /></a>
</div> 我相信大家對於後端程式 

<a href="http://www.php.net" target="_blank">PHP</a>, <a href="http://www.ruby-lang.org/zh_TW/" target="_blank">Ruby</a>, <a href="http://www.python.org/" target="_blank">Python</a> .. 等語言都已經相當熟悉，進階開發者也都接觸了好用的後端 Framework 如 <a href="http://www.codeigniter.org.tw/" target="_blank">CodeIgniter</a>, <a href="http://cakephp.org/" target="_blank">CakePHP</a>, <a href="https://www.djangoproject.com/" target="_blank">Django</a>, <a href="http://rubyonrails.org/" target="_blank">Ruby on Rail</a>, <a href="http://www.yiiframework.com/" target="_blank">Yii</a>, <a href="http://www.symfony-project.org/" target="_blank">Symfony</a> .. 等，用 Framework 最大的好處並不是在 Framework 提供了大量工具，而是制定了 MVC 架構，讓專案多位開發者可以遵循，上了講了這麼多後端 MVC Framework，那麼前端呢？接下來介紹前端強大工具: <a href="http://documentcloud.github.com/backbone/" target="_blank">Backbone.js</a> 

### 什麼是 Backbone.js 簡單來說 Backbone.js 就是一套前端 Javascript Framework，它提供 MVC 架構，相信大家都玩過後端 MVC，那至於前端呢，好像比較少人提到，這就是介紹 Backbone.js 最主要的目的。Backbone.js 包含了 Model View Controller 來讓使者操作，Model 提供了key-value 結構，以及可以 binding 大量 event，開發者可以透過 RESTful JSON interface 來跟 Backbone.js 的 Model 及 Collection 搭配。如果想瞭解 Backbone.js 線上文件可以參考 

<a href="http://github.com/documentcloud/backbone/" target="_blank">GitHub 網站</a>，如果想瞭解程式碼可以參考 <a href="http://documentcloud.github.com/backbone/docs/backbone.html" target="_blank">source code 註解</a>。 <!--more-->

### 載入 Backbone.js 在使用 Backbone.js 之前，大家必須要先瞭解，Backbone.js 有使用到兩個額外的 Library，那就是 

<a href="http://documentcloud.github.com/underscore/" target="_blank">Underscore.js</a>( > 1.3.1) 及 <a href="http://jquery.com" target="_blank">jQuery</a>( > 1.4.2)，所以在 html 裡面，我們可以這樣寫 

<pre class="brush: xml; title: ; notranslate" title="">



    

<div class="well">
  <h1>
    Friend List
  </h1>
          
  
  <input type="text" name="username" value="" /><br /><button class="btn btn-primary" id="add-friend">Add Friend</button>
          
  
  <ul id="friends-list" style="margin-top:10px">
    
  </ul>
      
</div>
    
    
    


</pre>

### 使用 Backbone.js 接下來宣告 View 的作法: 

<pre class="brush: jscript; title: ; notranslate" title="">window.AppView = Backbone.View.extend({
    el: $("body"),
    initialize: function () {
        this.friends = new Friends({ view: this });
    },
    events: {
        "click #add-friend":  "showPrompt"
    },
    showPrompt: function () {
        var username = $("input[name=username]").val() || "";
        alert(username);
    }
});
var appview = new AppView;</pre> 可以看到上面，程式裡面增加了一個 Clieck event，並且點選後會轉到 showPrompt 這 callback function，直接在頁面上跳出 alert 視窗，並且顯示您輸入的名稱。接下來要新增 Model 跟 Collection。 

<pre class="brush: jscript; title: ; notranslate" title="">Friend = Backbone.Model.extend({
    name: null
});

Friends = Backbone.Collection.extend({
    initialize: function (options) {
        this.bind("add", options.view.addFriendList);
    }
});</pre> 宣告 Friend Model 用來設定使用者名稱，而 Friends Collection 則是用來設定多個 Model，初始化 initialize 時則設定 add event，當 Collection 有變動時，則會呼叫 View 裡面的 addFriendList function。完整 js 碼如下 

<pre class="brush: jscript; title: ; notranslate" title="">(function ($) {
    Friend = Backbone.Model.extend({
        name: null
    });
    
    Friends = Backbone.Collection.extend({
        initialize: function (options) {
            this.bind("add", options.view.addFriendList);
        }
    });

    window.AppView = Backbone.View.extend({
        el: $("body"),
        initialize: function () {
            this.friends = new Friends({ view: this });
        },
        events: {
            "click #add-friend":  "showPrompt",
            "click .delete":  "delete_li"
        },
        delete_li: function(e) {
            $(e.currentTarget).parent().remove();
        },
        showPrompt: function () {
            var username = $("input[name=username]").val() || "";
            this.friend_model = new Friend({'name': username});
            this.friends.add(this.friend_model);
        },
        addFriendList: function (model) {
            $("#friends-list").append("

<li style='margin-top:5px;'>
  Friend name: " + model.get('name') + " <button class='btn btn-danger delete'>Delete Friend</button>
</li>");
        }
    });
    var appview = new AppView;
})(jQuery);</pre> 當使用者按下新增按鈕時，程式將 username 設定到 model 裡，並且將此 model 丟入 Collection。而 Collection 有變動時，會呼叫 addFriendList 函式，將結果輸出到 #friends-list tag。完整程式碼可以參考: 

<a href="https://github.com/appleboy/appleboy.github.com/blob/master/backbone.js/example_1/index.html" target="_blank">Source Code</a> <a href="http://appleboy.github.com/backbone.js/example_1/" target="_blank"><span style="font-size:1.4em">線上範例(Example)</span></a>